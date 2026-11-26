"""Module I: Audited Knowledge Admin CLI (Review Queue & Pack Publisher).

No web UI — operators review pending book/Act extractions and publish signed
Module H Knowledge Packs via CLI against PostgreSQL or local SQLite.
"""

from __future__ import annotations

import argparse
import asyncio
import hashlib
import json
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from sqlalchemy import select

BACKEND_DIR = Path(__file__).resolve().parents[1] / "backend"
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from app.core.config import get_settings
from app.database.models import (
    AdminAuditLogRow,
    KnowledgePackReleaseRow,
    KnowledgeReviewItemRow,
    LegalInstrumentRow,
)
from app.database.seed import seed_database_from_packs
from app.database.session import create_engine_and_sessionmaker, init_database_schema


async def _seed_db(database_url: str | None) -> dict[str, int]:
    cfg = get_settings()
    url = database_url or cfg.effective_database_url
    engine, factory = create_engine_and_sessionmaker(url)
    await init_database_schema(engine)
    async with factory() as session:
        stats = await seed_database_from_packs(
            session,
            corpus_path=cfg.corpus_path,
            packs_dir=cfg.packs_dir,
        )
        await session.commit()
    await engine.dispose()
    return stats


async def _list_queue(database_url: str | None, status_filter: str, limit: int) -> list[dict[str, Any]]:
    cfg = get_settings()
    engine, factory = create_engine_and_sessionmaker(database_url or cfg.effective_database_url)
    await init_database_schema(engine)
    async with factory() as session:
        stmt = select(KnowledgeReviewItemRow)
        if status_filter != "all":
            stmt = stmt.where(KnowledgeReviewItemRow.verification_status == status_filter)
        rows = (
            await session.execute(stmt.order_by(KnowledgeReviewItemRow.reference_id).limit(limit))
        ).scalars().all()
        result = [
            {
                "reference_id": r.reference_id,
                "instrument_id": r.instrument_id,
                "reference_number": r.reference_number,
                "title": r.title,
                "verification_status": r.verification_status,
                "full_text_available": r.full_text_available,
            }
            for r in rows
        ]
    await engine.dispose()
    return result


async def _decide(
    database_url: str | None,
    reference_id: str,
    decision: str,
    reviewer: str,
    notes: str,
    mark_full_text: bool,
) -> dict[str, Any]:
    cfg = get_settings()
    engine, factory = create_engine_and_sessionmaker(database_url or cfg.effective_database_url)
    await init_database_schema(engine)
    new_status = "verified" if decision == "approve" else "rejected"
    async with factory() as session:
        row = (
            await session.execute(
                select(KnowledgeReviewItemRow).where(
                    KnowledgeReviewItemRow.reference_id == reference_id
                )
            )
        ).scalar_one_or_none()
        if row is None:
            await engine.dispose()
            raise SystemExit(f"Reference '{reference_id}' not found in review queue.")
        row.verification_status = new_status
        row.reviewer_id = reviewer
        row.review_notes = notes
        row.reviewed_at = datetime.now(timezone.utc)
        if decision == "approve" and mark_full_text:
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
                actor_id=reviewer,
                action=f"cli_review_{decision}",
                target_id=reference_id,
                details_json=json.dumps({"status": new_status, "notes": notes}),
            )
        )
        await session.commit()
        payload = {
            "reference_id": row.reference_id,
            "verification_status": row.verification_status,
            "full_text_available": row.full_text_available,
            "reviewer": reviewer,
        }
    await engine.dispose()
    return payload


async def _publish_pack(
    database_url: str | None,
    pack_id: str,
    pack_file: Path,
    version: str,
    reviewer: str,
) -> dict[str, Any]:
    if not pack_file.is_file():
        raise SystemExit(f"Pack file not found: {pack_file}")
    cfg = get_settings()
    raw = pack_file.read_bytes()
    sha256 = hashlib.sha256(raw).hexdigest()
    prov_count = len(json.loads(raw.decode("utf-8")).get("provisions", []))
    release_id = f"{pack_id}:{version}:{sha256[:12]}"

    engine, factory = create_engine_and_sessionmaker(database_url or cfg.effective_database_url)
    await init_database_schema(engine)
    async with factory() as session:
        session.add(
            KnowledgePackReleaseRow(
                release_id=release_id,
                pack_id=pack_id,
                version=version,
                sha256=sha256,
                provision_count=prov_count,
                published_by=reviewer,
            )
        )
        session.add(
            AdminAuditLogRow(
                actor_id=reviewer,
                action="cli_publish_pack",
                target_id=release_id,
                details_json=json.dumps({"sha256": sha256, "provision_count": prov_count}),
            )
        )
        await session.commit()
    await engine.dispose()
    return {
        "release_id": release_id,
        "sha256": sha256,
        "provision_count": prov_count,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Lex Module I Knowledge Admin CLI")
    parser.add_argument("--database-url", default=None, help="Override SQLAlchemy database URL")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("seed-db", help="Seed Knowledge Packs & review queue into DB")

    lq = sub.add_parser("list-queue", help="List Knowledge Review Queue items")
    lq.add_argument("--status", default="pending_review", choices=["pending_review", "verified", "rejected", "all"])
    lq.add_argument("--limit", type=int, default=25)

    ap = sub.add_parser("approve", help="Approve a pending review reference")
    ap.add_argument("reference_id")
    ap.add_argument("--reviewer", required=True)
    ap.add_argument("--notes", default="Verified against India Code")
    ap.add_argument("--mark-full-text", action="store_true")

    rj = sub.add_parser("reject", help="Reject a pending review reference")
    rj.add_argument("reference_id")
    rj.add_argument("--reviewer", required=True)
    rj.add_argument("--notes", required=True)

    pub = sub.add_parser("publish-pack", help="Record signed Knowledge Pack release")
    pub.add_argument("--pack-id", required=True)
    pub.add_argument("--pack-file", required=True, type=Path)
    pub.add_argument("--version", required=True)
    pub.add_argument("--reviewer", required=True)

    args = parser.parse_args(argv)
    if args.command == "seed-db":
        print(json.dumps(asyncio.run(_seed_db(args.database_url)), indent=2))
    elif args.command == "list-queue":
        print(json.dumps(asyncio.run(_list_queue(args.database_url, args.status, args.limit)), indent=2))
    elif args.command == "approve":
        print(json.dumps(asyncio.run(_decide(args.database_url, args.reference_id, "approve", args.reviewer, args.notes, args.mark_full_text)), indent=2))
    elif args.command == "reject":
        print(json.dumps(asyncio.run(_decide(args.database_url, args.reference_id, "reject", args.reviewer, args.notes, False)), indent=2))
    elif args.command == "publish-pack":
        print(json.dumps(asyncio.run(_publish_pack(args.database_url, args.pack_id, args.pack_file, args.version, args.reviewer)), indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
