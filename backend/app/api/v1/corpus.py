from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from fastapi import APIRouter, HTTPException, Query, Request, status

from app.schemas import SectionResponse

router = APIRouter(prefix="/v1", tags=["corpus"])


@router.get("/sections/{act}/{number}", response_model=SectionResponse)
async def get_section(
    act: str,
    number: str,
    request: Request,
) -> SectionResponse:
    corpus_service = request.app.state.corpus_service
    section = corpus_service.get_section(act, number)
    if section is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"{act.upper()} Section {number} not found",
        )
    return SectionResponse(**section)


@router.get("/corpus/search")
async def search_corpus(
    request: Request,
    q: str = Query(min_length=2, max_length=256),
    limit: int = Query(default=6, ge=1, le=20),
) -> dict[str, Any]:
    corpus_service = request.app.state.corpus_service
    bundle = await corpus_service.hybrid_search(q, limit=limit)
    return {
        "query": q,
        "count": len(bundle["provisions"]),
        "provisions": [
            {
                "canonical_ref": p["canonical_ref"],
                "act_code": p["act_code"],
                "section_number": p["section_number"],
                "title": p["title"],
                "consolidated_status": p.get("consolidated_status", "active"),
                "book_page": p.get("book_page"),
                "verification_status": p.get("verification_status", "verified"),
            }
            for p in bundle["provisions"]
        ],
        "footnotes": bundle["footnotes"][:8],
        "unloaded_external_acts": bundle["unloaded_external_acts"],
    }


@router.get("/packs/catalog")
async def get_packs_catalog(request: Request) -> dict[str, Any]:
    packs_dir = Path(request.app.state.settings.packs_dir)
    catalog_path = packs_dir / "pack_catalog.json"
    if not catalog_path.exists():
        return {"schema_version": 1, "packs": []}
    return json.loads(catalog_path.read_text(encoding="utf-8"))
