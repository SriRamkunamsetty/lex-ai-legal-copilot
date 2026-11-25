"""Ingest official Indian statutory texts into a versioned offline corpus JSON.

Sources (official Gazette of India Act PDFs):
- Bharatiya Nyaya Sanhita, 2023 (Act No. 45 of 2023)
- Bharatiya Nagarik Suraksha Sanhita, 2023 (Act No. 46 of 2023)
- Bharatiya Sakshya Adhiniyam, 2023 (Act No. 47 of 2023)

Note: India Code (`indiacode.nic.in`) timed out in this environment; therefore
only verbatim Gazette PDFs fetched from PRS India's mirror of the official
Gazette of India Extraordinary Part II Section 1 publications are parsed here.
TODO(verify): Add official India Code / MeitY / DFS PDF ingestion for
Negotiable Instruments Act, 1881 and Information Technology Act, 2000 once an
official government PDF endpoint is reachable, plus full official IPC/CrPC/IEA
concordance table from BPR&D/MHA.
"""

from __future__ import annotations

import json
import re
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path

import pymupdf
import requests

SOURCES = {
    "BNS": {
        "act_name": "Bharatiya Nyaya Sanhita, 2023",
        "act_number": "Act No. 45 of 2023",
        "url": "https://www.prsindia.org/files/bills_acts/acts_parliament/2023/The%20Bharatiya%20Nyaya%20Sanhita,%202023.pdf",
        "source_url": "https://www.indiacode.nic.in/handle/123456789/20062",
        "mirror_url": "https://www.prsindia.org/files/bills_acts/acts_parliament/2023/The%20Bharatiya%20Nyaya%20Sanhita,%202023.pdf",
        "stop_before": None,
        "expected_max_section": 358,
    },
    "BNSS": {
        "act_name": "Bharatiya Nagarik Suraksha Sanhita, 2023",
        "act_number": "Act No. 46 of 2023",
        "url": "https://www.prsindia.org/files/bills_acts/acts_parliament/2023/The%20Bharatiya%20Nagarik%20Suraksha%20Sanhita,%202023.pdf",
        "source_url": "https://www.indiacode.nic.in/handle/123456789/20099",
        "mirror_url": "https://www.prsindia.org/files/bills_acts/acts_parliament/2023/The%20Bharatiya%20Nagarik%20Suraksha%20Sanhita,%202023.pdf",
        "stop_before": "THE FIRST SCHEDULE",
        "expected_max_section": 531,
    },
    "BSA": {
        "act_name": "Bharatiya Sakshya Adhiniyam, 2023",
        "act_number": "Act No. 47 of 2023",
        "url": "https://www.prsindia.org/files/bills_acts/bills_parliament/2023/The%20Bharatiya%20Sakshya%20Bill,%202023.pdf",
        "source_url": "https://www.indiacode.nic.in/handle/123456789/21350",
        "mirror_url": "https://www.prsindia.org/files/bills_acts/bills_parliament/2023/The%20Bharatiya%20Sakshya%20Bill,%202023.pdf",
        "stop_before": "THE SCHEDULE",
        "expected_max_section": 170,
    },
}

# Verified legacy cross-references for core seeded / high-frequency sections.
# TODO(verify): Expand using official BPR&D / MHA concordance table PDF.
VERIFIED_LEGACY_MAP: dict[tuple[str, str], str] = {
    ("BNS", "303"): "IPC 378, 379",
    ("BNS", "304"): "New offence in BNS 2023 (no direct IPC equivalent)",
    ("BNS", "309"): "IPC 390, 392, 393, 394",
    ("BNSS", "173"): "CrPC 154",
    ("BNSS", "175"): "CrPC 156",
    ("BNSS", "176"): "CrPC 157",
    ("BSA", "63"): "IEA 65B",
}

SECTION_START_RE = re.compile(r"^(\d+[A-Z]?)\.\s*(.*)$")
CHAPTER_RE = re.compile(r"^CHAPTER\s+([IVXLC]+)\s*$", re.I)


@dataclass
class LegalSectionRecord:
    act_code: str
    act_name: str
    section_number: str
    title: str
    chapter: str
    text: str
    source_url: str
    legacy_mapping: str | None


def download_pdf(url: str, dest: Path) -> Path:
    if dest.exists() and dest.stat().st_size > 10_000:
        return dest
    dest.parent.mkdir(parents=True, exist_ok=True)
    resp = requests.get(
        url,
        timeout=45,
        headers={"User-Agent": "Mozilla/5.0"},
    )
    resp.raise_for_status()
    if resp.content[:4] != b"%PDF":
        raise ValueError(f"Expected PDF from {url}, got {resp.headers.get('Content-Type')}")
    dest.write_bytes(resp.content)
    return dest


def _is_header_footer(y0: float, y1: float, text: str) -> bool:
    if y0 < 66 or y1 > 775:
        return True
    upper = text.upper()
    if "THE GAZETTE OF INDIA EXTRAORDINARY" in upper:
        return True
    if upper.startswith("SEC. 1]") or "[PART II" in upper:
        return True
    if set(text.strip()) <= {"_", "-", " "}:
        return True
    return False


def parse_gazette_pdf(
    pdf_path: Path,
    act_code: str,
    act_name: str,
    source_url: str,
    stop_before: str | None,
) -> list[LegalSectionRecord]:
    doc = pymupdf.open(pdf_path)

    body_lines: list[tuple[int, float, str]] = []
    marginal_notes: list[tuple[int, float, str]] = []

    stopped = False
    for page_idx, page in enumerate(doc):
        if stopped:
            break
        page_text = page.get_text()
        if stop_before and stop_before in page_text and page_idx > 2:
            # Stop right at schedule page
            stopped = True
            break

        blocks = page.get_text("blocks")
        # Sort top-to-bottom
        blocks.sort(key=lambda b: (round(b[1], 1), round(b[0], 1)))

        seen_chapter_on_p0 = False
        for x0, y0, x1, y1, raw, *_ in blocks:
            txt = " ".join(line.strip() for line in raw.splitlines() if line.strip())
            if not txt:
                continue
            if _is_header_footer(y0, y1, txt):
                continue

            # Skip Gazette cover preamble on page 0 before CHAPTER I
            if page_idx == 0:
                if "CHAPTER I" in txt.upper():
                    seen_chapter_on_p0 = True
                elif not seen_chapter_on_p0 and y0 < 580:
                    continue

            # Gazette layout: marginal notes sit on outer margins (x0 < 95 or x0 > 460)
            if x0 < 95 or x0 > 460:
                marginal_notes.append((page_idx, y0, txt))
            else:
                # Preserve internal newlines per line for chapter & section detection
                for line in raw.splitlines():
                    cleaned = line.strip()
                    if cleaned and not (set(cleaned) <= {"_", "-", " "}):
                        body_lines.append((page_idx, y0, cleaned))

    sections: list[LegalSectionRecord] = []
    current_chapter = "CHAPTER I"
    pending_chapter_num: str | None = None
    current_num: str | None = None
    current_page = 0
    current_y = 0.0
    current_lines: list[str] = []
    used_marginals: set[int] = set()

    def pick_title(sec_num: str, page_idx: int, y_pos: float) -> str:
        best_idx = -1
        best_dist = 9999.0
        for idx, (m_page, m_y, m_txt) in enumerate(marginal_notes):
            if idx in used_marginals:
                continue
            if m_page == page_idx:
                dist = abs(m_y - y_pos)
                if dist < 42 and dist < best_dist:
                    best_dist = dist
                    best_idx = idx
        if best_idx >= 0:
            used_marginals.add(best_idx)
            return marginal_notes[best_idx][2].rstrip(".")
        return f"Section {sec_num}"

    def flush_section() -> None:
        nonlocal current_num, current_lines
        if current_num is None:
            return
        title = pick_title(current_num, current_page, current_y)
        text = "\n".join(current_lines).strip()
        sections.append(
            LegalSectionRecord(
                act_code=act_code,
                act_name=act_name,
                section_number=current_num,
                title=title,
                chapter=current_chapter,
                text=text,
                source_url=source_url,
                legacy_mapping=VERIFIED_LEGACY_MAP.get((act_code, current_num)),
            )
        )
        current_num = None
        current_lines = []

    expected_next = 1
    for page_idx, y_pos, line in body_lines:
        chap_match = CHAPTER_RE.match(line)
        if chap_match:
            pending_chapter_num = f"CHAPTER {chap_match.group(1).upper()}"
            continue

        if pending_chapter_num is not None:
            if line.isupper() and len(line) > 3 and not SECTION_START_RE.match(line):
                current_chapter = f"{pending_chapter_num} — {line.title()}"
                pending_chapter_num = None
                continue
            current_chapter = pending_chapter_num
            pending_chapter_num = None

        sec_match = SECTION_START_RE.match(line)
        if sec_match:
            num_str = sec_match.group(1)
            digits = int(re.match(r"\d+", num_str).group(0))
            # Guard against numbered illustrations/list items inside section text
            if expected_next <= digits <= expected_next + 2:
                flush_section()
                current_num = num_str
                current_page = page_idx
                current_y = y_pos
                current_lines = [line]
                expected_next = digits + 1
                continue

        if current_num is not None:
            current_lines.append(line)

    flush_section()
    return sections


def main() -> None:
    root = Path(__file__).resolve().parent.parent
    cache_dir = root / "build" / "corpus_cache"
    out_path = root / "assets" / "corpus" / "indian_law_corpus_v1.json"
    out_path.parent.mkdir(parents=True, exist_ok=True)

    all_sections: list[dict] = []
    act_summaries: dict[str, dict] = {}

    for act_code, cfg in SOURCES.items():
        pdf_path = download_pdf(cfg["url"], cache_dir / f"{act_code.lower()}.pdf")
        records = parse_gazette_pdf(
            pdf_path=pdf_path,
            act_code=act_code,
            act_name=cfg["act_name"],
            source_url=cfg["source_url"],
            stop_before=cfg["stop_before"],
        )
        act_summaries[act_code] = {
            "act_name": cfg["act_name"],
            "act_number": cfg["act_number"],
            "source_url": cfg["source_url"],
            "mirror_url": cfg["mirror_url"],
            "section_count": len(records),
        }
        all_sections.extend(asdict(r) for r in records)
        print(f"{act_code}: parsed {len(records)} sections")

    payload = {
        "schema_version": 1,
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "acts": act_summaries,
        "sections": all_sections,
    }
    out_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Wrote {len(all_sections)} total sections to {out_path} ({out_path.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
