from __future__ import annotations

import json
import math
from abc import ABC, abstractmethod
from collections.abc import AsyncIterator
from dataclasses import dataclass, field
from typing import Any


@dataclass(frozen=True)
class ProviderHealth:
    provider: str
    model: str
    available: bool
    reason: str = "ready"


@dataclass(frozen=True)
class ToolDefinition:
    name: str
    description: str
    parameters_schema: dict[str, Any] = field(default_factory=dict)


@dataclass(frozen=True)
class ToolCallResult:
    tool_name: str
    arguments: dict[str, Any]
    raw_text: str


class AIProvider(ABC):
    """Provider-agnostic cloud AI abstraction for Lex (Milestone P4)."""

    @property
    @abstractmethod
    def provider_name(self) -> str:
        ...

    @property
    @abstractmethod
    def model_name(self) -> str:
        ...

    @abstractmethod
    async def generate_response(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
        temperature: float = 0.15,
        max_output_tokens: int = 1024,
    ) -> str:
        ...

    @abstractmethod
    def stream_response(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
        temperature: float = 0.15,
        max_output_tokens: int = 1024,
    ) -> AsyncIterator[str]:
        ...

    @abstractmethod
    async def analyze_document(
        self,
        prompt: str,
        *,
        ocr_text: str = "",
        images_base64: list[str] | None = None,
        system_instruction: str | None = None,
        temperature: float = 0.1,
    ) -> dict[str, Any]:
        ...

    @abstractmethod
    async def generate_structured_output(
        self,
        prompt: str,
        *,
        json_schema: dict[str, Any] | None = None,
        system_instruction: str | None = None,
        images_base64: list[str] | None = None,
        temperature: float = 0.1,
    ) -> str:
        ...

    @abstractmethod
    async def execute_tool(
        self,
        prompt: str,
        tools: list[ToolDefinition],
        *,
        system_instruction: str | None = None,
    ) -> ToolCallResult:
        ...

    def estimate_token_usage(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
    ) -> int:
        chars = len(system_instruction or "")
        for msg in messages:
            chars += len(str(msg.get("content", "")))
            chars += 256 * len(msg.get("images_base64", []) or [])
        return max(1, math.ceil(chars / 4))

    @abstractmethod
    async def check_availability(self) -> ProviderHealth:
        ...


class LegacyGemmaAdapter(AIProvider):
    """Bridges GemmaBackend protocol doubles into the full AIProvider contract."""

    def __init__(self, backend: Any, model: str = "gemma-4-31b-it") -> None:
        self._backend = backend
        self._model = model

    @property
    def provider_name(self) -> str:
        return "gemini"

    @property
    def model_name(self) -> str:
        return self._model

    async def generate_response(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
        temperature: float = 0.15,
        max_output_tokens: int = 1024,
    ) -> str:
        chunks: list[str] = []
        async for delta in self._backend.stream_chat(
            messages,
            system_instruction=system_instruction,
            temperature=temperature,
            max_output_tokens=max_output_tokens,
        ):
            chunks.append(delta)
        return "".join(chunks)

    def stream_response(
        self,
        messages: list[dict[str, Any]],
        *,
        system_instruction: str | None = None,
        temperature: float = 0.15,
        max_output_tokens: int = 1024,
    ) -> AsyncIterator[str]:
        return self._backend.stream_chat(
            messages,
            system_instruction=system_instruction,
            temperature=temperature,
            max_output_tokens=max_output_tokens,
        )

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
        raw = await self._backend.complete_json(
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
        return await self._backend.complete_json(
            prompt,
            system_instruction=system_instruction,
            images_base64=images_base64,
            temperature=temperature,
        )

    async def execute_tool(
        self,
        prompt: str,
        tools: list[ToolDefinition],
        *,
        system_instruction: str | None = None,
    ) -> ToolCallResult:
        tool_names = ", ".join(t.name for t in tools)
        raw = await self._backend.complete_json(
            f"Choose tool from [{tool_names}] and return JSON {{tool_name, arguments}}.\n{prompt}",
            system_instruction=system_instruction,
            temperature=0.0,
        )
        try:
            parsed = json.loads(raw)
            return ToolCallResult(
                tool_name=str(parsed.get("tool_name", tools[0].name if tools else "none")),
                arguments=dict(parsed.get("arguments", {})),
                raw_text=raw,
            )
        except Exception:
            return ToolCallResult(
                tool_name=tools[0].name if tools else "none",
                arguments={},
                raw_text=raw,
            )

    async def check_availability(self) -> ProviderHealth:
        return ProviderHealth(
            provider=self.provider_name,
            model=self.model_name,
            available=True,
            reason="injected_backend",
        )
