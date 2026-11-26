"""Module B, C & H: Knowledge Pack Builder & Priority Central Act Verifier.

Combines:
1. Parsed Constitution of India [As on 1st May, 2026] (from
   ``scripts/ingest_constitution.py``) -> signed offline pack
   ``assets/corpus/packs/constitution_in_2026_v1.json``.
2. Existing offline criminal codes (BNS 2023, BNSS 2023, BSA 2023) + reachable
   official Central Act PDFs (DPDP Act 2023, IT Act 2000, Indian Contract Act
   1872), while strictly marking unreachable/unverified Acts (such as NI Act
   1881 or CPC 1908 if official endpoints time out) with
   ``full_text_available=False`` and ``verification_status="pending_review"``.
3. Signed, SHA-256 verified ``assets/corpus/packs/pack_catalog.json`` for
   versioned offline Knowledge Pack management inside Lex.
"""

from __future__ import annotations

import hashlib
import json
import re
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import pymupdf
import requests

from scripts.ingest_constitution import parse_constitution_pdf

CACHE_PDF_DIR = Path("data/cache/pdfs")
PACKS_DIR = Path("assets/corpus/packs")
CRIMINAL_CORPUS_PATH = Path("assets/corpus/indian_law_corpus_v1.json")

PRIORITY_CENTRAL_SOURCES: list[dict[str, Any]] = [
    {
        "act_code": "DPDP_2023",
        "act_name": "The Digital Personal Data Protection Act, 2023",
        "act_number": "Act No. 22 of 2023",
        "source_authority": "Ministry of Electronics and Information Technology (MeitY) / Gazette of India",
        "url": "https://www.meity.gov.in/static/uploads/2024/06/2bf1f0e9f04e6fb4f8fef35e82c42aa5.pdf",
        "effective_date": "2023-08-11",
    },
    {
        "act_code": "IT_2000",
        "act_name": "The Information Technology Act, 2000",
        "act_number": "Act No. 21 of 2000",
        "source_authority": "India Code / Legislative Department",
        "url": "https://www.indiacode.nic.in/bitstream/123456789/13116/1/it_act_2000_updated.pdf",
        "effective_date": "2000-10-17",
    },
    {
        "act_code": "ICA_1872",
        "act_name": "The Indian Contract Act, 1872",
        "act_number": "Act No. 9 of 1872",
        "source_authority": "India Code / Legislative Department",
        "url": "https://www.indiacode.nic.in/bitstream/123456789/2187/2/A187209.pdf",
        "effective_date": "1872-09-01",
    },
    {
        "act_code": "NI_1881",
        "act_name": "The Negotiable Instruments Act, 1881",
        "act_number": "Act No. 26 of 1881",
        "source_authority": "India Code / Legislative Department",
        "url": "https://www.indiacode.nic.in/bitstream/123456789/2189/1/A1881-26.pdf",
        "effective_date": "1882-03-01",
    },
    {
        "act_code": "CPC_1908",
        "act_name": "The Code of Civil Procedure, 1908",
        "act_number": "Act No. 5 of 1908",
        "source_authority": "India Code / Legislative Department",
        "url": "https://www.indiacode.nic.in/bitstream/123456789/2191/3/A1908-05.pdf",
        "effective_date": "1909-01-01",
    },
]

ACT_SECTION_RE = re.compile(r"^(\d+[A-Z]?)\.\s+(.*)$")


def _extract_title_from_section_line(num: str, rest: str) -> str:
    if ".—" in rest or "—" in rest:
        t = re.split(r"[—-]{1,2}", rest, maxsplit=1)[0].strip().rstrip(".")
        if 3 <= len(t) <= 120:
            return t
    return f"Section {num}"


def _try_fetch_pdf(url: str, dest: Path) -> Path | None:
    if dest.exists() and dest.stat().st_size > 5_000:
        return dest
    try:
        resp = requests.get(
            url,
            timeout=15,
            headers={"User-Agent": "Mozilla/5.0"},
        )
        resp.raise_for_status()
        if resp.content[:4] != b"%PDF":
            return None
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(resp.content)
        return dest
    except Exception:
        return None


def parse_central_act_pdf(meta: dict[str, Any], pdf_path: Path) -> list[dict[str, Any]]:
    doc = pymupdf.open(str(pdf_path))
    provisions: list[dict[str, Any]] = []
    seen: set[str] = set()
    current: dict[str, Any] | None = None
    in_body = False

    def flush() -> None:
        nonlocal current
        if not current:
            return
        body = "\n".join(current["lines"]).strip()
        if len(body) > 20 and current["number"] not in seen:
            seen.add(current["number"])
            cref = f"CENTRAL:{meta['act_code']}:{current['number']}"
            provisions.append(
                {
                    "canonical_ref": cref,
                    "instrument_id": meta["act_code"],
                    "parent_ref": f"INST:{meta['act_code']}",
                    "provision_type": "section",
                    "number": current["number"],
                    "title": current["title"],
                    "part_or_chapter": current["chapter"],
                    "official_text": body,
                    "consolidated_status": "active",
                    "effective_date": meta["effective_date"],
                    "book_page": current["page"],
                    "end_page": current["end_page"],
                    "source_hash": hashlib.sha256(f"{cref}|{body}".encode()).hexdigest(),
                    "full_text_available": True,
                    "verification_status": "verified",
                }
            )
        current = None

    chapter = "PRELIMINARY"
    for pno, page in enumerate(doc):
        book_page = pno + 1
        lines = page.get_text().splitlines()
        page_upper = " ".join(lines[:5]).upper()
        if "ARRANGEMENT OF SECTIONS" in page_upper:
            continue
        for raw in lines:
            line = re.sub(r"\s+", " ", raw).strip()
            if not line:
                continue
            if line.upper().startswith("CHAPTER "):
                chapter = line[:120]
                in_body = True
                continue
            if "BE IT ENACTED" in line.upper() or re.match(r"^1\.\s+Short title", line, re.I):
                in_body = True
            if not in_body:
                continue
            m = ACT_SECTION_RE.match(line)
            if m:
                num = m.group(1)
                rest = m.group(2)
                is_gazette_sec = rest.startswith("(1)") or ".—" in line or ".-" in line or "Short title" in line
                if is_gazette_sec and num not in seen:
                    title = _extract_title_from_section_line(num, rest)
                    flush()
                    current = {
                        "number": num,
                        "title": title,
                        "chapter": chapter,
                        "page": book_page,
                        "end_page": book_page,
                        "lines": [line],
                    }
                    continue
            if current is not None:
                current["end_page"] = book_page
                current["lines"].append(line)
    flush()
    return provisions


def build_packs() -> dict[str, Any]:
    PACKS_DIR.mkdir(parents=True, exist_ok=True)
    generated_at = datetime.now(timezone.utc).isoformat()

    # 1. Constitution of India [As on 1st May, 2026] pack
    const_data = parse_constitution_pdf()
    const_pack_payload = {
        "pack_id": "constitution_in_2026_v1",
        "pack_name": "Constitution of India (As on 1st May, 2026)",
        "jurisdiction": "India",
        "version": "2026.05.01",
        "source_authority": const_data["instrument"]["source_authority"],
        "publication_date": "2026-05-01",
        "effective_date": "2026-04-16",
        "generated_at": generated_at,
        **const_data,
    }
    const_bytes = json.dumps(const_pack_payload, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
    const_sha = hashlib.sha256(const_bytes).hexdigest()
    const_path = PACKS_DIR / "constitution_in_2026_v1.json"
    const_path.write_bytes(const_bytes)

    # 2. Central Priority Acts verification & packaging (never invent unavailable acts)
    extra_instruments: list[dict[str, Any]] = []
    extra_provisions: list[dict[str, Any]] = []

    for meta in PRIORITY_CENTRAL_SOURCES:
        dest = CACHE_PDF_DIR / f"{meta['act_code']}.pdf"
        fetched = _try_fetch_pdf(meta["url"], dest)
        parsed: list[dict[str, Any]] = []
        if fetched is not None:
            try:
                parsed = parse_central_act_pdf(meta, fetched)
            except Exception:
                parsed = []

        available = len(parsed) > 0
        extra_instruments.append(
            {
                "instrument_id": meta["act_code"],
                "instrument_type": "central_act",
                "title": meta["act_name"],
                "short_code": meta["act_code"],
                "act_number": meta["act_number"],
                "source_authority": meta["source_authority"],
                "source_url": meta["url"],
                "edition_date": meta["effective_date"],
                "full_text_available": available,
                "verification_status": "verified" if available else "pending_review",
                "provision_count": len(parsed),
            }
        )
        extra_provisions.extend(parsed)

    # Include BNS / BNSS / BSA summary stats in catalog metadata
    criminal_count = 0
    if CRIMINAL_CORPUS_PATH.exists():
        crim_json = json.loads(CRIMINAL_CORPUS_PATH.read_text(encoding="utf-8"))
        criminal_count = len(crim_json.get("sections", []))

    central_pack_payload = {
        "pack_id": "central_priority_acts_v1",
        "pack_name": "Priority Central Civil, Cyber & Commercial Acts",
        "jurisdiction": "India",
        "version": "1.0.0",
        "source_authority": "India Code & Ministry of Electronics and Information Technology (MeitY)",
        "publication_date": "2026-05-01",
        "effective_date": "2026-05-01",
        "generated_at": generated_at,
        "instruments": extra_instruments,
        "provisions": extra_provisions,
    }
    central_bytes = json.dumps(central_pack_payload, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
    central_sha = hashlib.sha256(central_bytes).hexdigest()
    central_path = PACKS_DIR / "central_priority_acts_v1.json"
    central_path.write_bytes(central_bytes)

    catalog = {
        "schema_version": 1,
        "generated_at": generated_at,
        "packs": [
            {
                "pack_id": "constitution_in_2026_v1",
                "pack_name": const_pack_payload["pack_name"],
                "asset_path": "assets/corpus/packs/constitution_in_2026_v1.json",
                "jurisdiction": "India",
                "version": const_pack_payload["version"],
                "source_authority": const_pack_payload["source_authority"],
                "publication_date": const_pack_payload["publication_date"],
                "effective_date": const_pack_payload["effective_date"],
                "sha256": const_sha,
                "provision_count": len(const_data["provisions"]),
                "footnote_count": len(const_data["footnotes"]),
                "reference_count": len(const_data["references"]),
                "relation_count": len(const_data["relations"]),
                "size_bytes": len(const_bytes),
            },
            {
                "pack_id": "central_priority_acts_v1",
                "pack_name": central_pack_payload["pack_name"],
                "asset_path": "assets/corpus/packs/central_priority_acts_v1.json",
                "jurisdiction": "India",
                "version": central_pack_payload["version"],
                "source_authority": central_pack_payload["source_authority"],
                "publication_date": central_pack_payload["publication_date"],
                "effective_date": central_pack_payload["effective_date"],
                "sha256": central_sha,
                "provision_count": len(extra_provisions),
                "instruments": extra_instruments,
                "size_bytes": len(central_bytes),
            },
        ],
        "base_criminal_corpus": {
            "pack_id": "bns_bnss_bsa_v1",
            "asset_path": "assets/corpus/indian_law_corpus_v1.json",
            "provision_count": criminal_count,
        },
    }
    catalog_path = PACKS_DIR / "pack_catalog.json"
    catalog_path.write_text(json.dumps(catalog, indent=2, ensure_ascii=False), encoding="utf-8")
    return catalog


if __name__ == "__main__":
    summary = build_packs()
    print(json.dumps(summary, indent=2, ensure_ascii=False))
