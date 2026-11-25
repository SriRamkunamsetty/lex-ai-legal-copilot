from __future__ import annotations

import json
import logging
import time
from typing import Any, AsyncIterator

from fastapi import Depends, FastAPI, HTTPException, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse

from app.auth import SlidingWindowRateLimiter, issue_device_token, require_device_auth
from app.config import Settings, get_settings
from app.corpus_store import CorpusStore
from app.gemma_client import GemmaBackend, GoogleAiStudioGemmaClient
from app.schemas import (
    ChatRequest,
    ContractReviewRequest,
    DeviceTokenRequest,
    DeviceTokenResponse,
    DocumentAnalyzeRequest,
    DraftRequest,
    IncidentRequest,
    SectionResponse,
)

logger = logging.getLogger("lex.proxy")
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")


def create_app(
    *,
    settings: Settings | None = None,
    gemma_client: GemmaBackend | None = None,
    corpus_store: CorpusStore | None = None,
) -> FastAPI:
    cfg = settings or get_settings()
    app = FastAPI(title=cfg.app_name, version="1.0.0")
    app.state.settings = cfg
    app.state.rate_limiter = SlidingWindowRateLimiter(cfg.rate_limit_per_minute)
    app.state.gemma = gemma_client or GoogleAiStudioGemmaClient(cfg)
    app.state.corpus = corpus_store or CorpusStore.from_file(cfg.corpus_path)

    app.add_middleware(
        CORSMiddleware,
        allow_origins=cfg.cors_origins,
        allow_methods=["GET", "POST"],
        allow_headers=["Authorization", "Content-Type"],
    )

    @app.middleware("http")
    async def log_without_content(request: Request, call_next: Any) -> Any:
        start = time.perf_counter()
        response = await call_next(request)
        elapsed_ms = (time.perf_counter() - start) * 1000
        device_hash = getattr(request.state, "device_hash", "anon")
        # Never log request/response bodies or PII.
        logger.info(
            "method=%s path=%s status=%s latency_ms=%.1f device=%s",
            request.method,
            request.url.path,
            response.status_code,
            elapsed_ms,
            device_hash,
        )
        return response

    def _get_gemma(request: Request) -> GemmaBackend:
        return request.app.state.gemma

    def _get_corpus(request: Request) -> CorpusStore:
        return request.app.state.corpus

    @app.get("/health")
    async def health(request: Request) -> dict[str, Any]:
        corpus = _get_corpus(request)
        return {
            "status": "ok",
            "model": cfg.gemma_model,
            "corpus_sections": len(corpus.sections),
        }

    @app.post("/v1/auth/device-token", response_model=DeviceTokenResponse)
    async def create_device_token(
        payload: DeviceTokenRequest,
        active_settings: Settings = Depends(get_settings),
    ) -> DeviceTokenResponse:
        token, expires_at = issue_device_token(payload.device_id, active_settings)
        return DeviceTokenResponse(token=token, expires_at=expires_at)

    @app.post("/v1/chat")
    async def chat_sse(
        payload: ChatRequest,
        request: Request,
        _: str = Depends(require_device_auth),
    ) -> StreamingResponse:
        gemma = _get_gemma(request)

        async def event_stream() -> AsyncIterator[str]:
            try:
                async for delta in gemma.stream_chat(
                    [m.model_dump() for m in payload.messages],
                    system_instruction=payload.system_instruction,
                    temperature=payload.temperature,
                    max_output_tokens=payload.max_output_tokens,
                ):
                    yield f"data: {json.dumps({'delta': delta})}\n\n"
            except Exception as exc:
                yield f"data: {json.dumps({'error': str(exc)})}\n\n"
            yield "data: [DONE]\n\n"

        return StreamingResponse(event_stream(), media_type="text/event-stream")

    @app.post("/v1/incident/sections")
    async def incident_sections(
        payload: IncidentRequest,
        request: Request,
        _: str = Depends(require_device_auth),
    ) -> dict[str, Any]:
        corpus = _get_corpus(request)
        gemma = _get_gemma(request)
        candidates = corpus.search(
            f"{payload.incident_type or ''} {payload.description}",
            limit=6,
        )
        context_lines = [
            f"{s['act_code']} {s['section_number']} - {s['title']}: {s['text'][:400]}"
            for s in candidates
        ]
        prompt = (
            "Select applicable provisions ONLY from these candidates and return JSON:\n"
            + "\n".join(context_lines)
            + f"\n\nIncident: {payload.description}"
        )
        raw = await gemma.complete_json(prompt, temperature=0.1)
        try:
            parsed = json.loads(raw)
        except json.JSONDecodeError:
            parsed = {"summary": raw, "cited_sections": []}
        parsed["candidate_sections"] = [
            {"act_code": s["act_code"], "section_number": s["section_number"], "title": s["title"]}
            for s in candidates
        ]
        return parsed

    @app.post("/v1/contract/review")
    async def contract_review(
        payload: ContractReviewRequest,
        request: Request,
        _: str = Depends(require_device_auth),
    ) -> dict[str, Any]:
        gemma = _get_gemma(request)
        prompt = (
            "Review this Indian contract and return JSON with risk_score (0-100), "
            "risk_label, and clauses list:\n\n" + payload.contract_text
        )
        raw = await gemma.complete_json(prompt, temperature=0.1)
        try:
            return json.loads(raw)
        except json.JSONDecodeError as exc:
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail="Model returned malformed contract review JSON",
            ) from exc

    @app.post("/v1/draft")
    async def generate_draft(
        payload: DraftRequest,
        request: Request,
        _: str = Depends(require_device_auth),
    ) -> dict[str, Any]:
        gemma = _get_gemma(request)
        prompt = (
            f"Draft a {payload.template_type} for India using fields {json.dumps(payload.fields)}. "
            "Use [placeholder] for missing facts and include a lawyer-review notice. "
            "Return JSON with title, body, missing_placeholders, mandatory_clauses_ok."
        )
        raw = await gemma.complete_json(prompt, temperature=0.15)
        try:
            return json.loads(raw)
        except json.JSONDecodeError as exc:
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail="Model returned malformed draft JSON",
            ) from exc

    @app.post("/v1/document/analyze")
    async def analyze_document(
        payload: DocumentAnalyzeRequest,
        request: Request,
        _: str = Depends(require_device_auth),
    ) -> dict[str, Any]:
        gemma = _get_gemma(request)
        prompt = f"{payload.prompt}\n\nOCR text:\n{payload.ocr_text}"
        raw = await gemma.complete_json(
            prompt,
            images_base64=payload.images_base64,
            temperature=0.1,
        )
        try:
            data = json.loads(raw)
            if isinstance(data, dict):
                return data
        except json.JSONDecodeError:
            pass
        return {"summary": raw}

    @app.get("/v1/sections/{act}/{number}", response_model=SectionResponse)
    async def get_section(
        act: str,
        number: str,
        request: Request,
    ) -> SectionResponse:
        corpus = _get_corpus(request)
        section = corpus.get_section(act, number)
        if section is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"{act.upper()} Section {number} not found",
            )
        return SectionResponse(**section)

    return app


app = create_app()
