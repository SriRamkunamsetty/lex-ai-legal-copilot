from __future__ import annotations

from typing import Any, Literal

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
    provider: str | None = Field(default=None, max_length=32)


class VerifiedResearchRequest(BaseModel):
    query: str = Field(min_length=3, max_length=8000)
    temperature: float = Field(default=0.1, ge=0.0, le=0.5)
    provider: str | None = Field(default=None, max_length=32)


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
    ocr_text: str = Field(default="", max_length=60000)
    images_base64: list[str] = Field(default_factory=list)


class SectionResponse(BaseModel):
    act_code: str
    act_name: str
    section_number: str
    title: str
    chapter: str
    text: str
    source_url: str = ""
    legacy_mapping: str | None = None
    canonical_ref: str | None = None
    consolidated_status: str = "active"
    book_page: int | None = None
    verification_status: str = "verified"


class ReviewDecisionRequest(BaseModel):
    decision: Literal["approve", "reject"]
    review_notes: str = Field(default="", max_length=2000)
    mark_full_text_available: bool = False


class PackPublishRequest(BaseModel):
    pack_id: str = Field(min_length=2, max_length=64, pattern="^[a-zA-Z0-9_.-]+$")
    asset_filename: str = Field(
        min_length=5,
        max_length=128,
        pattern="^[a-zA-Z0-9_.-]+\\.json$",
    )
    version: str = Field(min_length=1, max_length=32)


class WorkspaceRegisterRequest(BaseModel):
    email: str = Field(min_length=5, max_length=254)
    password: str = Field(min_length=8, max_length=128)
    display_label: str = Field(default="Lex User", min_length=2, max_length=128)
    device_id: str = Field(min_length=4, max_length=128)
    device_name: str = Field(default="Mobile Device", max_length=128)
    platform: str = Field(default="android", pattern="^(android|ios|desktop|other)$")


class WorkspaceLoginRequest(BaseModel):
    email: str = Field(min_length=5, max_length=254)
    password: str = Field(min_length=8, max_length=128)
    device_id: str = Field(min_length=4, max_length=128)
    device_name: str = Field(default="Mobile Device", max_length=128)
    platform: str = Field(default="android", pattern="^(android|ios|desktop|other)$")


class WorkspaceAuthResponse(BaseModel):
    user_id: str
    token: str
    expires_at: int


class CreateOrgRequest(BaseModel):
    name: str = Field(min_length=2, max_length=160)


class AddOrgMemberRequest(BaseModel):
    user_id: str = Field(min_length=4, max_length=64)
    role: Literal["viewer", "advocate", "admin", "owner"]


class SyncBlobIn(BaseModel):
    org_id: str | None = Field(default=None, max_length=64)
    record_type: Literal["case_file", "draft", "bookmark", "scan_meta"]
    record_id: str = Field(min_length=1, max_length=128, pattern="^[a-zA-Z0-9_.:-]+$")
    version: int = Field(default=1, ge=1)
    nonce_b64: str = Field(min_length=8, max_length=64)
    ciphertext_b64: str = Field(min_length=4, max_length=1_500_000)
    tag_b64: str = Field(min_length=8, max_length=64)
    key_epoch: int = Field(default=1, ge=1)
    deleted: bool = False


class SyncPushRequest(BaseModel):
    blobs: list[SyncBlobIn] = Field(min_length=1, max_length=50)
