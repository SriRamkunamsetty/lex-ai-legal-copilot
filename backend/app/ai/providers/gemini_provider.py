from __future__ import annotations

import json
from collections.abc import AsyncIterator
from typing import Any

import httpx

from app.ai.providers.base import (
    AIProvider,
    ProviderHealth,
    ToolCallResult,
    ToolDefinition,
)
from app.core.config import Settings


class GoogleGeminiProvider(AIProvider):
    """Google Gemini / Gemma 4 provider backed by server-side LEX_GEMINI_API_KEY."""

    def __init__(self, settings: Settings) -> None:
        self._settings = settings

    @property
    def provider_name(self) -> str:
        return "gemini"

    @property
    def model_name(self) -> str:
        return self._settings.gemma_model

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

    async def generate_response(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
        temperature: float = 0.15,
        max_output_tokens: int = 1024,
    ) -> str:
        api_key = self._require_key()
        url = (
            f"{self._settings.gemini_base_url}/models/"
            f"{self._settings.gemma_model}:generateContent"
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
            resp = await client.post(
                url,
                headers={"x-goog-api-key": api_key},
                json=body,
            )
            resp.raise_for_status()
            data = resp.json()
            candidates = data.get("candidates", [])
            if not candidates:
                return ""
            parts = candidates[0].get("content", {}).get("parts", [])
            return "".join(p.get("text", "") for p in parts)

    async def stream_response(
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

    async def analyze_document(
        self,
        prompt: str,
        *,
        ocr_text: str = "",
        images_base64: list[str] | None = None,
        system_instruction: str | None = None,
        temperature: float = 0.1,
    ) -> dict[str, Any]:
        combined = f"{prompt}\n\nOCR text:\n{ocr_text}" if ocr_text else prompt
        raw = await self.generate_structured_output(
            combined,
            system_instruction=system_instruction,
            images_base64=images_base64,
            temperature=temperature,
        )
        try:
            data = json.loads(raw)
            if isinstance(data, dict):
                return data
        except json.JSONDecodeError:
            pass
        return {"summary": raw}

    async def generate_structured_output(
        self,
        prompt: str,
        *,
        json_schema: dict[str, Any] | None = None,
        system_instruction: str | None = None,
        images_base64: list[str] | None = None,
        temperature: float = 0.1,
    ) -> str:
        api_key = self._require_key()
        url = (
            f"{self._settings.gemini_base_url}/models/"
            f"{self._settings.gemma_model}:generateContent"
        )
        gen_cfg: dict[str, Any] = {
            "temperature": temperature,
            "responseMimeType": "application/json",
        }
        if json_schema:
            gen_cfg["responseSchema"] = json_schema

        body: dict[str, Any] = {
            "contents": self._to_contents(
                [{"role": "user", "content": prompt}],
                images_base64=images_base64,
            ),
            "generationConfig": gen_cfg,
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

    async def execute_tool(
        self,
        prompt: str,
        tools: list[ToolDefinition],
        *,
        system_instruction: str | None = None,
    ) -> ToolCallResult:
        api_key = self._require_key()
        url = (
            f"{self._settings.gemini_base_url}/models/"
            f"{self._settings.gemma_model}:generateContent"
        )
        body: dict[str, Any] = {
            "contents": self._to_contents([{"role": "user", "content": prompt}]),
            "tools": [
                {
                    "functionDeclarations": [
                        {
                            "name": t.name,
                            "description": t.description,
                            "parameters": t.parameters_schema
                            or {"type": "object", "properties": {}},
                        }
                        for t in tools
                    ]
                }
            ],
            "generationConfig": {"temperature": 0.0},
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
            parts = (
                data.get("candidates", [{}])[0]
                .get("content", {})
                .get("parts", [])
            )
            for part in parts:
                if "functionCall" in part:
                    fc = part["functionCall"]
                    return ToolCallResult(
                        tool_name=str(fc.get("name", "")),
                        arguments=dict(fc.get("args", {})),
                        raw_text=json.dumps(fc),
                    )
            text = "".join(p.get("text", "") for p in parts)
            return ToolCallResult(tool_name="none", arguments={}, raw_text=text)

    async def check_availability(self) -> ProviderHealth:
        if not self._settings.gemini_api_key:
            return ProviderHealth(
                provider=self.provider_name,
                model=self.model_name,
                available=False,
                reason="missing_gemini_api_key",
            )
        return ProviderHealth(
            provider=self.provider_name,
            model=self.model_name,
            available=True,
            reason="configured",
        )
