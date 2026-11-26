from __future__ import annotations

import logging
from contextlib import asynccontextmanager
from typing import Any

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.ext.asyncio import AsyncEngine, AsyncSession, async_sessionmaker

from app.ai.providers import (
    AIProvider,
    GoogleGeminiProvider,
    LegacyGemmaAdapter,
    ProviderRegistry,
)
from app.api.v1 import admin_review, auth, chat, corpus, workflows, workspaces
from app.authentication.device_auth import SlidingWindowRateLimiter
from app.core.config import Settings, get_settings
from app.core.middleware import PrivacyAuditLoggingMiddleware, SecurityHeadersMiddleware
from app.corpus_store import CorpusStore
from app.database.session import create_engine_and_sessionmaker, init_database_schema
from app.legal.corpus_service import LegalCorpusService

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")


def create_app(
    *,
    settings: Settings | None = None,
    gemma_client: Any | None = None,
    ai_provider: AIProvider | None = None,
    corpus_store: CorpusStore | None = None,
    session_factory: async_sessionmaker[AsyncSession] | None = None,
    enable_db: bool = True,
) -> FastAPI:
    cfg = settings or get_settings()

    engine: AsyncEngine | None = None
    active_factory = session_factory
    if active_factory is None and enable_db:
        engine, active_factory = create_engine_and_sessionmaker(
            cfg.effective_database_url
        )

    @asynccontextmanager
    async def lifespan(application: FastAPI):
        if engine is not None:
            await init_database_schema(engine)
        elif active_factory is not None:
            # Test overrides may pass an already-configured session_factory.
            pass
        try:
            yield
        finally:
            if engine is not None:
                await engine.dispose()

    app = FastAPI(
        title=cfg.app_name,
        version=cfg.app_version,
        lifespan=lifespan,
    )

    if ai_provider is not None:
        primary_provider = ai_provider
    elif gemma_client is not None:
        primary_provider = LegacyGemmaAdapter(gemma_client, model=cfg.gemma_model)
    else:
        primary_provider = GoogleGeminiProvider(cfg)

    registry = ProviderRegistry(primary_provider)
    raw_corpus = corpus_store or CorpusStore.from_file(cfg.corpus_path)
    corpus_service = LegalCorpusService(
        corpus_store=raw_corpus,
        packs_dir=cfg.packs_dir if corpus_store is None else None,
        session_factory=active_factory,
    )

    app.state.settings = cfg
    app.state.session_factory = active_factory
    app.state.providers = registry
    app.state.gemma = gemma_client or primary_provider
    app.state.corpus = raw_corpus
    app.state.corpus_service = corpus_service
    app.state.rate_limiter = SlidingWindowRateLimiter(
        cfg.rate_limit_per_minute,
        session_factory=active_factory,
    )

    app.add_middleware(SecurityHeadersMiddleware)
    app.add_middleware(PrivacyAuditLoggingMiddleware)
    app.add_middleware(
        CORSMiddleware,
        allow_origins=cfg.cors_origins,
        allow_methods=["GET", "POST"],
        allow_headers=["Authorization", "Content-Type", "X-Lex-Admin-Key", "X-Lex-Reviewer-Id"],
    )

    @app.get("/health")
    async def health(request: Request) -> dict[str, Any]:
        service: LegalCorpusService = request.app.state.corpus_service
        provider_health = await request.app.state.providers.health_summary()
        return {
            "status": "ok",
            "version": cfg.app_version,
            "model": cfg.gemma_model,
            "providers": [
                {
                    "name": h.provider,
                    "model": h.model,
                    "available": h.available,
                    "reason": h.reason,
                }
                for h in provider_health
            ],
            "database": "postgres" if cfg.is_postgres else "sqlite",
            "corpus_sections": service.total_sections,
        }

    app.include_router(auth.router)
    app.include_router(chat.router)
    app.include_router(workflows.router)
    app.include_router(corpus.router)
    app.include_router(admin_review.router)
    app.include_router(workspaces.router)

    return app


app = create_app(enable_db=False)
