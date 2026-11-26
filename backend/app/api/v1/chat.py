from __future__ import annotations

import json
from collections.abc import AsyncIterator
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Request, status
from fastapi.responses import StreamingResponse

from app.ai.orchestration.workflow import BoundedLegalOrchestrator
from app.authentication.device_auth import require_device_auth
from app.schemas import ChatRequest, VerifiedResearchRequest

router = APIRouter(prefix="/v1", tags=["research"])


@router.post("/chat")
async def chat_sse(
    payload: ChatRequest,
    request: Request,
    _: str = Depends(require_device_auth),
) -> StreamingResponse:
    registry = request.app.state.providers
    try:
        provider = registry.get(payload.provider)
    except KeyError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc

    async def event_stream() -> AsyncIterator[str]:
        try:
            async for delta in provider.stream_response(
                [m.model_dump() for m in payload.messages],
                system_instruction=payload.system_instruction,
                temperature=payload.temperature,
                max_output_tokens=payload.max_output_tokens,
            ):
                yield f"data: {json.dumps({'delta': delta})}\n\n"
        except Exception:
            yield f"data: {json.dumps({'error': 'AI stream failed safely.'})}\n\n"
        yield "data: [DONE]\n\n"

    return StreamingResponse(event_stream(), media_type="text/event-stream")


@router.post("/research/verified")
async def verified_legal_research(
    payload: VerifiedResearchRequest,
    request: Request,
    _: str = Depends(require_device_auth),
) -> dict[str, Any]:
    registry = request.app.state.providers
    try:
        provider = registry.get(payload.provider)
    except KeyError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(exc),
        ) from exc

    orchestrator = BoundedLegalOrchestrator(
        provider=provider,
        corpus_service=request.app.state.corpus_service,
    )
    state = await orchestrator.run_research(
        payload.query,
        temperature=payload.temperature,
    )
    return {
        "intent": state.intent,
        "provider": provider.provider_name,
        "model": provider.model_name,
        "answer_text": state.provenance_blocks.get("ai_explanation", ""),
        "verified_citations": state.verified_citations,
        "provenance": state.provenance_blocks,
        "agent_trace": state.trace,
    }
