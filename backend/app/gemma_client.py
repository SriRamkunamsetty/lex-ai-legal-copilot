from __future__ import annotations

from typing import Any, AsyncIterator, Protocol

from app.ai.providers.gemini_provider import GoogleGeminiProvider


class GemmaBackend(Protocol):
    """Protocol preserved for legacy tests injecting mock streaming/JSON doubles."""

    async def stream_chat(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
        temperature: float = 0.15,
        max_output_tokens: int = 1024,
    ) -> AsyncIterator[str]:
        ...

    async def complete_json(
        self,
        prompt: str,
        *,
        system_instruction: str | None = None,
        images_base64: list[str] | None = None,
        temperature: float = 0.1,
    ) -> str:
        ...


GoogleAiStudioGemmaClient = GoogleGeminiProvider

__all__ = ["GemmaBackend", "GoogleAiStudioGemmaClient"]
