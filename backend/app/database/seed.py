from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.database.models import (
    KnowledgeReviewItemRow,
    LegalEntityRow,
    LegalFootnoteRow,
    LegalInstrumentRow,
    LegalProvisionRow,
    LegalRelationRow,
)
from app.database.types import deterministic_legal_embedding


async def seed_database_from_packs(
    session: AsyncSession,
    *,
    corpus_path: str | Path,
    packs_dir: str | Path,
) -> dict[str, int]:
    """Idempotently loads Knowledge Packs and review queue entries into PostgreSQL/SQLite."""
    stats = {"instruments": 0, "provisions": 0, "footnotes": 0, "review_items": 0}
    existing_inst = {
        row[0]
        for row in (await session.execute(select(LegalInstrumentRow.instrument_id))).all()
    }
    existing_prov = {
        row[0]
        for row in (await session.execute(select(LegalProvisionRow.canonical_ref))).all()
    }
    existing_fn = {
        row[0]
        for row in (await session.execute(select(LegalFootnoteRow.footnote_id))).all()
    }
    existing_rev = {
        row[0]
        for row in (await session.execute(select(KnowledgeReviewItemRow.reference_id))).all()
    }

    # 1. Seed base BNS/BNSS/BSA corpus JSON
    cpath = Path(corpus_path)
    if cpath.exists():
        data = json.loads(cpath.read_text(encoding="utf-8"))
        sections: list[dict[str, Any]] = data.get("sections", [])
        acts_seen: dict[str, str] = {}
        for sec in sections:
            code = str(sec["act_code"]).upper()
            if code not in acts_seen:
                acts_seen[code] = str(sec.get("act_name", code))
        for code, name in acts_seen.items():
            if code not in existing_inst:
                session.add(
                    LegalInstrumentRow(
                        instrument_id=code,
                        instrument_type="central_act",
                        title=name,
                        short_code=code,
                        full_text_available=True,
                        verification_status="verified",
                    )
                )
                existing_inst.add(code)
                stats["instruments"] += 1

        for sec in sections:
            act_code = str(sec["act_code"]).upper()
            num = str(sec["section_number"]).strip()
            ref = f"CENTRAL:{act_code}:{num}"
            if ref in existing_prov:
                continue
            text_val = str(sec.get("text", ""))
            title_val = str(sec.get("title", f"Section {num}"))
            session.add(
                LegalProvisionRow(
                    canonical_ref=ref,
                    instrument_id=act_code,
                    provision_type="section",
                    number=num,
                    title=title_val[:512],
                    part_or_chapter=str(sec.get("chapter", ""))[:256],
                    official_text=text_val,
                    consolidated_status="active",
                    legacy_mapping=sec.get("legacy_mapping"),
                    source_url=str(sec.get("source_url", ""))[:512],
                    verification_status="verified",
                    embedding=deterministic_legal_embedding(
                        f"{act_code} {num} {title_val} {text_val[:1200]}"
                    ),
                )
            )
            existing_prov.add(ref)
            stats["provisions"] += 1

    # 2. Seed rich Knowledge Packs (Constitution 2026 & Priority Central Acts)
    pdir = Path(packs_dir)
    for pack_file in sorted(pdir.glob("*.json")) if pdir.exists() else []:
        if pack_file.name == "pack_catalog.json":
            continue
        pack = json.loads(pack_file.read_text(encoding="utf-8"))

        instruments: list[dict[str, Any]] = []
        if "instrument" in pack and isinstance(pack["instrument"], dict):
            instruments.append(pack["instrument"])
        instruments.extend(pack.get("instruments", []))

        for inst in instruments:
            iid = str(inst["instrument_id"])
            if iid not in existing_inst:
                session.add(
                    LegalInstrumentRow(
                        instrument_id=iid,
                        instrument_type=str(inst.get("instrument_type", "central_act")),
                        title=str(inst["title"])[:256],
                        short_code=str(inst.get("short_code", iid))[:64],
                        act_number=str(inst.get("act_number", ""))[:64],
                        source_authority=str(inst.get("source_authority", ""))[:256],
                        source_url=str(inst.get("source_url", ""))[:512],
                        edition_date=str(inst.get("edition_date", ""))[:32],
                        full_text_available=bool(inst.get("full_text_available", False)),
                        verification_status=str(
                            inst.get("verification_status", "pending_review")
                        ),
                    )
                )
                existing_inst.add(iid)
                stats["instruments"] += 1

            # Enqueue unverified/unloaded external acts in Module I review queue
            review_key = f"REV:INST:{iid}"
            if not inst.get("full_text_available", False) and review_key not in existing_rev:
                session.add(
                    KnowledgeReviewItemRow(
                        reference_id=review_key,
                        instrument_id=iid,
                        reference_type="central_act_fulltext",
                        reference_number=str(inst.get("act_number", iid)),
                        title=str(inst["title"])[:512],
                        source_text=str(inst.get("source_url", "Official source pending fetch")),
                        full_text_available=False,
                        verification_status=str(
                            inst.get("verification_status", "pending_review")
                        ),
                    )
                )
                existing_rev.add(review_key)
                stats["review_items"] += 1

        for prov in pack.get("provisions", []):
            ref = str(prov["canonical_ref"])
            if ref in existing_prov:
                continue
            text_val = str(prov.get("official_text", ""))
            title_val = str(prov.get("title", ref))
            session.add(
                LegalProvisionRow(
                    canonical_ref=ref,
                    instrument_id=str(prov["instrument_id"]),
                    provision_type=str(prov.get("provision_type", "section")),
                    number=str(prov.get("number", "")),
                    title=title_val[:512],
                    part_or_chapter=str(prov.get("part_or_chapter", ""))[:256],
                    book_page=prov.get("book_page"),
                    official_text=text_val,
                    consolidated_status=str(prov.get("consolidated_status", "active")),
                    legacy_mapping=prov.get("legacy_mapping"),
                    source_url=str(prov.get("source_url", ""))[:512],
                    verification_status=str(prov.get("verification_status", "verified")),
                    embedding=deterministic_legal_embedding(
                        f"{ref} {title_val} {text_val[:1200]}"
                    ),
                )
            )
            existing_prov.add(ref)
            stats["provisions"] += 1

        for fn in pack.get("footnotes", []):
            fid = str(fn["footnote_id"])
            if fid in existing_fn or fn.get("provision_ref") not in existing_prov:
                continue
            session.add(
                LegalFootnoteRow(
                    footnote_id=fid,
                    provision_ref=str(fn["provision_ref"]),
                    footnote_marker=str(fn.get("footnote_marker", ""))[:32],
                    footnote_type=str(fn.get("footnote_type", "amendment"))[:32],
                    note_text=str(fn.get("note_text", "")),
                    book_page=fn.get("book_page"),
                )
            )
            existing_fn.add(fid)
            stats["footnotes"] += 1

        # Enqueue sample/pending book-extracted external references for Module I review
        for ref_item in pack.get("references", []):
            rid = str(ref_item["reference_id"])
            if rid in existing_rev:
                continue
            if ref_item.get("verification_status") == "pending_review":
                session.add(
                    KnowledgeReviewItemRow(
                        reference_id=rid,
                        instrument_id=str(ref_item.get("parent_document", "CONST_IN_2026"))[:64],
                        reference_type=str(ref_item.get("reference_type", "external_act"))[:48],
                        reference_number=str(ref_item.get("reference_number", ""))[:128],
                        title=str(ref_item.get("title", ""))[:512],
                        source_text=str(ref_item.get("source_text", ""))[:4000],
                        book_page=ref_item.get("book_page"),
                        full_text_available=bool(ref_item.get("full_text_available", False)),
                        verification_status="pending_review",
                    )
                )
                existing_rev.add(rid)
                stats["review_items"] += 1

        existing_ent = {
            row[0]
            for row in (await session.execute(select(LegalEntityRow.entity_id))).all()
        }
        for ent in pack.get("entities", []):
            eid = str(ent["entity_id"])
            if eid in existing_ent:
                continue
            session.add(
                LegalEntityRow(
                    entity_id=eid,
                    entity_type=str(ent.get("entity_type", "provision"))[:48],
                    label=str(ent.get("label", eid))[:256],
                    metadata_json=json.dumps(ent.get("metadata", {})),
                )
            )
            existing_ent.add(eid)

        existing_rel = {
            row[0]
            for row in (await session.execute(select(LegalRelationRow.relation_id))).all()
        }
        for rel in pack.get("relations", []):
            rid = str(rel["relation_id"])
            if rid in existing_rel:
                continue
            src = str(rel.get("from_entity") or rel.get("source_entity_id") or "")
            dst = str(rel.get("to_entity") or rel.get("target_entity_id") or "")
            ev = str(rel.get("source_ref") or rel.get("evidence_ref") or "")
            session.add(
                LegalRelationRow(
                    relation_id=rid,
                    source_entity_id=src[:128],
                    relation_type=str(rel["relation_type"])[:48],
                    target_entity_id=dst[:128],
                    evidence_ref=ev[:128],
                )
            )
            existing_rel.add(rid)

    await session.flush()
    return stats
