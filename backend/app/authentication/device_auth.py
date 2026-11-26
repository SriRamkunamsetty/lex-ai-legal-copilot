from __future__ import annotations

import base64
import hashlib
import hmac
import json
import time
from collections import defaultdict, deque

from fastapi import Depends, HTTPException, Request, status
from sqlalchemy import delete, func, select
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker

from app.core.config import Settings, get_settings
from app.database.models import RateLimitHitRow


def issue_device_token(device_id: str, settings: Settings) -> tuple[str, int]:
    """Issues a short-lived HMAC-SHA256 signed device token."""
    expires_at = int(time.time()) + settings.device_token_ttl_seconds
    payload = json.dumps(
        {"sub": device_id, "exp": expires_at},
        separators=(",", ":"),
    ).encode()
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
        payload = base64.urlsafe_b64decode(
            payload_b64 + "=" * (-len(payload_b64) % 4)
        )
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
    """Sliding-window rate limiter backed by PostgreSQL/SQLite when available."""

    def __init__(
        self,
        max_requests: int,
        window_seconds: int = 60,
        session_factory: async_sessionmaker[AsyncSession] | None = None,
    ) -> None:
        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self._session_factory = session_factory
        self._schema_ensured = False
        self._hits: dict[str, deque[float]] = defaultdict(deque)

    async def check(self, key: str) -> None:
        key_hash = hashlib.sha256(key.encode("utf-8")).hexdigest()[:32]
        if self._session_factory is not None:
            now_epoch = int(time.time())
            cutoff_epoch = now_epoch - self.window_seconds
            async with self._session_factory() as session:
                if not self._schema_ensured:
                    conn = await session.connection()
                    await conn.run_sync(
                        lambda sync_conn: RateLimitHitRow.__table__.create(
                            sync_conn,
                            checkfirst=True,
                        )
                    )
                    self._schema_ensured = True
                await session.execute(
                    delete(RateLimitHitRow).where(
                        RateLimitHitRow.created_epoch < cutoff_epoch
                    )
                )
                count_res = await session.execute(
                    select(func.count(RateLimitHitRow.id)).where(
                        RateLimitHitRow.device_hash == key_hash,
                        RateLimitHitRow.created_epoch >= cutoff_epoch,
                    )
                )
                count = int(count_res.scalar() or 0)
                if count >= self.max_requests:
                    await session.commit()
                    raise HTTPException(
                        status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                        detail="Rate limit exceeded for device",
                    )
                session.add(
                    RateLimitHitRow(
                        device_hash=key_hash,
                        created_epoch=now_epoch,
                    )
                )
                await session.commit()
                return

        now = time.monotonic()
        cutoff = now - self.window_seconds
        bucket = self._hits[key_hash]
        while bucket and bucket[0] < cutoff:
            bucket.popleft()
        if len(bucket) >= self.max_requests:
            raise HTTPException(
                status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                detail="Rate limit exceeded for device",
            )
        bucket.append(now)


async def require_device_auth(
    request: Request,
    settings: Settings = Depends(get_settings),
) -> str:
    active_settings: Settings = getattr(request.app.state, "settings", settings)
    auth_header = request.headers.get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing Bearer device token",
        )
    token = auth_header.removeprefix("Bearer ").strip()
    device_id = verify_device_token(token, active_settings)
    limiter: SlidingWindowRateLimiter = request.app.state.rate_limiter
    await limiter.check(device_id)
    request.state.device_hash = hashlib.sha256(device_id.encode()).hexdigest()[:12]
    return device_id


async def require_knowledge_admin(
    request: Request,
    settings: Settings = Depends(get_settings),
) -> str:
    """Fail-closed constant-time SHA-256 verification for Module I Admin API."""
    active_settings: Settings = getattr(request.app.state, "settings", settings)
    expected_hash = (active_settings.admin_api_key_hash or "").strip().lower()
    if len(expected_hash) != 64:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Knowledge Admin API key is not configured on this server.",
        )

    presented = (request.headers.get("X-Lex-Admin-Key") or "").strip()
    if not presented:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing X-Lex-Admin-Key header.",
        )
    presented_hash = hashlib.sha256(presented.encode("utf-8")).hexdigest().lower()
    if not hmac.compare_digest(presented_hash, expected_hash):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid Knowledge Admin credentials.",
        )

    reviewer_id = (request.headers.get("X-Lex-Reviewer-Id") or "admin-api").strip()[:128]
    request.state.device_hash = f"admin:{reviewer_id}"
    return reviewer_id
