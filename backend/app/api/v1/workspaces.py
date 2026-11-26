from __future__ import annotations

import secrets
from datetime import datetime, timezone
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker

from app.authentication.workspace_auth import (
    hash_email,
    hash_password,
    issue_workspace_token,
    require_workspace_user,
    verify_password,
)
from app.authorization.rbac import require_org_role
from app.database.models import (
    DeviceRegistrationRow,
    EncryptedSyncBlobRow,
    OrganizationRow,
    OrgMembershipRow,
    WorkspaceUserRow,
)
from app.schemas import (
    AddOrgMemberRequest,
    CreateOrgRequest,
    SyncPushRequest,
    WorkspaceAuthResponse,
    WorkspaceLoginRequest,
    WorkspaceRegisterRequest,
)

router = APIRouter(prefix="/v1", tags=["workspaces-e2ee-sync"])


def _require_factory(request: Request) -> async_sessionmaker[AsyncSession]:
    factory: async_sessionmaker[AsyncSession] | None = getattr(
        request.app.state, "session_factory", None
    )
    if factory is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Workspace storage is unavailable.",
        )
    return factory


@router.post("/accounts/register", response_model=WorkspaceAuthResponse)
async def register_workspace_user(
    payload: WorkspaceRegisterRequest,
    request: Request,
) -> WorkspaceAuthResponse:
    factory = _require_factory(request)
    settings = request.app.state.settings
    await request.app.state.rate_limiter.check(f"reg:{payload.device_id}")

    e_hash = hash_email(payload.email)
    salt_b64, pwd_hash_b64 = hash_password(payload.password)

    async with factory() as session:
        existing = (
            await session.execute(
                select(WorkspaceUserRow).where(WorkspaceUserRow.email_hash == e_hash)
            )
        ).scalar_one_or_none()
        if existing is not None:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="An account for this identifier already exists.",
            )

        user_id = f"usr_{secrets.token_hex(12)}"
        user = WorkspaceUserRow(
            user_id=user_id,
            email_hash=e_hash,
            display_label=payload.display_label,
            password_salt_b64=salt_b64,
            password_hash_b64=pwd_hash_b64,
            active=True,
            token_version=1,
        )
        session.add(user)
        session.add(
            DeviceRegistrationRow(
                device_id=payload.device_id,
                user_id=user_id,
                device_name=payload.device_name,
                platform=payload.platform,
                revoked=False,
            )
        )
        await session.commit()

        token, expires_at = issue_workspace_token(
            user_id=user_id,
            device_id=payload.device_id,
            token_version=1,
            settings=settings,
        )
        return WorkspaceAuthResponse(
            user_id=user_id,
            token=token,
            expires_at=expires_at,
        )


@router.post("/accounts/login", response_model=WorkspaceAuthResponse)
async def login_workspace_user(
    payload: WorkspaceLoginRequest,
    request: Request,
) -> WorkspaceAuthResponse:
    factory = _require_factory(request)
    settings = request.app.state.settings
    e_hash = hash_email(payload.email)
    await request.app.state.rate_limiter.check(f"login:{e_hash[:16]}")

    async with factory() as session:
        user = (
            await session.execute(
                select(WorkspaceUserRow).where(WorkspaceUserRow.email_hash == e_hash)
            )
        ).scalar_one_or_none()
        if (
            user is None
            or not user.active
            or not verify_password(
                payload.password,
                user.password_salt_b64,
                user.password_hash_b64,
            )
        ):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid credentials.",
            )

        device = (
            await session.execute(
                select(DeviceRegistrationRow).where(
                    DeviceRegistrationRow.device_id == payload.device_id,
                )
            )
        ).scalar_one_or_none()
        if device is None:
            session.add(
                DeviceRegistrationRow(
                    device_id=payload.device_id,
                    user_id=user.user_id,
                    device_name=payload.device_name,
                    platform=payload.platform,
                    revoked=False,
                )
            )
        else:
            if device.user_id != user.user_id:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Device ID is bound to another account.",
                )
            device.revoked = False
            device.last_seen_at = datetime.now(timezone.utc)
        await session.commit()

        token, expires_at = issue_workspace_token(
            user_id=user.user_id,
            device_id=payload.device_id,
            token_version=user.token_version,
            settings=settings,
        )
        return WorkspaceAuthResponse(
            user_id=user.user_id,
            token=token,
            expires_at=expires_at,
        )


@router.post("/accounts/logout-all")
async def logout_all_sessions(
    request: Request,
    user: WorkspaceUserRow = Depends(require_workspace_user),
) -> dict[str, Any]:
    factory = _require_factory(request)
    async with factory() as session:
        db_user = (
            await session.execute(
                select(WorkspaceUserRow).where(
                    WorkspaceUserRow.user_id == user.user_id
                )
            )
        ).scalar_one()
        db_user.token_version += 1
        await session.commit()
    return {"status": "all_sessions_revoked"}


@router.get("/accounts/devices")
async def list_registered_devices(
    request: Request,
    user: WorkspaceUserRow = Depends(require_workspace_user),
) -> dict[str, Any]:
    factory = _require_factory(request)
    async with factory() as session:
        rows = (
            await session.execute(
                select(DeviceRegistrationRow).where(
                    DeviceRegistrationRow.user_id == user.user_id
                )
            )
        ).scalars().all()
        return {
            "devices": [
                {
                    "device_id": d.device_id,
                    "device_name": d.device_name,
                    "platform": d.platform,
                    "revoked": d.revoked,
                    "last_seen_at": d.last_seen_at.isoformat(),
                }
                for d in rows
            ]
        }


@router.post("/accounts/devices/{device_id}/revoke")
async def revoke_registered_device(
    device_id: str,
    request: Request,
    user: WorkspaceUserRow = Depends(require_workspace_user),
) -> dict[str, Any]:
    factory = _require_factory(request)
    async with factory() as session:
        device = (
            await session.execute(
                select(DeviceRegistrationRow).where(
                    DeviceRegistrationRow.device_id == device_id,
                    DeviceRegistrationRow.user_id == user.user_id,
                )
            )
        ).scalar_one_or_none()
        if device is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Device not found for user.",
            )
        device.revoked = True
        await session.commit()
    return {"device_id": device_id, "revoked": True}


@router.post("/orgs")
async def create_organization(
    payload: CreateOrgRequest,
    request: Request,
    user: WorkspaceUserRow = Depends(require_workspace_user),
) -> dict[str, Any]:
    factory = _require_factory(request)
    org_id = f"org_{secrets.token_hex(8)}"
    async with factory() as session:
        session.add(
            OrganizationRow(
                org_id=org_id,
                name=payload.name,
                created_by_user_id=user.user_id,
            )
        )
        session.add(
            OrgMembershipRow(
                org_id=org_id,
                user_id=user.user_id,
                role="owner",
            )
        )
        await session.commit()
    return {"org_id": org_id, "name": payload.name, "role": "owner"}


@router.post("/orgs/{org_id}/members")
async def add_organization_member(
    org_id: str,
    payload: AddOrgMemberRequest,
    request: Request,
    user: WorkspaceUserRow = Depends(require_workspace_user),
) -> dict[str, Any]:
    factory = _require_factory(request)
    async with factory() as session:
        await require_org_role(
            session,
            org_id=org_id,
            user_id=user.user_id,
            minimum_role="admin",
        )
        target_user = (
            await session.execute(
                select(WorkspaceUserRow).where(
                    WorkspaceUserRow.user_id == payload.user_id
                )
            )
        ).scalar_one_or_none()
        if target_user is None or not target_user.active:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Target user does not exist.",
            )
        existing = (
            await session.execute(
                select(OrgMembershipRow).where(
                    OrgMembershipRow.org_id == org_id,
                    OrgMembershipRow.user_id == payload.user_id,
                )
            )
        ).scalar_one_or_none()
        if existing is None:
            session.add(
                OrgMembershipRow(
                    org_id=org_id,
                    user_id=payload.user_id,
                    role=payload.role,
                )
            )
        else:
            existing.role = payload.role
        await session.commit()
    return {"org_id": org_id, "user_id": payload.user_id, "role": payload.role}


@router.get("/orgs/{org_id}")
async def get_organization_details(
    org_id: str,
    request: Request,
    user: WorkspaceUserRow = Depends(require_workspace_user),
) -> dict[str, Any]:
    factory = _require_factory(request)
    async with factory() as session:
        membership = await require_org_role(
            session,
            org_id=org_id,
            user_id=user.user_id,
            minimum_role="viewer",
        )
        org = (
            await session.execute(
                select(OrganizationRow).where(OrganizationRow.org_id == org_id)
            )
        ).scalar_one()
        members = (
            await session.execute(
                select(OrgMembershipRow).where(OrgMembershipRow.org_id == org_id)
            )
        ).scalars().all()
        return {
            "org_id": org.org_id,
            "name": org.name,
            "my_role": membership.role,
            "members": [
                {"user_id": m.user_id, "role": m.role} for m in members
            ],
        }


@router.post("/sync/push")
async def push_e2ee_sync_blobs(
    payload: SyncPushRequest,
    request: Request,
    user: WorkspaceUserRow = Depends(require_workspace_user),
) -> dict[str, Any]:
    factory = _require_factory(request)
    accepted: list[str] = []
    async with factory() as session:
        for item in payload.blobs:
            if item.org_id is not None:
                await require_org_role(
                    session,
                    org_id=item.org_id,
                    user_id=user.user_id,
                    minimum_role="advocate",
                )
                blob_id = f"org:{item.org_id}:{item.record_type}:{item.record_id}"
            else:
                blob_id = f"usr:{user.user_id}:{item.record_type}:{item.record_id}"

            existing = (
                await session.execute(
                    select(EncryptedSyncBlobRow).where(
                        EncryptedSyncBlobRow.blob_id == blob_id
                    )
                )
            ).scalar_one_or_none()
            if existing is None:
                session.add(
                    EncryptedSyncBlobRow(
                        blob_id=blob_id,
                        owner_user_id=user.user_id,
                        org_id=item.org_id,
                        record_type=item.record_type,
                        record_id=item.record_id,
                        version=item.version,
                        nonce_b64=item.nonce_b64,
                        ciphertext_b64=item.ciphertext_b64,
                        tag_b64=item.tag_b64,
                        key_epoch=item.key_epoch,
                        deleted=item.deleted,
                    )
                )
            else:
                if item.org_id is None and existing.owner_user_id != user.user_id:
                    raise HTTPException(
                        status_code=status.HTTP_403_FORBIDDEN,
                        detail="Cannot modify another user's private encrypted blob.",
                    )
                existing.version = max(existing.version + 1, item.version)
                existing.nonce_b64 = item.nonce_b64
                existing.ciphertext_b64 = item.ciphertext_b64
                existing.tag_b64 = item.tag_b64
                existing.key_epoch = item.key_epoch
                existing.deleted = item.deleted
                existing.updated_at = datetime.now(timezone.utc)
            accepted.append(blob_id)
        await session.commit()
    return {"accepted_count": len(accepted), "blob_ids": accepted}


@router.get("/sync/pull")
async def pull_e2ee_sync_blobs(
    request: Request,
    org_id: str | None = Query(default=None, max_length=64),
    user: WorkspaceUserRow = Depends(require_workspace_user),
) -> dict[str, Any]:
    factory = _require_factory(request)
    async with factory() as session:
        if org_id is not None:
            await require_org_role(
                session,
                org_id=org_id,
                user_id=user.user_id,
                minimum_role="viewer",
            )
            stmt = select(EncryptedSyncBlobRow).where(
                EncryptedSyncBlobRow.org_id == org_id
            )
        else:
            stmt = select(EncryptedSyncBlobRow).where(
                EncryptedSyncBlobRow.owner_user_id == user.user_id,
                EncryptedSyncBlobRow.org_id.is_(None),
            )
        rows = (await session.execute(stmt)).scalars().all()
        return {
            "count": len(rows),
            "blobs": [
                {
                    "blob_id": r.blob_id,
                    "org_id": r.org_id,
                    "record_type": r.record_type,
                    "record_id": r.record_id,
                    "version": r.version,
                    "nonce_b64": r.nonce_b64,
                    "ciphertext_b64": r.ciphertext_b64,
                    "tag_b64": r.tag_b64,
                    "key_epoch": r.key_epoch,
                    "deleted": r.deleted,
                }
                for r in rows
            ],
        }
