from __future__ import annotations

from typing import Any
from pydantic import BaseModel, Field


class DeviceTokenRequest(BaseModel):
    device_id: str = Field(min_length=4, max_length=128)


class DeviceTokenResponse(BaseModel):
    token: str
    expires_at: int


class ChatMessageIn(BaseModel):
    role: str = Field(pattern="^(system|user|assistant)$")
    content: str = Field(min_length=1, max_length=32000)
    images_base64: list[str] = Field(default_factory=list)


class ChatRequest(BaseModel):
    messages: list[ChatMessageIn] = Field(min_length=1)
    temperature: float = Field(default=0.15, ge=0.0, le=1.0)
    max_output_tokens: int = Field(default=1024, ge=64, le=8192)
    system_instruction: str | None = None


class IncidentRequest(BaseModel):
    incident_type: str | None = None
    description: str = Field(min_length=3, max_length=8000)


class ContractReviewRequest(BaseModel):
    contract_text: str = Field(min_length=20, max_length=60000)


class DraftRequest(BaseModel):
    template_type: str = Field(min_length=2, max_length=64)
    fields: dict[str, Any] = Field(default_factory=dict)


class DocumentAnalyzeRequest(BaseModel):
    prompt: str = Field(default="Extract key legal fields and summarize.")
    ocr_text: str = ""
    images_base64: list[str] = Field(default_factory=list)


class SectionResponse(BaseModel):
    act_code: str
    act_name: str
    section_number: str
    title: str
    chapter: str
    text: str
    source_url: str
    legacy_mapping: str | None = None
