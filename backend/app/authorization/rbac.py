from __future__ import annotations

from fastapi import HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.models import OrgMembershipRow

ROLE_RANK: dict[str, int] = {
    "viewer": 1,
    "advocate": 2,
    "admin": 3,
    "owner": 4,
}


async def require_org_role(
    session: AsyncSession,
    *,
    org_id: str,
    user_id: str,
    minimum_role: str = "viewer",
) -> OrgMembershipRow:
    """Enforces multi-tenant Organization RBAC closest to data access."""
    membership = (
        await session.execute(
            select(OrgMembershipRow).where(
                OrgMembershipRow.org_id == org_id,
                OrgMembershipRow.user_id == user_id,
            )
        )
    ).scalar_one_or_none()
    if membership is None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied: user does not belong to this organization.",
        )

    user_rank = ROLE_RANK.get(membership.role, 0)
    required_rank = ROLE_RANK.get(minimum_role, 999)
    if user_rank < required_rank:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"Insufficient role permissions ({minimum_role} required).",
        )
    return membership
