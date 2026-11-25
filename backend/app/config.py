from __future__ import annotations

from functools import lru_cache
from pathlib import Path
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Environment-driven backend configuration (no secrets in repository)."""

    model_config = SettingsConfigDict(env_prefix="LEX_", env_file=".env", extra="ignore")

    app_name: str = "Lex AI Proxy"
    environment: str = "dev"
    gemini_api_key: str = ""
    gemma_model: str = "gemma-4-31b-it"
    gemini_base_url: str = "https://generativelanguage.googleapis.com/v1beta"
    device_token_secret: str = "dev-ephemeral-secret-change-in-prod"
    device_token_ttl_seconds: int = 3600
    rate_limit_per_minute: int = 30
    corpus_path: str = str(
        Path(__file__).resolve().parents[2]
        / "assets"
        / "corpus"
        / "indian_law_corpus_v1.json"
    )
    cors_origins: list[str] = ["*"]


@lru_cache
def get_settings() -> Settings:
    return Settings()
