"""Module A, B & D: Complete Indian Constitution Book Ingestion Service.

Parses ``data/source_books/constitution_india_2026.pdf`` (THE CONSTITUTION OF
INDIA [As on 1st May, 2026], 402 pages, Ministry of Law and Justice,
Legislative Department) using PyMuPDF layout & typography analysis into:

1. Canonical Constitutional provisions (Preamble, Parts I-XXII, Articles 1-395
   including lettered Articles & bracket-omitted Articles, First-Twelfth
   Schedules, Appendices I-III) with verbatim ``official_text`` and separated
   ``footnotes``.
2. Classified lifecycle states (``active``, ``omitted_repealed``,
   ``unnotified_prospective``, ``struck_down_judicial``).
3. Extracted Constitutional Amendments, Constitution Orders (C.O.), Supreme
   Court judicial invalidations/citations, and referenced External Statutes
   (including all Ninth Schedule entries 1-284), explicitly marked
   ``full_text_available=False`` and ``verification_status="pending_review"``
   whenever full statutory text is outside the Constitution book.
4. Relational Knowledge Graph entities and verified edges (``amends``,
   ``omits``, ``struck_down_by``, ``interprets``, ``enacted_under``, ``repeals``,
   ``cross_references``).

Never invents or fabricates statutory text not verbatim in the PDF.
"""

from __future__ import annotations

import hashlib
import json
import re
from dataclasses import asdict, dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import pymupdf

DEFAULT_PDF_PATH = Path("data/source_books/constitution_india_2026.pdf")
DEFAULT_OUT_PATH = Path("data/processed/constitution_india_2026.json")

PART_RE = re.compile(r"^PART\s+([IVXLC]+[A-Z]*)\b(.*)$", re.I)
# Matches active bold/numbered articles e.g. "21A. Protection...", "1[239AA. ...",
# "368. 1[Power...", as well as omitted articles e.g. "[31. Compulsory...]", "1[[31D. ...]"
ARTICLE_START_RE = re.compile(
    r"^(?:\d{0,2}\s*\[)?(\[?\d+[A-Z]*\]?)\.\s*(.*)$"
)
# Footnote start at bottom of page (font size <= 8.2): "1. Subs. by..." or "* Sub-clause..."
FOOTNOTE_START_RE = re.compile(r"^(?:(\d+)\.|(\*+|[\uf02a]+))\s+(.+)$")
NINTH_SCH_ENTRY_RE = re.compile(r"^(?:\d{0,2}\s*\[)?(\d+[A-Z]?)\.\s+(.*)$")
SCHEDULE_HEADING_RE = re.compile(
    r"^(?:\d+\[)?(FIRST|SECOND|THIRD|FOURTH|FIFTH|SIXTH|SEVENTH|EIGHTH|NINTH|TENTH|ELEVENTH|TWELFTH)\s+SCHEDULE\b",
    re.I,
)
APPENDIX_HEADING_RE = re.compile(r"^APPENDIX\s+([IVX]+)\b(.*)$", re.I)

SCHEDULE_ROMAN_TO_NUM = {
    "FIRST": "1",
    "SECOND": "2",
    "THIRD": "3",
    "FOURTH": "4",
    "FIFTH": "5",
    "SIXTH": "6",
    "SEVENTH": "7",
    "EIGHTH": "8",
    "NINTH": "9",
    "TENTH": "10",
    "ELEVENTH": "11",
    "TWELFTH": "12",
}

AMENDMENT_REF_RE = re.compile(
    r"Constitution\s+\(([^)]+?Amendment[^)]*?)\)\s+Act,\s*(\d{4})",
    re.I,
)
CO_REF_RE = re.compile(r"\bC\.O\.\s*(\d+)\b")
JUDICIAL_REF_RE = re.compile(
    r"((?:AIR\s+\d{4}\s+SC\s+\d+)|(?:\(\d{4}\)\s+\d+\s+SCC\s+\d+))",
    re.I,
)
EXTERNAL_ACT_RE = re.compile(
    r"((?:[A-Z][A-Za-z,&'\-\(\)\s]{3,90}?)(?:Act|Regulation|Code|Order),\s*\d{4}(?:\s*\([^)]+\))?)"
)


@dataclass
class ProvisionRecord:
    canonical_ref: str
    instrument_id: str
    parent_ref: str
    provision_type: str
    number: str
    title: str
    part_or_chapter: str
    official_text: str
    consolidated_status: str
    effective_date: str | None
    book_page: int
    end_page: int
    source_hash: str
    full_text_available: bool = True
    verification_status: str = "verified_in_book"


@dataclass
class FootnoteRecord:
    footnote_id: str
    provision_ref: str
    footnote_number: str
    book_page: int
    footnote_type: str
    note_text: str
    referenced_instruments: list[str] = field(default_factory=list)


@dataclass
class ExtractedReference:
    reference_id: str
    reference_type: str
    title: str
    reference_number: str
    parent_document: str
    book_page: int
    source_text: str
    extraction_method: str
    confidence: str
    full_text_available: bool
    verification_status: str
    source_provision_ref: str


@dataclass
class GraphEntity:
    entity_id: str
    entity_type: str
    canonical_ref: str
    label: str
    full_text_available: bool
    metadata: dict[str, Any] = field(default_factory=dict)


@dataclass
class GraphRelation:
    relation_id: str
    from_entity: str
    relation_type: str
    to_entity: str
    source_ref: str
    book_page: int
    confidence: str
    verification_status: str


def _clean_text(s: str) -> str:
    s = s.replace("\uf02a", "*").replace("\u00a0", " ")
    s = re.sub(r"[ \t]+", " ", s)
    return s.strip()


def _is_header_line(y0: float, text: str) -> bool:
    upper = text.upper().strip()
    if y0 < 52 and (
        "THE CONSTITUTION OF INDIA" in upper
        or re.fullmatch(r"\d{1,3}", upper) is not None
        or (upper.startswith("(") and upper.endswith(")"))
    ):
        return True
    if upper == "THE CONSTITUTION OF INDIA":
        return True
    if re.fullmatch(r"\(PART\s+[IVXLC]+.*\)", upper):
        return True
    if re.fullmatch(r"_+", text.strip()):
        return True
    return False


def _extract_page_bands(page: pymupdf.Page) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Splits a page's lines into body lines (>=8.5pt or superscript anchors)
    and bottom-of-page footnote lines (<=8.2pt in bottom zone / numbered footnote start).
    """
    body_lines: list[dict[str, Any]] = []
    footnote_lines: list[dict[str, Any]] = []

    raw_dict = page.get_text("dict")
    in_footnote_zone = False

    for block in raw_dict.get("blocks", []):
        if "lines" not in block:
            continue
        for line in block["lines"]:
            y0 = float(line["bbox"][1])
            spans = line.get("spans", [])
            non_empty = [s for s in spans if s.get("text", "").strip()]
            if not non_empty:
                continue
            text = _clean_text("".join(s["text"] for s in spans))
            if not text or _is_header_line(y0, text):
                continue

            # Dominant non-superscript font size on this line
            sizes = [float(s["size"]) for s in non_empty if float(s["size"]) > 6.6]
            dom_size = max(sizes) if sizes else float(non_empty[0]["size"])
            is_bold = any(
                (int(s.get("flags", 0)) & 16) != 0 and float(s["size"]) >= 8.4
                for s in non_empty
            )

            if y0 > 180 and dom_size <= 8.25:
                if FOOTNOTE_START_RE.match(text) or in_footnote_zone:
                    in_footnote_zone = True
                    footnote_lines.append({"y0": y0, "size": dom_size, "text": text})
                    continue

            if in_footnote_zone and dom_size <= 8.25:
                footnote_lines.append({"y0": y0, "size": dom_size, "text": text})
            else:
                body_lines.append(
                    {"y0": y0, "size": dom_size, "bold": is_bold, "text": text}
                )

    return body_lines, footnote_lines


def _classify_footnote(note_text: str) -> str:
    lower = note_text.lower()
    if any(
        k in lower
        for k in (
            "struck down",
            "declared unconstitutional",
            "invalid",
            "minerva mills",
            "kesavananda",
            "air 19",
            "air 20",
            "scc ",
        )
    ):
        return "judicial_invalidation"
    if "date yet to be notified" in lower or "date to be notified" in lower:
        return "commencement_unnotified"
    if "c.o." in lower or "constitution (" in lower and "order" in lower:
        return "constitutional_order"
    if any(k in lower for k in ("ins. by", "subs. by", "omitted by", "added by", "renumbered")):
        return "amendment"
    return "editorial"


def _extract_effective_date(text: str) -> str | None:
    m = re.search(r"\bw\.e\.f\.\s*(\d{1,2}[-./]\d{1,2}[-./]\d{2,4})", text, re.I)
    if m:
        return m.group(1)
    return None


def _hash_text(s: str) -> str:
    return hashlib.sha256(s.encode("utf-8")).hexdigest()


def parse_constitution_pdf(pdf_path: Path = DEFAULT_PDF_PATH) -> dict[str, Any]:
    """Extracts complete Constitution provisions, footnotes, references, and
    Knowledge Graph nodes/edges from [pdf_path].
    """
    if not pdf_path.exists():
        raise FileNotFoundError(f"Constitution PDF not found at {pdf_path}")

    doc = pymupdf.open(str(pdf_path))
    total_pages = len(doc)

    provisions: list[ProvisionRecord] = []
    footnotes: list[FootnoteRecord] = []
    references: list[ExtractedReference] = []
    entities: dict[str, GraphEntity] = {}
    relations: list[GraphRelation] = []
    seen_ref_keys: set[str] = set()
    seen_rel_keys: set[str] = set()

    def ensure_entity(
        entity_id: str,
        entity_type: str,
        canonical_ref: str,
        label: str,
        *,
        full_text_available: bool,
        metadata: dict[str, Any] | None = None,
    ) -> None:
        if entity_id not in entities:
            entities[entity_id] = GraphEntity(
                entity_id=entity_id,
                entity_type=entity_type,
                canonical_ref=canonical_ref,
                label=label,
                full_text_available=full_text_available,
                metadata=metadata or {},
            )

    def add_relation(
        from_entity: str,
        relation_type: str,
        to_entity: str,
        source_ref: str,
        book_page: int,
        verification_status: str = "verified_in_book",
    ) -> None:
        key = f"{from_entity}|{relation_type}|{to_entity}"
        if key in seen_rel_keys:
            return
        seen_rel_keys.add(key)
        relations.append(
            GraphRelation(
                relation_id=f"REL_{hashlib.sha1(key.encode()).hexdigest()[:12]}",
                from_entity=from_entity,
                relation_type=relation_type,
                to_entity=to_entity,
                source_ref=source_ref,
                book_page=book_page,
                confidence="high" if verification_status == "verified_in_book" else "review_required",
                verification_status=verification_status,
            )
        )

    def add_reference(
        reference_type: str,
        title: str,
        reference_number: str,
        book_page: int,
        source_text: str,
        source_provision_ref: str,
        *,
        full_text_available: bool,
        verification_status: str,
    ) -> None:
        key = f"{reference_type}|{title[:80]}|{reference_number}|{source_provision_ref}|{book_page}"
        if key in seen_ref_keys:
            return
        seen_ref_keys.add(key)
        references.append(
            ExtractedReference(
                reference_id=f"REF_{hashlib.sha1(key.encode()).hexdigest()[:12]}",
                reference_type=reference_type,
                title=title.strip()[:200],
                reference_number=reference_number.strip(),
                parent_document="Constitution of India",
                book_page=book_page,
                source_text=source_text.strip()[:400],
                extraction_method="pdf_text",
                confidence="high" if full_text_available else "review_required",
                full_text_available=full_text_available,
                verification_status=verification_status,
                source_provision_ref=source_provision_ref,
            )
        )

    ensure_entity(
        "INST:CONSTITUTION_INDIA_2026",
        "constitution",
        "CONST:INDIA",
        "The Constitution of India (As on 1st May, 2026)",
        full_text_available=True,
        metadata={
            "source_authority": "Ministry of Law and Justice, Legislative Department",
            "edition_date": "2026-05-01",
            "total_pages": total_pages,
        },
    )

    current_part = "PREAMBLE"
    current_mode = "preamble"  # preamble | articles | schedules | appendices
    current_prov: dict[str, Any] | None = None
    last_prov_ref = "CONST:PREAMBLE"
    footnote_counter = 0

    def flush_provision() -> None:
        nonlocal current_prov, last_prov_ref
        if not current_prov:
            return
        body = "\n".join(current_prov["lines"]).strip()
        if not body and current_prov["status"] != "omitted_repealed":
            current_prov = None
            return
        cref = current_prov["canonical_ref"]
        last_prov_ref = cref
        rec = ProvisionRecord(
            canonical_ref=cref,
            instrument_id="CONST_IN_2026",
            parent_ref="INST:CONSTITUTION_INDIA_2026",
            provision_type=current_prov["provision_type"],
            number=current_prov["number"],
            title=current_prov["title"][:220],
            part_or_chapter=current_prov["part_or_chapter"],
            official_text=body or f"[{current_prov['number']}] {current_prov['title']}",
            consolidated_status=current_prov["status"],
            effective_date=current_prov.get("effective_date"),
            book_page=current_prov["start_page"],
            end_page=current_prov["end_page"],
            source_hash=_hash_text(f"{cref}|{body}"),
        )
        provisions.append(rec)
        ensure_entity(
            cref,
            current_prov["provision_type"],
            cref,
            f"{current_prov['number']} — {rec.title}",
            full_text_available=True,
            metadata={
                "book_page": rec.book_page,
                "status": rec.consolidated_status,
            },
        )
        add_relation(
            cref,
            "part_of",
            "INST:CONSTITUTION_INDIA_2026",
            f"p.{rec.book_page}",
            rec.book_page,
        )
        current_prov = None

    def _flush_with_list_style() -> None:
        flush_provision()

    # Track last seen article number in main body to prevent sub-clauses like "(a) 1. Foo"
    # from splitting articles. Pages 32..283 (0-indexed 31..282) = Preamble & Parts I-XXII;
    # Pages 284..381 (0-indexed 283..380) = Schedules 1-12;
    # Pages 382..402 (0-indexed 381..total_pages-1) = Appendices I-III.
    seen_article_nums: set[str] = set()
    seen_schedules: set[str] = set()

    for pno_idx in range(31, total_pages):
        book_page = pno_idx + 1
        body_lines, fn_lines = _extract_page_bands(doc[pno_idx])

        if book_page <= 283:
            page_section_mode = "articles"
        elif book_page <= 381:
            page_section_mode = "schedules"
        else:
            page_section_mode = "appendices"

        page_first_prov_ref: str | None = None

        for entry in body_lines:
            text = entry["text"]
            is_bold = bool(entry["bold"])

            # Detect Schedule headings ONLY in pages 284..381
            if page_section_mode == "schedules":
                sch_match = SCHEDULE_HEADING_RE.match(text)
                sch_num: str | None = None
                sch_word = ""
                if sch_match and len(text.strip()) <= 55 and (is_bold or text.upper().startswith(("FIRST", "SECOND", "THIRD", "FOURTH", "FIFTH", "SIXTH", "SEVENTH", "EIGHTH", "NINTH", "TENTH", "ELEVENTH", "TWELFTH", "1["))):
                    sch_word = sch_match.group(1).upper()
                    sch_num = SCHEDULE_ROMAN_TO_NUM[sch_word]
                elif (
                    book_page == 294
                    and "2" not in seen_schedules
                    and "59(3)" in text
                    and "65(3)" in text
                ):
                    sch_word = "SECOND"
                    sch_num = "2"

                if sch_num is not None and sch_num not in seen_schedules:
                    seen_schedules.add(sch_num)
                    _flush_with_list_style()
                    current_mode = "schedules"
                    current_part = f"{sch_word} SCHEDULE"
                    cref = f"CONST:SCH:{sch_num}"
                    current_prov = {
                        "canonical_ref": cref,
                        "provision_type": "schedule",
                        "number": f"Schedule {sch_num}",
                        "title": f"{sch_word.title()} Schedule",
                        "part_or_chapter": current_part,
                        "start_page": book_page,
                        "end_page": book_page,
                        "status": "active",
                        "effective_date": None,
                        "lines": [text],
                    }
                    page_first_prov_ref = page_first_prov_ref or cref
                    continue

            # Detect Appendix headings in pages 382..402 (including C.O. 272 heading on p. 401)
            if page_section_mode == "appendices":
                app_match = APPENDIX_HEADING_RE.match(text)
                app_roman: str | None = None
                app_title = text[:160]
                if app_match:
                    app_roman = app_match.group(1).upper()
                elif "APPLICATION TO JAMMU AND KASHMIR" in text.upper() and "ORDER, 2019" in (
                    text.upper() + " ".join(e["text"].upper() for e in body_lines[:3])
                ):
                    app_roman = "II"
                    app_title = "The Constitution (Application to Jammu and Kashmir) Order, 2019 (C.O. 272)"
                if app_roman and (current_prov is None or current_prov["canonical_ref"] != f"CONST:APP:{app_roman}"):
                    _flush_with_list_style()
                    current_mode = "appendices"
                    current_part = f"APPENDIX {app_roman}"
                    cref = f"CONST:APP:{app_roman}"
                    current_prov = {
                        "canonical_ref": cref,
                        "provision_type": "appendix",
                        "number": f"Appendix {app_roman}",
                        "title": app_title,
                        "part_or_chapter": current_part,
                        "start_page": book_page,
                        "end_page": book_page,
                        "status": "active",
                        "effective_date": None,
                        "lines": [text],
                    }
                    page_first_prov_ref = page_first_prov_ref or cref
                    continue

            part_match = PART_RE.match(text)
            if part_match and page_section_mode == "articles" and (
                is_bold or text.startswith("PART ")
            ):
                if re.fullmatch(r"PART\s+[IVXLC]+[A-Z]*", text.strip(), re.I) or "—" in text:
                    current_mode = "articles"
                    current_part = text.strip()
                    continue

            # Preamble start (page 32)
            if book_page == 32 and text.startswith("P") and "REAMBLE" in text:
                current_prov = {
                    "canonical_ref": "CONST:PREAMBLE",
                    "provision_type": "preamble",
                    "number": "Preamble",
                    "title": "Preamble of the Constitution of India",
                    "part_or_chapter": "Preamble",
                    "start_page": book_page,
                    "end_page": book_page,
                    "status": "active",
                    "effective_date": "1950-01-26",
                    "lines": [],
                }
                page_first_prov_ref = "CONST:PREAMBLE"
                continue

            # Articles mode (pages 32..283)
            if page_section_mode == "articles":
                art_match = ARTICLE_START_RE.match(text)
                if art_match:
                    raw_num = art_match.group(1)
                    rest = art_match.group(2)
                    clean_num = raw_num.strip("[]")
                    is_omitted = raw_num.startswith("[") or "omitted by" in rest.lower() or "[rep." in rest.lower()
                    # Article headings in Legislative Dept pocket edition have bold span,
                    # bracketed omitted form, marginal title ending in .— / .-, or Omitted text.
                    looks_like_article = (
                        is_bold
                        or raw_num.startswith("[")
                        or ".—" in text
                        or ".-" in text
                        or "—" in rest[:90]
                        or "omitted" in rest.lower()
                        or "repealed" in rest.lower()
                    )
                    num_digits = int(re.match(r"(\d+)", clean_num).group(1))
                    if looks_like_article and 1 <= num_digits <= 395 and clean_num not in seen_article_nums:
                        seen_article_nums.add(clean_num)
                        _flush_with_list_style()
                        current_mode = "articles"
                        title_part = re.split(r"[—-]{1,2}", rest, maxsplit=1)[0].strip().rstrip(".")
                        cref = f"CONST:ART:{clean_num}"
                        current_prov = {
                            "canonical_ref": cref,
                            "provision_type": "constitutional_article",
                            "number": clean_num,
                            "title": title_part or f"Article {clean_num}",
                            "part_or_chapter": current_part,
                            "start_page": book_page,
                            "end_page": book_page,
                            "status": "omitted_repealed" if is_omitted else "active",
                            "effective_date": None,
                            "lines": [text],
                        }
                        page_first_prov_ref = page_first_prov_ref or cref
                        continue

            # Track Ninth Schedule referenced Acts (`full_text_available=False`)
            if current_prov and current_prov["canonical_ref"] == "CONST:SCH:9":
                ninth_m = NINTH_SCH_ENTRY_RE.match(text)
                if ninth_m:
                    entry_no = ninth_m.group(1)
                    entry_title = ninth_m.group(2)
                    entry_ref = f"CONST:SCH:9:{entry_no}"
                    act_entity_id = f"STATUTE:NINTH_SCH:{entry_no}"
                    add_reference(
                        reference_type="legislative_act",
                        title=entry_title,
                        reference_number=f"Ninth Schedule Entry {entry_no}",
                        book_page=book_page,
                        source_text=text,
                        source_provision_ref="CONST:SCH:9",
                        full_text_available=False,
                        verification_status="pending_review",
                    )
                    ensure_entity(
                        act_entity_id,
                        "legislative_act",
                        entry_ref,
                        entry_title[:160],
                        full_text_available=False,
                        metadata={"ninth_schedule_entry": entry_no, "book_page": book_page},
                    )
                    add_relation(
                        act_entity_id,
                        "protected_under_schedule_9",
                        "CONST:ART:31B",
                        f"Constitution p.{book_page} (Ninth Schedule Entry {entry_no})",
                        book_page,
                    )

            if current_prov:
                current_prov["end_page"] = book_page
                current_prov["lines"].append(text)

        # Parse separated bottom-of-page footnotes on this page
        grouped_fns: list[str] = []
        for fn in fn_lines:
            t = fn["text"]
            if FOOTNOTE_START_RE.match(t):
                grouped_fns.append(t)
            elif grouped_fns:
                grouped_fns[-1] = f"{grouped_fns[-1]} {t}"
            else:
                grouped_fns.append(t)

        target_ref = page_first_prov_ref or (current_prov["canonical_ref"] if current_prov else last_prov_ref)
        for raw_fn in grouped_fns:
            footnote_counter += 1
            fn_m = FOOTNOTE_START_RE.match(raw_fn)
            fn_num = (fn_m.group(1) or fn_m.group(2) or str(footnote_counter)) if fn_m else str(footnote_counter)
            fn_type = _classify_footnote(raw_fn)
            fn_id = f"FN_{book_page}_{footnote_counter}"

            # Update status of active provision if judicial invalidation or unnotified commencement
            if current_prov and current_prov["canonical_ref"] == target_ref:
                if fn_type == "judicial_invalidation":
                    current_prov["status"] = "struck_down_judicial"
                elif fn_type == "commencement_unnotified" and current_prov["status"] == "active":
                    current_prov["status"] = "unnotified_prospective"
                eff = _extract_effective_date(raw_fn)
                if eff and not current_prov.get("effective_date"):
                    current_prov["effective_date"] = eff

            referenced_insts: list[str] = []

            for am in AMENDMENT_REF_RE.finditer(raw_fn):
                am_name = _clean_text(am.group(1))
                am_year = am.group(2)
                am_id = f"CONST_AMEND:{am_year}:{am_name.upper().replace(' ', '_')[:32]}"
                referenced_insts.append(am_id)
                ensure_entity(
                    am_id,
                    "amendment_act",
                    am_id,
                    f"The Constitution ({am_name}) Act, {am_year}",
                    full_text_available=False,
                    metadata={"book_page": book_page},
                )
                add_reference(
                    "amendment_act",
                    f"The Constitution ({am_name}) Act, {am_year}",
                    am_year,
                    book_page,
                    raw_fn,
                    target_ref,
                    full_text_available=False,
                    verification_status="verified_in_book",
                )
                rel = "omits" if "omitted" in raw_fn.lower() else "amends"
                add_relation(am_id, rel, target_ref, f"Constitution fn p.{book_page}", book_page)

            for co in CO_REF_RE.finditer(raw_fn):
                co_num = co.group(1)
                co_id = f"CO:{co_num}"
                referenced_insts.append(co_id)
                ensure_entity(
                    co_id,
                    "constitutional_order",
                    co_id,
                    f"Constitution Order {co_num} (C.O. {co_num})",
                    full_text_available=co_num in ("272", "273"),
                    metadata={"book_page": book_page},
                )
                add_reference(
                    "constitutional_order",
                    f"Constitution Order {co_num}",
                    f"C.O. {co_num}",
                    book_page,
                    raw_fn,
                    target_ref,
                    full_text_available=co_num in ("272", "273"),
                    verification_status="verified_in_book" if co_num in ("272", "273") else "pending_review",
                )
                add_relation(co_id, "modifies", target_ref, f"Constitution fn p.{book_page}", book_page)

            for jud in JUDICIAL_REF_RE.finditer(raw_fn):
                cit = _clean_text(jud.group(1))
                jud_id = f"SC:{re.sub(r'[^A-Za-z0-9]+', '_', cit).strip('_').upper()}"
                referenced_insts.append(jud_id)
                ensure_entity(
                    jud_id,
                    "judicial_decision",
                    jud_id,
                    cit,
                    full_text_available=False,
                    metadata={"book_page": book_page},
                )
                add_reference(
                    "judicial_decision",
                    cit,
                    cit,
                    book_page,
                    raw_fn,
                    target_ref,
                    full_text_available=False,
                    verification_status="pending_review",
                )
                rel = "struck_down_by" if fn_type == "judicial_invalidation" else "interprets"
                add_relation(target_ref, rel, jud_id, f"Constitution fn p.{book_page}", book_page)

            for act_m in EXTERNAL_ACT_RE.finditer(raw_fn):
                act_title = _clean_text(act_m.group(1))
                if "constitution" in act_title.lower() and "amendment" in act_title.lower():
                    continue
                if "order" in act_title.lower() and "c.o." in raw_fn.lower():
                    continue
                act_id = f"EXT_ACT:{hashlib.sha1(act_title.lower().encode()).hexdigest()[:10]}"
                referenced_insts.append(act_id)
                ensure_entity(
                    act_id,
                    "legislative_act",
                    act_id,
                    act_title,
                    full_text_available=False,
                    metadata={"book_page": book_page},
                )
                add_reference(
                    "legislative_act",
                    act_title,
                    act_title[-4:],
                    book_page,
                    raw_fn,
                    target_ref,
                    full_text_available=False,
                    verification_status="pending_review",
                )
                add_relation(act_id, "cross_references", target_ref, f"Constitution fn p.{book_page}", book_page, "pending_review")

            footnotes.append(
                FootnoteRecord(
                    footnote_id=fn_id,
                    provision_ref=target_ref,
                    footnote_number=fn_num,
                    book_page=book_page,
                    footnote_type=fn_type,
                    note_text=raw_fn,
                    referenced_instruments=sorted(set(referenced_insts)),
                )
            )

    flush_provision()

    # Synchronize footnote statuses into previously flushed provisions (when footnotes appear at bottom of page after provision flush)
    by_ref = {p.canonical_ref: p for p in provisions}
    for fn in footnotes:
        prov = by_ref.get(fn.provision_ref)
        if not prov:
            continue
        if fn.footnote_type == "judicial_invalidation" and prov.consolidated_status == "active":
            prov.consolidated_status = "struck_down_judicial"
        elif fn.footnote_type == "commencement_unnotified" and prov.consolidated_status == "active":
            prov.consolidated_status = "unnotified_prospective"

    return {
        "schema_version": 2,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "instrument": {
            "instrument_id": "CONST_IN_2026",
            "instrument_type": "constitution",
            "title": "The Constitution of India [As on 1st May, 2026]",
            "short_code": "CONST",
            "edition_date": "2026-05-01",
            "source_authority": "Government of India, Ministry of Law and Justice, Legislative Department",
            "source_file": str(pdf_path.as_posix()),
            "total_pages": total_pages,
            "full_text_available": True,
            "verification_status": "verified_in_book",
        },
        "stats": {
            "provision_count": len(provisions),
            "footnote_count": len(footnotes),
            "reference_count": len(references),
            "entity_count": len(entities),
            "relation_count": len(relations),
        },
        "provisions": [asdict(p) for p in provisions],
        "footnotes": [asdict(f) for f in footnotes],
        "references": [asdict(r) for r in references],
        "entities": [asdict(e) for e in entities.values()],
        "relations": [asdict(r) for r in relations],
    }


def main() -> None:
    payload = parse_constitution_pdf()
    DEFAULT_OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    DEFAULT_OUT_PATH.write_text(
        json.dumps(payload, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )
    print("Constitution ingestion complete:", json.dumps(payload["stats"], indent=2))


if __name__ == "__main__":
    main()
