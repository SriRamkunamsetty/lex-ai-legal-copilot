"""Milestone P5 tests: Optional Workspace Auth, Multi-Tenant Org RBAC,
Device Revocation, and Zero-Knowledge E2EE Sync Tenant Isolation.
"""

from __future__ import annotations

import asyncio
import base64
import sys
from pathlib import Path

import pytest
from alembic import command
from alembic.config import Config
from fastapi.testclient import TestClient

ROOT_DIR = Path(__file__).resolve().parents[2]
BACKEND_DIR = ROOT_DIR / "backend"
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from app.core.config import Settings
from app.main import create_app


@pytest.mark.asyncio
async def test_e2ee_sync_tenant_isolation_org_rbac_and_device_revocation(
    tmp_path: Path,
) -> None:
    db_file = tmp_path / "lex_p5_sync.db"
    db_url = f"sqlite+aiosqlite:///{db_file.as_posix()}"

    alembic_cfg = Config(str(BACKEND_DIR / "alembic.ini"))
    alembic_cfg.set_main_option("script_location", str(BACKEND_DIR / "alembic"))
    alembic_cfg.set_main_option("sqlalchemy.url", db_url)
    await asyncio.to_thread(command.upgrade, alembic_cfg, "head")

    app = create_app(
        settings=Settings(
            device_token_secret="p5-test-session-secret",
            database_url=db_url,
            rate_limit_per_minute=50,
        ),
        enable_db=True,
    )

    with TestClient(app) as client:
        # 1. Weak passwords rejected cleanly
        weak = client.post(
            "/v1/accounts/register",
            json={
                "email": "alice@law.in",
                "password": "short",
                "device_id": "alice-phone-1",
            },
        )
        assert weak.status_code == 422

        # 2. Register Alice & Bob on separate devices
        alice_reg = client.post(
            "/v1/accounts/register",
            json={
                "email": "alice@law.in",
                "password": "StrongLegalPass#2026",
                "display_label": "Adv. Alice",
                "device_id": "alice-phone-1",
                "device_name": "Pixel 9",
                "platform": "android",
            },
        )
        assert alice_reg.status_code == 200
        alice_id = alice_reg.json()["user_id"]
        alice_hdr = {"Authorization": f"Bearer {alice_reg.json()['token']}"}

        bob_reg = client.post(
            "/v1/accounts/register",
            json={
                "email": "bob@law.in",
                "password": "AnotherStrongPass#2026",
                "display_label": "Adv. Bob",
                "device_id": "bob-iphone-1",
                "platform": "ios",
            },
        )
        assert bob_reg.status_code == 200
        bob_id = bob_reg.json()["user_id"]
        bob_hdr = {"Authorization": f"Bearer {bob_reg.json()['token']}"}

        # 3. Personal vault zero-knowledge isolation
        sample_ct = base64.b64encode(b"opaque-aes-gcm-ciphertext-bytes").decode()
        sample_nonce = base64.b64encode(b"123456789012").decode()
        sample_tag = base64.b64encode(b"1234567890123456").decode()

        push_personal = client.post(
            "/v1/sync/push",
            json={
                "blobs": [
                    {
                        "record_type": "case_file",
                        "record_id": "case_alice_1",
                        "version": 1,
                        "nonce_b64": sample_nonce,
                        "ciphertext_b64": sample_ct,
                        "tag_b64": sample_tag,
                        "key_epoch": 1,
                    }
                ]
            },
            headers=alice_hdr,
        )
        assert push_personal.status_code == 200

        # Bob pulling personal vault sees 0 blobs (strict tenant isolation)
        bob_pull = client.get("/v1/sync/pull", headers=bob_hdr)
        assert bob_pull.status_code == 200
        assert bob_pull.json()["count"] == 0

        # Alice pulls her encrypted blob intact
        alice_pull = client.get("/v1/sync/pull", headers=alice_hdr)
        assert alice_pull.json()["count"] == 1
        assert alice_pull.json()["blobs"][0]["ciphertext_b64"] == sample_ct

        # 4. Multi-tenant Org RBAC
        org_resp = client.post(
            "/v1/orgs",
            json={"name": "Chambers of Alice LLP"},
            headers=alice_hdr,
        )
        assert org_resp.status_code == 200
        org_id = org_resp.json()["org_id"]

        # Bob denied before membership
        assert client.get(f"/v1/orgs/{org_id}", headers=bob_hdr).status_code == 403
        assert (
            client.get(f"/v1/sync/pull?org_id={org_id}", headers=bob_hdr).status_code
            == 403
        )

        # Alice adds Bob as viewer: Bob can pull, cannot write
        add_viewer = client.post(
            f"/v1/orgs/{org_id}/members",
            json={"user_id": bob_id, "role": "viewer"},
            headers=alice_hdr,
        )
        assert add_viewer.status_code == 200

        shared_blob = {
            "org_id": org_id,
            "record_type": "draft",
            "record_id": "draft_shared_1",
            "version": 1,
            "nonce_b64": sample_nonce,
            "ciphertext_b64": sample_ct,
            "tag_b64": sample_tag,
            "key_epoch": 1,
        }
        assert (
            client.post(
                "/v1/sync/push",
                json={"blobs": [shared_blob]},
                headers=bob_hdr,
            ).status_code
            == 403
        )

        # Promote Bob to advocate -> shared org write succeeds
        client.post(
            f"/v1/orgs/{org_id}/members",
            json={"user_id": bob_id, "role": "advocate"},
            headers=alice_hdr,
        )
        assert (
            client.post(
                "/v1/sync/push",
                json={"blobs": [shared_blob]},
                headers=bob_hdr,
            ).status_code
            == 200
        )
        org_pull = client.get(f"/v1/sync/pull?org_id={org_id}", headers=alice_hdr)
        assert org_pull.json()["count"] == 1
        assert alice_id != bob_id

        # 5. Device revocation & logout-all invalidate prior tokens immediately
        rev = client.post(
            "/v1/accounts/devices/bob-iphone-1/revoke",
            headers=bob_hdr,
        )
        assert rev.status_code == 200
        assert client.get("/v1/sync/pull", headers=bob_hdr).status_code == 401

        logout = client.post("/v1/accounts/logout-all", headers=alice_hdr)
        assert logout.status_code == 200
        assert client.get("/v1/sync/pull", headers=alice_hdr).status_code == 401
