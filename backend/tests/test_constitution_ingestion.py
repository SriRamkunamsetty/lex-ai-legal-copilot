"""Tests for Module A, B, D & H Constitution Book Ingestion & Knowledge Pack."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

from scripts.ingest_constitution import parse_constitution_pdf
from scripts.verify_sources import is_allowed_official_url


def test_constitution_pdf_ingestion_captures_all_parts_statuses_and_ninth_schedule() -> None:
    payload = parse_constitution_pdf(Path("data/source_books/constitution_india_2026.pdf"))
    provs = {p["canonical_ref"]: p for p in payload["provisions"]}

    # Preamble, Fundamental Rights, 106th Amendment, Basic Structure
    assert "CONST:PREAMBLE" in provs
    assert "CONST:ART:14" in provs
    assert "CONST:ART:21" in provs
    assert "CONST:ART:239AA" in provs
    assert "CONST:ART:330A" in provs
    assert "CONST:ART:368" in provs

    # Lifecycle state accuracy
    assert provs["CONST:ART:22"]["consolidated_status"] == "unnotified_prospective"
    assert provs["CONST:ART:31"]["consolidated_status"] == "omitted_repealed"
    assert provs["CONST:ART:124A"]["consolidated_status"] == "struck_down_judicial"
    assert provs["CONST:ART:368"]["consolidated_status"] == "struck_down_judicial"

    # All 12 Schedules + Appendices I-III present without duplicate overwrite
    for idx in range(1, 13):
        assert f"CONST:SCH:{idx}" in provs
    assert "CONST:APP:I" in provs
    assert "CONST:APP:II" in provs
    assert "CONST:APP:III" in provs

    # External Ninth Schedule Acts are cataloged with full_text_available=False
    ninth_refs = [
        r for r in payload["references"] if "Ninth Schedule Entry" in r["reference_number"]
    ]
    assert len(ninth_refs) >= 250
    assert all(r["full_text_available"] is False for r in ninth_refs)
    assert all(r["verification_status"] == "pending_review" for r in ninth_refs)

    # Separated footnotes and graph edges exist
    assert payload["stats"]["footnote_count"] > 500
    assert payload["stats"]["relation_count"] > 1000


def test_pack_catalog_sha256_integrity() -> None:
    catalog_path = Path("assets/corpus/packs/pack_catalog.json")
    assert catalog_path.exists()
    catalog = json.loads(catalog_path.read_text(encoding="utf-8"))
    for pack in catalog["packs"]:
        pack_file = Path(pack["asset_path"])
        assert pack_file.exists()
        actual_sha = hashlib.sha256(pack_file.read_bytes()).hexdigest()
        assert actual_sha == pack["sha256"]
        assert pack["size_bytes"] == pack_file.stat().st_size


def test_verify_sources_enforces_official_gov_domain_allowlist() -> None:
    assert is_allowed_official_url("https://www.indiacode.nic.in/bitstream/1.pdf")
    assert is_allowed_official_url("https://legislative.gov.in/sites/default/files/A1872-09.pdf")
    assert not is_allowed_official_url("http://www.indiacode.nic.in/insecure.pdf")
    assert not is_allowed_official_url("https://unofficial-law-blog.com/act.pdf")
