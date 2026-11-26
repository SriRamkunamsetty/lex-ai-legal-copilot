from __future__ import annotations

import hashlib
import json
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query, Request, status
from sqlalchemy import desc, select

from app.authentication.device_auth import require_knowledge_admin
from app.database.models import (
    AdminAuditLogRow,
    KnowledgePackReleaseRow,
    KnowledgeReviewItemRow,
    LegalInstrumentRow,
)
from app.schemas import PackPublishRequest, ReviewDecisionRequest

router = APIRouter(prefix="/v1/admin", tags=["knowledge-admin"])


def _require_session_factory(request: Request) -> Any:
    factory = getattr(request.app.state, "session_factory", None)
    if factory is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database session factory is unavailable.",
        )
    return factory


@router.get("/review/queue")
async def list_review_queue(
    request: Request,
    verification_status: str = Query(
        default="pending_review",
        pattern="^(pending_review|verified|rejected|all)$",
    ),
    limit: int = Query(default=50, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
    _: str = Depends(require_knowledge_admin),
) -> dict[str, Any]:
    factory = _require_session_factory(request)
    async with factory() as session:
        stmt = select(KnowledgeReviewItemRow)
        if verification_status != "all":
            stmt = stmt.where(
                KnowledgeReviewItemRow.verification_status == verification_status
            )
        rows = (
            await session.execute(
                stmt.order_by(KnowledgeReviewItemRow.reference_id)
                .offset(offset)
                .limit(limit)
            )
        ).scalars().all()
        return {
            "count": len(rows),
            "items": [
                {
                    "reference_id": r.reference_id,
                    "instrument_id": r.instrument_id,
                    "reference_type": r.reference_type,
                    "reference_number": r.reference_number,
                    "title": r.title,
                    "book_page": r.book_page,
                    "full_text_available": r.full_text_available,
                    "verification_status": r.verification_status,
                    "reviewer_id": r.reviewer_id,
                    "review_notes": r.review_notes,
                }
                for r in rows
            ],
        }


@router.post("/review/{reference_id}/decision")
async def decide_review_item(
    reference_id: str,
    payload: ReviewDecisionRequest,
    request: Request,
    reviewer_id: str = Depends(require_knowledge_admin),
) -> dict[str, Any]:
    factory = _require_session_factory(request)
    now = datetime.now(timezone.utc)
    new_status = "verified" if payload.decision == "approve" else "rejected"

    async with factory() as session:
        row = (
            await session.execute(
                select(KnowledgeReviewItemRow).where(
                    KnowledgeReviewItemRow.reference_id == reference_id
                )
            )
        ).scalar_one_or_none()
        if row is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Review reference item not found.",
            )

        row.verification_status = new_status
        row.reviewer_id = reviewer_id
        row.review_notes = payload.review_notes
        row.reviewed_at = now
        if payload.decision == "approve" and payload.mark_full_text_available:
            row.full_text_available = True
            inst = (
                await session.execute(
                    select(LegalInstrumentRow).where(
                        LegalInstrumentRow.instrument_id == row.instrument_id
                    )
                )
            ).scalar_one_or_none()
            if inst is not None:
                inst.verification_status = "verified"
                inst.full_text_available = True

        session.add(
            AdminAuditLogRow(
                actor_id=reviewer_id,
                action=f"review_{payload.decision}",
                target_id=reference_id,
                details_json=json.dumps(
                    {
                        "new_status": new_status,
                        "full_text_available": row.full_text_available,
                        "notes": payload.review_notes,
                    }
                ),
            )
        )
        await session.commit()
        return {
            "reference_id": row.reference_id,
            "verification_status": row.verification_status,
            "full_text_available": row.full_text_available,
            "reviewer_id": reviewer_id,
        }


@router.post("/packs/publish")
async def publish_knowledge_pack(
    payload: PackPublishRequest,
    request: Request,
    reviewer_id: str = Depends(require_knowledge_admin),
) -> dict[str, Any]:
    factory = _require_session_factory(request)
    packs_dir = Path(request.app.state.settings.packs_dir).resolve()
    safe_filename = os.path.basename(payload.asset_filename)
    candidate = (packs_dir / safe_filename).resolve()
    if not str(candidate).startswith(str(packs_dir) + os.sep) or not candidate.is_file():
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Knowledge pack asset file not found inside packs directory.",
        )

    raw_bytes = candidate.read_bytes()
    sha256 = hashlib.sha256(raw_bytes).hexdigest()
    pack_data = json.loads(raw_bytes.decode("utf-8"))
    prov_count = len(pack_data.get("provisions", []))
    release_id = f"{payload.pack_id}:{payload.version}:{sha256[:12]}"

    async with factory() as session:
        session.add(
            KnowledgePackReleaseRow(
                release_id=release_id,
                pack_id=payload.pack_id,
                version=payload.version,
                sha256=sha256,
                provision_count=prov_count,
                published_by=reviewer_id,
            )
        )
        session.add(
            AdminAuditLogRow(
                actor_id=reviewer_id,
                action="publish_pack",
                target_id=release_id,
                details_json=json.dumps(
                    {
                        "pack_id": payload.pack_id,
                        "sha256": sha256,
                        "provision_count": prov_count,
                    }
                ),
            )
        )
        await session.commit()
        return {
            "release_id": release_id,
            "pack_id": payload.pack_id,
            "version": payload.version,
            "sha256": sha256,
            "provision_count": prov_count,
            "published_by": reviewer_id,
        }


@router.get("/audit-logs")
async def list_audit_logs(
    request: Request,
    limit: int = Query(default=50, ge=1, le=200),
    _: str = Depends(require_knowledge_admin),
) -> dict[str, Any]:
    factory = _require_session_factory(request)
    async with factory() as session:
        rows = (
            await session.execute(
                select(AdminAuditLogRow)
                .order_by(desc(AdminAuditLogRow.id))
                .limit(limit)
            )
        ).scalars().all()
        return {
            "logs": [
                {
                    "id": row.id,
                    "actor_id": row.actor_id,
                    "action": row.action,
                    "target_id": row.target_id,
                    "details": json.loads(row.details_json),
                    "created_at": row.created_at.isoformat(),
                }
                for row in rows
            ]
        }
