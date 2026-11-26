from __future__ import annotations

import logging
import os
import secrets
from functools import lru_cache
from pathlib import Path

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

logger = logging.getLogger("lex.config")

_ROOT_DIR = Path(__file__).resolve().parents[3]


class Settings(BaseSettings):
    """Environment-driven backend configuration (fail-closed in production)."""

    model_config = SettingsConfigDict(env_prefix="LEX_", env_file=".env", extra="ignore")

    app_name: str = "Lex AI Proxy"
    app_version: str = "2.0.0"
    environment: str = "dev"

    # AI Provider configuration (Gemini/Gemma first; extensible interface)
    ai_primary_provider: str = "gemini"
    gemini_api_key: str = ""
    gemma_model: str = "gemma-4-31b-it"
    gemini_base_url: str = "https://generativelanguage.googleapis.com/v1beta"

    # Authentication & Rate Limiting
    device_token_secret: str = ""
    device_token_ttl_seconds: int = 3600
    rate_limit_per_minute: int = 30

    # Module I Knowledge Admin authentication (no Web UI; audited API + CLI)
    admin_api_key_hash: str = ""

    # Storage & Corpus Paths
    database_url: str = ""
    corpus_path: str = str(_ROOT_DIR / "assets" / "corpus" / "indian_law_corpus_v1.json")
    packs_dir: str = str(_ROOT_DIR / "assets" / "corpus" / "packs")

    # Strict CORS (avoid wildcard in prod)
    cors_origins: list[str] = ["http://127.0.0.1", "http://localhost"]

    @field_validator("device_token_secret", mode="before")
    @classmethod
    def _resolve_device_secret(cls, value: str | None) -> str:
        env_name = os.getenv("LEX_ENVIRONMENT", "dev").strip().lower()
        cleaned = (value or "").strip()
        if cleaned:
            return cleaned
        if env_name in {"prod", "production"}:
            raise ValueError(
                "LEX_DEVICE_TOKEN_SECRET must be set explicitly in production."
            )
        logger.warning(
            "LEX_DEVICE_TOKEN_SECRET unset in %s mode; generating ephemeral per-process secret.",
            env_name,
        )
        return secrets.token_hex(32)

    @property
    def effective_database_url(self) -> str:
        if self.database_url.strip():
            return self.database_url.strip()
        return f"sqlite+aiosqlite:///{(_ROOT_DIR / 'backend' / 'lex_dev.db').as_posix()}"

    @property
    def is_postgres(self) -> bool:
        return self.effective_database_url.startswith("postgresql")


@lru_cache
def get_settings() -> Settings:
    return Settings()
