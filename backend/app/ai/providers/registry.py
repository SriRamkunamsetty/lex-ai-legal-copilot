from __future__ import annotations

from app.ai.providers.base import AIProvider, ProviderHealth


class ProviderRegistry:
    """Provider-agnostic registry configured with Google Gemini/Gemma first."""

    def __init__(self, primary: AIProvider) -> None:
        self._providers: dict[str, AIProvider] = {primary.provider_name: primary}
        self._primary_name = primary.provider_name

    def register(self, provider: AIProvider) -> None:
        self._providers[provider.provider_name] = provider

    def get(self, name: str | None = None) -> AIProvider:
        target = (name or self._primary_name).strip().lower()
        if target not in self._providers:
            raise KeyError(
                f"AI provider '{target}' is not enabled on this deployment."
            )
        return self._providers[target]

    def list_providers(self) -> list[str]:
        return list(self._providers.keys())

    async def health_summary(self) -> list[ProviderHealth]:
        return [await p.check_availability() for p in self._providers.values()]
