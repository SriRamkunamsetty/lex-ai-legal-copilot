from __future__ import annotations

import base64
import hashlib
import hmac
import json
import time
from collections import defaultdict, deque
from fastapi import Depends, HTTPException, Request, status

from app.config import Settings, get_settings


def issue_device_token(device_id: str, settings: Settings) -> tuple[str, int]:
    """Issues a short-lived HMAC-SHA256 signed device token."""
    expires_at = int(time.time()) + settings.device_token_ttl_seconds
    payload = json.dumps({"sub": device_id, "exp": expires_at}, separators=(",", ":")).encode()
    sig = hmac.new(
        settings.device_token_secret.encode(),
        payload,
        hashlib.sha256,
    ).digest()
    token = (
        base64.urlsafe_b64encode(payload).decode().rstrip("=")
        + "."
        + base64.urlsafe_b64encode(sig).decode().rstrip("=")
    )
    return token, expires_at


def verify_device_token(token: str, settings: Settings) -> str:
    """Verifies signature and expiration, returning the device ID."""
    try:
        payload_b64, sig_b64 = token.split(".", 1)
        payload = base64.urlsafe_b64decode(payload_b64 + "=" * (-len(payload_b64) % 4))
        sig = base64.urlsafe_b64decode(sig_b64 + "=" * (-len(sig_b64) % 4))
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Malformed device token",
        ) from exc

    expected_sig = hmac.new(
        settings.device_token_secret.encode(),
        payload,
        hashlib.sha256,
    ).digest()
    if not hmac.compare_digest(sig, expected_sig):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid device token signature",
        )

    data = json.loads(payload.decode())
    if int(data.get("exp", 0)) < int(time.time()):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Expired device token",
        )
    device_id = str(data.get("sub", "")).strip()
    if not device_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing device subject",
        )
    return device_id


class SlidingWindowRateLimiter:
    """In-memory per-device sliding-window rate limiter."""

    def __init__(self, max_requests: int, window_seconds: int = 60) -> None:
        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self._hits: dict[str, deque[float]] = defaultdict(deque)

    def check(self, key: str) -> None:
        now = time.monotonic()
        cutoff = now - self.window_seconds
        bucket = self._hits[key]
        while bucket and bucket[0] < cutoff:
            bucket.popleft()
        if len(bucket) >= self.max_requests:
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail="Rate limit exceeded for device",
            )
        bucket.append(now)


def require_device_auth(
    request: Request,
    settings: Settings = Depends(get_settings),
) -> str:
    auth_header = request.headers.get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing Bearer device token",
        )
    token = auth_header.removeprefix("Bearer ").strip()
    device_id = verify_device_token(token, settings)
    limiter: SlidingWindowRateLimiter = request.app.state.rate_limiter
    limiter.check(device_id)
    request.state.device_hash = hashlib.sha256(device_id.encode()).hexdigest()[:12]
    return device_id
