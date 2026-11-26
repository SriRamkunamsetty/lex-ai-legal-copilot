"""Milestone P4 tests: AIProvider abstraction, PostgreSQL/pgvector schema & Alembic,
bounded legal agent workflow, security headers, and Module I Admin API + CLI.
"""

from __future__ import annotations

import asyncio
import hashlib
import json
import sys
from collections.abc import AsyncIterator
from pathlib import Path
from typing import Any

import pytest
from alembic import command
from alembic.config import Config
from fastapi.testclient import TestClient

ROOT_DIR = Path(__file__).resolve().parents[2]
BACKEND_DIR = ROOT_DIR / "backend"
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from app.ai.providers import AIProvider, ProviderHealth, ToolCallResult, ToolDefinition
from app.core.config import Settings
from app.database.seed import seed_database_from_packs
from app.database.session import create_engine_and_sessionmaker
from app.main import create_app
from scripts import knowledge_admin


class FakeAIProvider(AIProvider):
    @property
    def provider_name(self) -> str:
        return "gemini"

    @property
    def model_name(self) -> str:
        return "gemma-4-31b-it"

    async def generate_response(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
        temperature: float = 0.15,
        max_output_tokens: int = 1024,
    ) -> str:
        prompt = str(messages[-1]["content"])
        if "22" in prompt:
            return (
                "Under Article 22 (CONST:ART:22), preventive detention protections apply; "
                "however clause (4) includes an unnotified 44th Amendment change."
            )
        if "ni act" in prompt.lower() or "138" in prompt:
            return "External Act references must be verified separately; do not invent NI Act section wording."
        return "Under [CONST:ART:21], personal liberty requires procedure established by law."

    async def stream_response(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
        temperature: float = 0.15,
        max_output_tokens: int = 1024,
    ) -> AsyncIterator[str]:
        yield "Under [CONST:ART:21], "
        yield "liberty is protected."

    async def analyze_document(
        self,
        prompt: str,
        *,
        ocr_text: str = "",
        images_base64: list[str] | None = None,
        system_instruction: str | None = None,
        temperature: float = 0.1,
    ) -> dict[str, Any]:
        return {"summary": "Document analyzed safely.", "ocr_length": len(ocr_text)}

    async def generate_structured_output(
        self,
        prompt: str,
        *,
        json_schema: dict[str, Any] | None = None,
        system_instruction: str | None = None,
        images_base64: list[str] | None = None,
        temperature: float = 0.1,
    ) -> str:
        return json.dumps({"ok": True})

    async def execute_tool(
        self,
        prompt: str,
        tools: list[ToolDefinition],
        *,
        system_instruction: str | None = None,
    ) -> ToolCallResult:
        return ToolCallResult(tool_name=tools[0].name, arguments={}, raw_text="{}")

    async def check_availability(self) -> ProviderHealth:
        return ProviderHealth(
            provider=self.provider_name,
            model=self.model_name,
            available=True,
            reason="fake_provider",
        )


def test_production_config_requires_explicit_device_secret(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv("LEX_ENVIRONMENT", "production")
    with pytest.raises(ValueError, match="LEX_DEVICE_TOKEN_SECRET"):
        Settings(environment="production", device_token_secret="")


@pytest.mark.asyncio
async def test_alembic_seed_bounded_research_and_module_i_admin_flow(tmp_path: Path) -> None:
    db_file = tmp_path / "lex_p4_test.db"
    db_url = f"sqlite+aiosqlite:///{db_file.as_posix()}"

    # Run Alembic upgrade head against temp SQLite DB in a worker thread
    alembic_cfg = Config(str(BACKEND_DIR / "alembic.ini"))
    alembic_cfg.set_main_option("script_location", str(BACKEND_DIR / "alembic"))
    alembic_cfg.set_main_option("sqlalchemy.url", db_url)
    await asyncio.to_thread(command.upgrade, alembic_cfg, "head")

    engine, factory = create_engine_and_sessionmaker(db_url)
    async with factory() as session:
        seeded = await seed_database_from_packs(
            session,
            corpus_path=ROOT_DIR / "assets" / "corpus" / "indian_law_corpus_v1.json",
            packs_dir=ROOT_DIR / "assets" / "corpus" / "packs",
        )
        await session.commit()
    await engine.dispose()

    assert seeded["provisions"] > 500
    assert seeded["footnotes"] > 500
    assert seeded["review_items"] > 100

    admin_secret = "super-secret-admin-key-2026"
    admin_hash = hashlib.sha256(admin_secret.encode("utf-8")).hexdigest()
    settings = Settings(
        device_token_secret="p4-test-device-secret",
        admin_api_key_hash=admin_hash,
        database_url=db_url,
        rate_limit_per_minute=20,
    )
    app = create_app(
        settings=settings,
        ai_provider=FakeAIProvider(),
        enable_db=True,
    )

    with TestClient(app) as client:
        # 1. Security headers + health + pack catalog
        health = client.get("/health")
        assert health.status_code == 200
        assert health.headers["X-Content-Type-Options"] == "nosniff"
        assert health.headers["X-Frame-Options"] == "DENY"
        assert health.json()["providers"][0]["name"] == "gemini"
        assert health.json()["corpus_sections"] >= 500

        catalog = client.get("/v1/packs/catalog")
        assert catalog.status_code == 200
        assert len(catalog.json()["packs"]) >= 2

        # 2. Device auth + bounded AI research workflow with Module G provenance & boundary
        tok = client.post("/v1/auth/device-token", json={"device_id": "p4-device-1"})
        assert tok.status_code == 200
        dev_headers = {"Authorization": f"Bearer {tok.json()['token']}"}

        trap = client.post(
            "/v1/research/verified",
            json={"query": "Explain Article 22 preventive detention"},
            headers=dev_headers,
        )
        assert trap.status_code == 200
        trap_body = trap.json()
        assert trap_body["intent"] == "constitutional_research"
        assert trap_body["agent_trace"][0].startswith("supervisor:")
        assert any(
            "UNNOTIFIED" in w for w in trap_body["provenance"]["lifecycle_warnings"]
        )

        ext = client.post(
            "/v1/research/verified",
            json={"query": "What does NI Act 138 say about dishonour of cheque?"},
            headers=dev_headers,
        )
        assert ext.status_code == 200
        ext_body = ext.json()
        assert len(ext_body["provenance"]["unloaded_external_acts"]) >= 1
        assert "not loaded offline" in ext_body["provenance"]["verification_notice"]

        # 3. Module I Admin RBAC fails closed when unauthenticated or bad key
        assert client.get("/v1/admin/review/queue").status_code == 401
        assert (
            client.get(
                "/v1/admin/review/queue",
                headers={"X-Lex-Admin-Key": "wrong-key"},
            ).status_code
            == 403
        )

        admin_headers = {
            "X-Lex-Admin-Key": admin_secret,
            "X-Lex-Reviewer-Id": "advocate-reviewer-1",
        }
        queue_resp = client.get(
            "/v1/admin/review/queue?verification_status=pending_review&limit=5",
            headers=admin_headers,
        )
        assert queue_resp.status_code == 200
        items = queue_resp.json()["items"]
        assert len(items) == 5
        target_id = items[0]["reference_id"]

        decision_resp = client.post(
            f"/v1/admin/review/{target_id}/decision",
            json={"decision": "approve", "review_notes": "Checked against Gazette PDF"},
            headers=admin_headers,
        )
        assert decision_resp.status_code == 200
        assert decision_resp.json()["verification_status"] == "verified"

        pub_resp = client.post(
            "/v1/admin/packs/publish",
            json={
                "pack_id": "constitution_in_2026_v1",
                "asset_filename": "constitution_in_2026_v1.json",
                "version": "2026.05.01",
            },
            headers=admin_headers,
        )
        assert pub_resp.status_code == 200
        assert pub_resp.json()["provision_count"] == 513

        audit_resp = client.get("/v1/admin/audit-logs", headers=admin_headers)
        assert audit_resp.status_code == 200
        actions = [entry["action"] for entry in audit_resp.json()["logs"]]
        assert "review_approve" in actions
        assert "publish_pack" in actions


def test_knowledge_admin_cli_seed_queue_and_publish(tmp_path: Path) -> None:
    db_file = tmp_path / "lex_cli_test.db"
    db_url = f"sqlite+aiosqlite:///{db_file.as_posix()}"

    assert knowledge_admin.main(["--database-url", db_url, "seed-db"]) == 0
    assert (
        knowledge_admin.main(
            ["--database-url", db_url, "list-queue", "--status", "pending_review", "--limit", "3"]
        )
        == 0
    )
    assert (
        knowledge_admin.main(
            [
                "--database-url",
                db_url,
                "publish-pack",
                "--pack-id",
                "central_priority_acts_v1",
                "--pack-file",
                str(ROOT_DIR / "assets" / "corpus" / "packs" / "central_priority_acts_v1.json"),
                "--version",
                "1.0.0",
                "--reviewer",
                "cli-operator",
            ]
        )
        == 0
    )
