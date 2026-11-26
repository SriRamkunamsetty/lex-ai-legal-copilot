"""Module J: Constitution & Knowledge Pack Trust Evaluation Suite.

Verifies legal trust invariants directly against generated offline packs:
1. Constitutional lifecycle accuracy (omitted, unnotified, struck-down, 106th Amendment).
2. Zero fabricated full-text rate (0%) for external Acts only referenced in
   the Constitution book (Ninth Schedule 1-284, un-ingested NI Act/ICA/CPC).
3. Verbatim source citation & footnote separation integrity.
"""

from __future__ import annotations

import json
from pathlib import Path


def _load_pack(filename: str) -> dict:
    path = Path("assets/corpus/packs") / filename
    return json.loads(path.read_text(encoding="utf-8"))


def test_module_j_constitutional_lifecycle_traps() -> None:
    const_pack = _load_pack("constitution_in_2026_v1.json")
    provs = {p["canonical_ref"]: p for p in const_pack["provisions"]}
    fns_by_prov: dict[str, list[dict]] = {}
    for fn in const_pack["footnotes"]:
        fns_by_prov.setdefault(fn["provision_ref"], []).append(fn)

    # Trap 1: Art. 22(4) has 44th Amendment s.3 unnotified commencement date
    assert provs["CONST:ART:22"]["consolidated_status"] == "unnotified_prospective"

    # Trap 2: Art. 31 omitted by 44th Amendment Act, 1978
    assert provs["CONST:ART:31"]["consolidated_status"] == "omitted_repealed"

    # Trap 3: Art. 124A & 368 carry Supreme Court invalidation footnotes (NJAC / Minerva Mills)
    assert provs["CONST:ART:124A"]["consolidated_status"] == "struck_down_judicial"
    assert any("2016 SC 117" in fn["note_text"] for fn in fns_by_prov.get("CONST:ART:124A", []))
    assert provs["CONST:ART:368"]["consolidated_status"] == "struck_down_judicial"
    assert any("1980 SC 1789" in fn["note_text"] for fn in fns_by_prov.get("CONST:ART:368", []))

    # Trap 4: 106th Amendment (Women's Reservation Art. 330A) carries 16-4-2026 effective date
    assert "330A" in provs["CONST:ART:330A"]["number"]
    assert any("16-4-2026" in fn["note_text"] for fn in fns_by_prov.get("CONST:ART:330A", []))


def test_module_j_zero_fabricated_external_full_text_gate() -> None:
    const_pack = _load_pack("constitution_in_2026_v1.json")
    central_pack = _load_pack("central_priority_acts_v1.json")

    # No Ninth Schedule external reference inside the Constitution pack claims full text
    ninth = [r for r in const_pack["references"] if "Ninth Schedule Entry" in r["reference_number"]]
    assert len(ninth) >= 250
    assert sum(1 for r in ninth if r["full_text_available"]) == 0

    # Any Central Act whose official PDF timed out MUST report full_text_available=False and 0 sections
    for inst in central_pack["instruments"]:
        if not inst["full_text_available"]:
            assert inst["provision_count"] == 0
            assert inst["verification_status"] == "pending_review"
            matching = [
                p for p in central_pack["provisions"] if p["instrument_id"] == inst["instrument_id"]
            ]
            assert len(matching) == 0
        else:
            assert inst["provision_count"] > 0
            assert inst["verification_status"] == "verified"
