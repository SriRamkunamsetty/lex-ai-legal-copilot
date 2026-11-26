from __future__ import annotations

import base64
import hashlib
import hmac
import json
import secrets
import time

from fastapi import Depends, HTTPException, Request, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker

from app.authentication.device_auth import SlidingWindowRateLimiter
from app.core.config import Settings, get_settings
from app.database.models import DeviceRegistrationRow, WorkspaceUserRow


def hash_email(email: str) -> str:
    return hashlib.sha256(email.strip().lower().encode("utf-8")).hexdigest()


def hash_password(password: str, salt: bytes | None = None) -> tuple[str, str]:
    """Memory-hard scrypt password hashing with unique per-user salt."""
    if len(password) < 8 or len(password) > 128:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Password must be between 8 and 128 characters.",
        )
    used_salt = salt or secrets.token_bytes(16)
    derived = hashlib.scrypt(
        password.encode("utf-8"),
        salt=used_salt,
        n=2**14,
        r=8,
        p=1,
        dklen=32,
    )
    return (
        base64.b64encode(used_salt).decode("ascii"),
        base64.b64encode(derived).decode("ascii"),
    )


def verify_password(password: str, salt_b64: str, expected_hash_b64: str) -> bool:
    try:
        salt = base64.b64decode(salt_b64)
        expected = base64.b64decode(expected_hash_b64)
        derived = hashlib.scrypt(
            password.encode("utf-8"),
            salt=salt,
            n=2**14,
            r=8,
            p=1,
            dklen=32,
        )
        return hmac.compare_digest(derived, expected)
    except Exception:
        return False


def issue_workspace_token(
    *,
    user_id: str,
    device_id: str,
    token_version: int,
    settings: Settings,
) -> tuple[str, int]:
    expires_at = int(time.time()) + settings.device_token_ttl_seconds
    payload = json.dumps(
        {
            "typ": "workspace_session",
            "sub": user_id,
            "dev": device_id,
            "ver": token_version,
            "exp": expires_at,
        },
        separators=(",", ":"),
    ).encode("utf-8")
    sig = hmac.new(
        settings.device_token_secret.encode("utf-8"),
        payload,
        hashlib.sha256,
    ).digest()
    token = (
        base64.urlsafe_b64encode(payload).decode("ascii").rstrip("=")
        + "."
        + base64.urlsafe_b64encode(sig).decode("ascii").rstrip("=")
    )
    return token, expires_at


async def require_workspace_user(
    request: Request,
    settings: Settings = Depends(get_settings),
) -> WorkspaceUserRow:
    """Authenticates workspace bearer token & enforces active session/device status."""
    active_settings: Settings = getattr(request.app.state, "settings", settings)
    factory: async_sessionmaker[AsyncSession] | None = getattr(
        request.app.state, "session_factory", None
    )
    if factory is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Workspace storage is unavailable.",
        )

    auth_header = request.headers.get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing workspace bearer token.",
        )
    token = auth_header.removeprefix("Bearer ").strip()
    try:
        payload_b64, sig_b64 = token.split(".", 1)
        payload = base64.urlsafe_b64decode(
            payload_b64 + "=" * (-len(payload_b64) % 4)
        )
        sig = base64.urlsafe_b64decode(sig_b64 + "=" * (-len(sig_b64) % 4))
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Malformed workspace token.",
        ) from exc

    expected_sig = hmac.new(
        active_settings.device_token_secret.encode("utf-8"),
        payload,
        hashlib.sha256,
    ).digest()
    if not hmac.compare_digest(sig, expected_sig):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid workspace token signature.",
        )

    data = json.loads(payload.decode("utf-8"))
    if data.get("typ") != "workspace_session" or int(data.get("exp", 0)) < int(
        time.time()
    ):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Expired or invalid workspace session.",
        )

    user_id = str(data.get("sub", ""))
    device_id = str(data.get("dev", ""))
    token_ver = int(data.get("ver", -1))

    limiter: SlidingWindowRateLimiter = request.app.state.rate_limiter
    await limiter.check(f"user:{user_id}")

    async with factory() as session:
        user = (
            await session.execute(
                select(WorkspaceUserRow).where(WorkspaceUserRow.user_id == user_id)
            )
        ).scalar_one_or_none()
        if user is None or not user.active or user.token_version != token_ver:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Workspace session has been revoked or user deactivated.",
            )
        device = (
            await session.execute(
                select(DeviceRegistrationRow).where(
                    DeviceRegistrationRow.device_id == device_id,
                    DeviceRegistrationRow.user_id == user_id,
                )
            )
        ).scalar_one_or_none()
        if device is None or device.revoked:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Registered device has been revoked.",
            )

    request.state.device_hash = f"usr:{user_id[:10]}"
    return user
