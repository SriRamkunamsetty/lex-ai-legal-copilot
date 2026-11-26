from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker

from app.corpus_store import CorpusStore
from app.database.models import (
    LegalFootnoteRow,
    LegalInstrumentRow,
    LegalProvisionRow,
    LegalRelationRow,
    provision_row_to_dict,
)
from app.database.types import cosine_similarity, deterministic_legal_embedding

_ACT_NUMBER_RE = re.compile(
    r"\b(?:article|art\.?)\s*(\d+[A-Z]{0,2})|\b(?:bns|bnss|bsa|dpdp_?2023|it_?2000|ni_?1881|ica_?1872|cpc_?1908)\s*(?:section|sec\.?|s\.?)?\s*(\d+[A-Z]?)",
    re.IGNORECASE,
)

_UNVERIFIED_EXTERNAL_HINTS: dict[str, tuple[str, str]] = {
    "ni act": ("NI_1881", "The Negotiable Instruments Act, 1881"),
    "negotiable instruments": ("NI_1881", "The Negotiable Instruments Act, 1881"),
    "138": ("NI_1881", "The Negotiable Instruments Act, 1881 (referenced in corpus/checklists; full Act text pending review)"),
    "contract act": ("ICA_1872", "The Indian Contract Act, 1872"),
    "cpc": ("CPC_1908", "The Code of Civil Procedure, 1908"),
    "civil procedure": ("CPC_1908", "The Code of Civil Procedure, 1908"),
    "ninth schedule": ("CONST:SCH:9", "Ninth Schedule External Acts (book lists titles only; full Act texts not loaded offline)"),
}


class LegalCorpusService:
    """Unified statutory & constitutional repository backed by SQLAlchemy + pgvector and packs."""

    def __init__(
        self,
        *,
        corpus_store: CorpusStore,
        packs_dir: str | Path | None = None,
        session_factory: async_sessionmaker[AsyncSession] | None = None,
    ) -> None:
        self._store = corpus_store
        self._session_factory = session_factory
        self._provisions_by_ref: dict[str, dict[str, Any]] = {}
        self._footnotes_by_ref: dict[str, list[dict[str, Any]]] = {}
        self._unverified_instruments: dict[str, dict[str, Any]] = {}
        self._vectors: dict[str, list[float]] = {}
        self._load_in_memory_packs(packs_dir)

    def _load_in_memory_packs(self, packs_dir: str | Path | None) -> None:
        for s in self._store.sections:
            ref = f"CENTRAL:{s['act_code'].upper()}:{str(s['section_number']).strip()}"
            entry = {
                **s,
                "canonical_ref": ref,
                "instrument_id": s["act_code"].upper(),
                "consolidated_status": s.get("consolidated_status", "active"),
                "verification_status": "verified",
                "full_text_available": True,
            }
            self._provisions_by_ref[ref] = entry
            self._vectors[ref] = deterministic_legal_embedding(
                f"{entry['act_code']} {entry['section_number']} {entry['title']} {entry['text'][:900]}"
            )

        if not packs_dir:
            return
        pdir = Path(packs_dir)
        if not pdir.exists():
            return
        for pfile in sorted(pdir.glob("*.json")):
            if pfile.name == "pack_catalog.json":
                continue
            pack = json.loads(pfile.read_text(encoding="utf-8"))
            inst_map: dict[str, dict[str, Any]] = {}
            if "instrument" in pack and isinstance(pack["instrument"], dict):
                inst_map[pack["instrument"]["instrument_id"]] = pack["instrument"]
            for inst in pack.get("instruments", []):
                inst_map[inst["instrument_id"]] = inst
                if not inst.get("full_text_available", False):
                    self._unverified_instruments[inst["instrument_id"]] = inst

            for prov in pack.get("provisions", []):
                ref = str(prov["canonical_ref"])
                inst = inst_map.get(prov["instrument_id"], {})
                entry = {
                    "canonical_ref": ref,
                    "instrument_id": prov["instrument_id"],
                    "act_code": inst.get("short_code", prov["instrument_id"]),
                    "act_name": inst.get("title", prov["instrument_id"]),
                    "section_number": str(prov.get("number", "")),
                    "title": prov.get("title", ref),
                    "chapter": prov.get("part_or_chapter", ""),
                    "text": prov.get("official_text", ""),
                    "book_page": prov.get("book_page"),
                    "consolidated_status": prov.get("consolidated_status", "active"),
                    "verification_status": prov.get("verification_status", "verified"),
                    "full_text_available": bool(prov.get("full_text_available", True)),
                    "source_url": inst.get("source_url", ""),
                    "legacy_mapping": prov.get("legacy_mapping"),
                }
                self._provisions_by_ref[ref] = entry
                self._vectors[ref] = deterministic_legal_embedding(
                    f"{ref} {entry['title']} {entry['text'][:900]}"
                )

            for fn in pack.get("footnotes", []):
                self._footnotes_by_ref.setdefault(fn["provision_ref"], []).append(fn)

    @property
    def total_sections(self) -> int:
        return max(len(self._store.sections), len(self._provisions_by_ref))

    def get_section(self, act: str, number: str) -> dict[str, Any] | None:
        direct = self._store.get_section(act, number)
        if direct is not None:
            return direct
        norm_act = act.upper().strip()
        norm_num = number.strip().upper()
        candidates = [
            f"CONST:ART:{norm_num}" if norm_act in {"CONST", "CONSTITUTION", "CONST_IN_2026"} else "",
            f"CONST:SCH:{norm_num}" if norm_act in {"CONST_SCH", "SCHEDULE"} else "",
            f"CENTRAL:{norm_act}:{norm_num}",
        ]
        for ref in candidates:
            if ref and ref in self._provisions_by_ref:
                return self._provisions_by_ref[ref]
        return None

    def get_footnotes(self, canonical_ref: str) -> list[dict[str, Any]]:
        return list(self._footnotes_by_ref.get(canonical_ref, []))

    def detect_unverified_external_mentions(self, query: str) -> list[dict[str, Any]]:
        q = query.lower()
        alerts: list[dict[str, Any]] = []
        seen: set[str] = set()
        for phrase, (code, label) in _UNVERIFIED_EXTERNAL_HINTS.items():
            if phrase in q and code not in seen:
                inst = self._unverified_instruments.get(code)
                if code == "CONST:SCH:9" or inst is not None:
                    seen.add(code)
                    alerts.append(
                        {
                            "instrument_id": code,
                            "title": inst["title"] if inst else label,
                            "full_text_available": False,
                            "verification_status": (
                                inst.get("verification_status", "pending_review")
                                if inst
                                else "reference_only"
                            ),
                        }
                    )
        return alerts

    async def hybrid_search(
        self,
        query: str,
        *,
        limit: int = 6,
    ) -> dict[str, Any]:
        """Hybrid vector + keyword search across SQLAlchemy DB (if populated) and packs."""
        q_vec = deterministic_legal_embedding(query)
        tokens = [
            t.lower()
            for t in re.findall(r"[a-zA-Z0-9_]+", query)
            if len(t) >= 2
        ]

        # Try DB query when session_factory is attached and has provisions
        if self._session_factory is not None:
            try:
                async with self._session_factory() as session:
                    rows = (
                        await session.execute(
                            select(LegalProvisionRow, LegalInstrumentRow).join(
                                LegalInstrumentRow,
                                LegalProvisionRow.instrument_id
                                == LegalInstrumentRow.instrument_id,
                            )
                        )
                    ).all()
                    if rows:
                        scored_db: list[tuple[float, dict[str, Any]]] = []
                        for prov_row, inst_row in rows:
                            d = provision_row_to_dict(prov_row, inst_row)
                            sim = cosine_similarity(q_vec, prov_row.embedding)
                            kw = self._keyword_score(tokens, d)
                            total = sim * 5.0 + kw
                            if total > 0.25 or not tokens:
                                scored_db.append((total, d))
                        scored_db.sort(key=lambda item: item[0], reverse=True)
                        top = [item[1] for item in scored_db[:limit]]
                        footnotes: list[dict[str, Any]] = []
                        kg_relations: list[dict[str, Any]] = []
                        refs = [t["canonical_ref"] for t in top]
                        if refs:
                            fn_rows = (
                                await session.execute(
                                    select(LegalFootnoteRow).where(
                                        LegalFootnoteRow.provision_ref.in_(refs)
                                    )
                                )
                            ).scalars().all()
                            footnotes = [
                                {
                                    "footnote_id": f.footnote_id,
                                    "provision_ref": f.provision_ref,
                                    "footnote_type": f.footnote_type,
                                    "note_text": f.note_text,
                                    "book_page": f.book_page,
                                }
                                for f in fn_rows
                            ]
                            rel_rows = (
                                await session.execute(
                                    select(LegalRelationRow).where(
                                        LegalRelationRow.source_entity_id.in_(refs)
                                    )
                                )
                            ).scalars().all()
                            kg_relations = [
                                {
                                    "source": r.source_entity_id,
                                    "relation_type": r.relation_type,
                                    "target": r.target_entity_id,
                                }
                                for r in rel_rows[:12]
                            ]
                        return {
                            "provisions": top,
                            "footnotes": footnotes,
                            "relations": kg_relations,
                            "unloaded_external_acts": self.detect_unverified_external_mentions(
                                query
                            ),
                        }
            except Exception:
                # Fall through cleanly to in-memory pack/corpus retrieval
                pass

        # In-memory pack + CorpusStore fallback
        scored_mem: list[tuple[float, dict[str, Any]]] = []
        explicit_refs = self._extract_explicit_refs(query)
        for ref, entry in self._provisions_by_ref.items():
            sim = cosine_similarity(q_vec, self._vectors.get(ref))
            kw = self._keyword_score(tokens, entry)
            ref_boost = 25.0 if ref in explicit_refs else 0.0
            total = ref_boost + sim * 5.0 + kw
            if total > 0.25 or not tokens:
                scored_mem.append((total, entry))

        scored_mem.sort(key=lambda item: item[0], reverse=True)
        top_mem = [item[1] for item in scored_mem[:limit]]
        footnotes_mem: list[dict[str, Any]] = []
        for item in top_mem:
            footnotes_mem.extend(self.get_footnotes(item["canonical_ref"]))
        return {
            "provisions": top_mem,
            "footnotes": footnotes_mem,
            "relations": [],
            "unloaded_external_acts": self.detect_unverified_external_mentions(query),
        }

    def _extract_explicit_refs(self, query: str) -> set[str]:
        refs: set[str] = set()
        for match in _ACT_NUMBER_RE.finditer(query):
            art_num = match.group(1)
            sec_num = match.group(2)
            if art_num:
                refs.add(f"CONST:ART:{art_num.upper()}")
            if sec_num:
                for act in ("BNS", "BNSS", "BSA", "DPDP_2023", "IT_2000"):
                    refs.add(f"CENTRAL:{act}:{sec_num.upper()}")
        return refs

    @staticmethod
    def _keyword_score(tokens: list[str], entry: dict[str, Any]) -> float:
        if not tokens:
            return 0.1
        num = str(entry.get("section_number", "")).lower()
        title = str(entry.get("title", "")).lower()
        text = str(entry.get("text", ""))[:700].lower()
        act = str(entry.get("act_code", "")).lower()
        hay = f"{act} {num} {title} {text}"
        score = 0.0
        for tok in tokens:
            if tok == num:
                score += 10.0
            if tok == act:
                score += 4.0
            if tok in title:
                score += 3.5
            if tok in hay:
                score += 1.0
        return score
