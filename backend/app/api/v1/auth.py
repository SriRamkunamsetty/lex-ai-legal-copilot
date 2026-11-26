from __future__ import annotations

from fastapi import APIRouter, Request

from app.authentication.device_auth import issue_device_token
from app.schemas import DeviceTokenRequest, DeviceTokenResponse

router = APIRouter(prefix="/v1/auth", tags=["auth"])


@router.post("/device-token", response_model=DeviceTokenResponse)
async def create_device_token(
    payload: DeviceTokenRequest,
    request: Request,
) -> DeviceTokenResponse:
    settings = request.app.state.settings
    limiter = request.app.state.rate_limiter
    client_host = request.client.host if request.client else "local"
    await limiter.check(f"token:{client_host}:{payload.device_id}")
    token, expires_at = issue_device_token(payload.device_id, settings)
    return DeviceTokenResponse(token=token, expires_at=expires_at)
