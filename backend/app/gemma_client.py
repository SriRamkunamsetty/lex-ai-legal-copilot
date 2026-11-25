from __future__ import annotations

import json
from typing import Any, AsyncIterator, Protocol

import httpx

from app.config import Settings


class GemmaBackend(Protocol):
    """Protocol implemented by live Google AI Studio / Vertex proxy and test doubles."""

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


class GoogleAiStudioGemmaClient:
    """Async Gemma 4 26B/31B client proxying requests using server-side API key."""

    def __init__(self, settings: Settings) -> None:
        self._settings = settings

    def _require_key(self) -> str:
        if not self._settings.gemini_api_key:
            raise RuntimeError(
                "LEX_GEMINI_API_KEY is not configured on the backend server."
            )
        return self._settings.gemini_api_key

    @staticmethod
    def _to_contents(
        messages: list[dict[str, Any]],
        images_base64: list[str] | None = None,
    ) -> list[dict[str, Any]]:
        contents: list[dict[str, Any]] = []
        for idx, msg in enumerate(messages):
            role = "model" if msg.get("role") == "assistant" else "user"
            parts: list[dict[str, Any]] = [{"text": str(msg.get("content", ""))}]
            for img in msg.get("images_base64", []) or []:
                parts.append(
                    {"inline_data": {"mime_type": "image/jpeg", "data": img}}
                )
            if idx == len(messages) - 1 and images_base64:
                for img in images_base64:
                    parts.append(
                        {"inline_data": {"mime_type": "image/jpeg", "data": img}}
                    )
            contents.append({"role": role, "parts": parts})
        return contents

    async def stream_chat(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
        temperature: float = 0.15,
        max_output_tokens: int = 1024,
    ) -> AsyncIterator[str]:
        api_key = self._require_key()
        url = (
            f"{self._settings.gemini_base_url}/models/"
            f"{self._settings.gemma_model}:streamGenerateContent?alt=sse"
        )
        body: dict[str, Any] = {
            "contents": self._to_contents(messages),
            "generationConfig": {
                "temperature": temperature,
                "maxOutputTokens": max_output_tokens,
            },
        }
        if system_instruction:
            body["systemInstruction"] = {"parts": [{"text": system_instruction}]}

        async with httpx.AsyncClient(timeout=60.0) as client:
            async with client.stream(
                "POST",
                url,
                headers={"x-goog-api-key": api_key},
                json=body,
            ) as resp:
                resp.raise_for_status()
                async for line in resp.aiter_lines():
                    if not line.startswith("data:"):
                        continue
                    raw = line.removeprefix("data:").strip()
                    if not raw or raw == "[DONE]":
                        continue
                    try:
                        chunk = json.loads(raw)
                        candidates = chunk.get("candidates", [])
                        if candidates:
                            parts = candidates[0].get("content", {}).get("parts", [])
                            for part in parts:
                                text = part.get("text", "")
                                if text:
                                    yield text
                    except json.JSONDecodeError:
                        continue

    async def complete_json(
        self,
        prompt: str,
        *,
        system_instruction: str | None = None,
        images_base64: list[str] | None = None,
        temperature: float = 0.1,
    ) -> str:
        api_key = self._require_key()
        url = (
            f"{self._settings.gemini_base_url}/models/"
            f"{self._settings.gemma_model}:generateContent"
        )
        body: dict[str, Any] = {
            "contents": self._to_contents(
                [{"role": "user", "content": prompt}],
                images_base64=images_base64,
            ),
            "generationConfig": {
                "temperature": temperature,
                "responseMimeType": "application/json",
            },
        }
        if system_instruction:
            body["systemInstruction"] = {"parts": [{"text": system_instruction}]}

        async with httpx.AsyncClient(timeout=60.0) as client:
            resp = await client.post(
                url,
                headers={"x-goog-api-key": api_key},
                json=body,
            )
            resp.raise_for_status()
            data = resp.json()
            candidates = data.get("candidates", [])
            if not candidates:
                return "{}"
            parts = candidates[0].get("content", {}).get("parts", [])
            return "".join(p.get("text", "") for p in parts)
