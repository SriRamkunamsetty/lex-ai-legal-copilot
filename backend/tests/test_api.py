from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any, AsyncIterator

from fastapi.testclient import TestClient

BACKEND_DIR = Path(__file__).resolve().parents[1]
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from app.config import Settings
from app.corpus_store import CorpusStore
from app.main import create_app


class FakeGemmaBackend:
    async def stream_chat(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
        temperature: float = 0.15,
        max_output_tokens: int = 1024,
    ) -> AsyncIterator[str]:
        yield "Under [BNS 304], "
        yield "snatching is punishable up to 3 years."

    async def complete_json(
        self,
        prompt: str,
        *,
        system_instruction: str | None = None,
        images_base64: list[str] | None = None,
        temperature: float = 0.1,
    ) -> str:
        if "Review this Indian contract" in prompt:
            return json.dumps(
                {
                    "risk_score": 72,
                    "risk_label": "Moderate risk",
                    "clauses": [
                        {
                            "clause_title": "Indemnity",
                            "original_excerpt": "unlimited liability",
                            "risk_level": "high",
                            "reason": "Uncapped indemnity exposure.",
                            "suggested_rewrite": "liability capped at 12 months of fees",
                        }
                    ],
                }
            )
        if "Draft a " in prompt:
            return json.dumps(
                {
                    "title": "Rental Agreement",
                    "body": "RENTAL AGREEMENT between [Landlord] and [Tenant].",
                    "missing_placeholders": ["Landlord", "Tenant"],
                    "mandatory_clauses_ok": True,
                }
            )
        return json.dumps(
            {
                "category": "Theft",
                "summary": "Phone snatching triggers BNS 304 and BNSS 173.",
                "cited_sections": [{"act_code": "BNS", "section_number": "304"}],
                "next_steps": ["File Zero FIR at nearest police station"],
                "evidence_to_keep": ["IMEI invoice", "CCTV timestamps"],
                "where_to_report": "Nearest police station or 112",
            }
        )


def _build_client(rate_limit: int = 30) -> TestClient:
    settings = Settings(
        device_token_secret="unit-test-secret",
        rate_limit_per_minute=rate_limit,
    )
    corpus = CorpusStore(
        [
            {
                "act_code": "BNS",
                "act_name": "Bharatiya Nyaya Sanhita, 2023",
                "section_number": "304",
                "title": "Snatching",
                "chapter": "CHAPTER XVII",
                "text": "304. (1) Theft is snatching if...",
                "source_url": "https://www.indiacode.nic.in/handle/123456789/20062",
                "legacy_mapping": None,
            }
        ]
    )
    app = create_app(
        settings=settings,
        gemma_client=FakeGemmaBackend(),
        corpus_store=corpus,
        enable_db=False,
    )
    return TestClient(app)


def _auth_headers(client: TestClient, device_id: str = "device-test-1") -> dict[str, str]:
    resp = client.post("/v1/auth/device-token", json={"device_id": device_id})
    assert resp.status_code == 200
    token = resp.json()["token"]
    return {"Authorization": f"Bearer {token}"}


def test_health_and_sections_lookup() -> None:
    client = _build_client()
    health = client.get("/health")
    assert health.status_code == 200
    assert health.json()["corpus_sections"] == 1

    sec = client.get("/v1/sections/bns/304")
    assert sec.status_code == 200
    assert sec.json()["title"] == "Snatching"

    missing = client.get("/v1/sections/bns/9999")
    assert missing.status_code == 404


def test_requires_valid_device_token_and_enforces_rate_limit() -> None:
    client = _build_client(rate_limit=2)
    unauth = client.post("/v1/chat", json={"messages": [{"role": "user", "content": "hi"}]})
    assert unauth.status_code == 401

    headers = _auth_headers(client, "device-rl")
    assert client.post("/v1/document/analyze", json={"ocr_text": "Notice"}, headers=headers).status_code == 200
    assert client.post("/v1/document/analyze", json={"ocr_text": "Notice"}, headers=headers).status_code == 200
    third = client.post("/v1/document/analyze", json={"ocr_text": "Notice"}, headers=headers)
    assert third.status_code == 429


def test_chat_sse_and_ai_endpoints() -> None:
    client = _build_client()
    headers = _auth_headers(client)

    with client.stream(
        "POST",
        "/v1/chat",
        json={"messages": [{"role": "user", "content": "Phone snatched"}]},
        headers=headers,
    ) as resp:
        assert resp.status_code == 200
        body = "".join(resp.iter_text())
        assert "Under [BNS 304]" in body
        assert "[DONE]" in body

    inc = client.post(
        "/v1/incident/sections",
        json={"incident_type": "Theft", "description": "My phone was snatched"},
        headers=headers,
    )
    assert inc.status_code == 200
    assert inc.json()["category"] == "Theft"

    rev = client.post(
        "/v1/contract/review",
        json={"contract_text": "This agreement contains unlimited liability for the vendor."},
        headers=headers,
    )
    assert rev.status_code == 200
    assert rev.json()["risk_score"] == 72

    draft = client.post(
        "/v1/draft",
        json={"template_type": "rent_agreement", "fields": {"term": "11 months"}},
        headers=headers,
    )
    assert draft.status_code == 200
    assert draft.json()["mandatory_clauses_ok"] is True
