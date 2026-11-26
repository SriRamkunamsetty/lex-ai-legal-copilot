from __future__ import annotations

from datetime import datetime, timezone
from typing import Any

from sqlalchemy import Boolean, DateTime, ForeignKey, Index, Integer, String, Text
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

from app.database.types import PgVector


def _utcnow() -> datetime:
    return datetime.now(timezone.utc)


class Base(DeclarativeBase):
    """Declarative base for Lex Legal Knowledge & Proxy operational tables."""


class LegalInstrumentRow(Base):
    __tablename__ = "legal_instruments"

    instrument_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    instrument_type: Mapped[str] = mapped_column(String(32), nullable=False)
    title: Mapped[str] = mapped_column(String(256), nullable=False)
    short_code: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    act_number: Mapped[str] = mapped_column(String(64), default="", nullable=False)
    source_authority: Mapped[str] = mapped_column(String(256), default="", nullable=False)
    source_url: Mapped[str] = mapped_column(String(512), default="", nullable=False)
    edition_date: Mapped[str] = mapped_column(String(32), default="", nullable=False)
    full_text_available: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    verification_status: Mapped[str] = mapped_column(
        String(32),
        default="pending_review",
        nullable=False,
        index=True,
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=_utcnow,
        onupdate=_utcnow,
        nullable=False,
    )


class LegalProvisionRow(Base):
    __tablename__ = "legal_provisions"

    canonical_ref: Mapped[str] = mapped_column(String(128), primary_key=True)
    instrument_id: Mapped[str] = mapped_column(
        String(64),
        ForeignKey("legal_instruments.instrument_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    provision_type: Mapped[str] = mapped_column(String(32), nullable=False)
    number: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    title: Mapped[str] = mapped_column(String(512), nullable=False)
    part_or_chapter: Mapped[str] = mapped_column(String(256), default="", nullable=False)
    book_page: Mapped[int | None] = mapped_column(Integer, nullable=True)
    official_text: Mapped[str] = mapped_column(Text, nullable=False)
    consolidated_status: Mapped[str] = mapped_column(
        String(32),
        default="active",
        nullable=False,
        index=True,
    )
    legacy_mapping: Mapped[str | None] = mapped_column(String(128), nullable=True)
    source_url: Mapped[str] = mapped_column(String(512), default="", nullable=False)
    verification_status: Mapped[str] = mapped_column(
        String(32),
        default="verified",
        nullable=False,
        index=True,
    )
    embedding: Mapped[list[float] | None] = mapped_column(PgVector(128), nullable=True)


class LegalFootnoteRow(Base):
    __tablename__ = "legal_footnotes"

    footnote_id: Mapped[str] = mapped_column(String(128), primary_key=True)
    provision_ref: Mapped[str] = mapped_column(
        String(128),
        ForeignKey("legal_provisions.canonical_ref", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    footnote_marker: Mapped[str] = mapped_column(String(32), default="", nullable=False)
    footnote_type: Mapped[str] = mapped_column(String(32), default="amendment", nullable=False)
    note_text: Mapped[str] = mapped_column(Text, nullable=False)
    book_page: Mapped[int | None] = mapped_column(Integer, nullable=True)


class LegalEntityRow(Base):
    __tablename__ = "legal_entities"

    entity_id: Mapped[str] = mapped_column(String(128), primary_key=True)
    entity_type: Mapped[str] = mapped_column(String(48), nullable=False, index=True)
    label: Mapped[str] = mapped_column(String(256), nullable=False)
    metadata_json: Mapped[str] = mapped_column(Text, default="{}", nullable=False)


class LegalRelationRow(Base):
    __tablename__ = "legal_relations"

    relation_id: Mapped[str] = mapped_column(String(128), primary_key=True)
    source_entity_id: Mapped[str] = mapped_column(String(128), nullable=False, index=True)
    relation_type: Mapped[str] = mapped_column(String(48), nullable=False, index=True)
    target_entity_id: Mapped[str] = mapped_column(String(128), nullable=False, index=True)
    evidence_ref: Mapped[str] = mapped_column(String(128), default="", nullable=False)


class KnowledgeReviewItemRow(Base):
    """Module I human-review queue for book-extracted & external references."""

    __tablename__ = "knowledge_review_queue"

    reference_id: Mapped[str] = mapped_column(String(128), primary_key=True)
    instrument_id: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    reference_type: Mapped[str] = mapped_column(String(48), nullable=False)
    reference_number: Mapped[str] = mapped_column(String(128), nullable=False)
    title: Mapped[str] = mapped_column(String(512), nullable=False)
    source_text: Mapped[str] = mapped_column(Text, nullable=False)
    book_page: Mapped[int | None] = mapped_column(Integer, nullable=True)
    full_text_available: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    verification_status: Mapped[str] = mapped_column(
        String(32),
        default="pending_review",
        nullable=False,
        index=True,
    )
    reviewer_id: Mapped[str | None] = mapped_column(String(128), nullable=True)
    review_notes: Mapped[str] = mapped_column(Text, default="", nullable=False)
    reviewed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_utcnow)


class KnowledgePackReleaseRow(Base):
    """Published signed Module H Knowledge Pack manifest versions."""

    __tablename__ = "knowledge_pack_releases"

    release_id: Mapped[str] = mapped_column(String(128), primary_key=True)
    pack_id: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    version: Mapped[str] = mapped_column(String(32), nullable=False)
    sha256: Mapped[str] = mapped_column(String(64), nullable=False)
    provision_count: Mapped[int] = mapped_column(Integer, default=0, nullable=False)
    published_by: Mapped[str] = mapped_column(String(128), nullable=False)
    published_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_utcnow)


class AdminAuditLogRow(Base):
    """Immutable audit log of Module I Knowledge Admin decisions & pack releases."""

    __tablename__ = "admin_audit_logs"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    actor_id: Mapped[str] = mapped_column(String(128), nullable=False, index=True)
    action: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    target_id: Mapped[str] = mapped_column(String(128), nullable=False)
    details_json: Mapped[str] = mapped_column(Text, default="{}", nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_utcnow)


class RateLimitHitRow(Base):
    """Durable per-device sliding-window timestamps (PostgreSQL/SQLite backed)."""

    __tablename__ = "device_rate_limits"
    __table_args__ = (Index("ix_rate_device_ts", "device_hash", "created_epoch"),)

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    device_hash: Mapped[str] = mapped_column(String(64), nullable=False)
    created_epoch: Mapped[int] = mapped_column(Integer, nullable=False)


class WorkspaceUserRow(Base):
    """Optional cloud-sync user account (never required for local offline mode)."""

    __tablename__ = "workspace_users"

    user_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    email_hash: Mapped[str] = mapped_column(String(64), unique=True, nullable=False, index=True)
    display_label: Mapped[str] = mapped_column(String(128), default="Lex User", nullable=False)
    password_salt_b64: Mapped[str] = mapped_column(String(64), nullable=False)
    password_hash_b64: Mapped[str] = mapped_column(String(128), nullable=False)
    active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    token_version: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_utcnow)


class OrganizationRow(Base):
    """Multi-tenant law firm or startup workspace."""

    __tablename__ = "organizations"

    org_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    name: Mapped[str] = mapped_column(String(160), nullable=False)
    created_by_user_id: Mapped[str] = mapped_column(
        String(64),
        ForeignKey("workspace_users.user_id", ondelete="CASCADE"),
        nullable=False,
    )
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_utcnow)


class OrgMembershipRow(Base):
    """RBAC membership joining users and organizations."""

    __tablename__ = "org_memberships"
    __table_args__ = (Index("ix_org_user_unique", "org_id", "user_id", unique=True),)

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    org_id: Mapped[str] = mapped_column(
        String(64),
        ForeignKey("organizations.org_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    user_id: Mapped[str] = mapped_column(
        String(64),
        ForeignKey("workspace_users.user_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    role: Mapped[str] = mapped_column(String(32), default="viewer", nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_utcnow)


class DeviceRegistrationRow(Base):
    """Registered client devices linked to an optional sync account."""

    __tablename__ = "device_registrations"

    device_id: Mapped[str] = mapped_column(String(128), primary_key=True)
    user_id: Mapped[str] = mapped_column(
        String(64),
        ForeignKey("workspace_users.user_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    device_name: Mapped[str] = mapped_column(String(128), default="Mobile Device", nullable=False)
    platform: Mapped[str] = mapped_column(String(32), default="android", nullable=False)
    revoked: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    last_seen_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_utcnow)


class EncryptedSyncBlobRow(Base):
    """Zero-knowledge client-encrypted E2EE sync envelope."""

    __tablename__ = "encrypted_sync_blobs"
    __table_args__ = (
        Index("ix_sync_owner_org", "owner_user_id", "org_id", "record_type", "record_id"),
    )

    blob_id: Mapped[str] = mapped_column(String(128), primary_key=True)
    owner_user_id: Mapped[str] = mapped_column(
        String(64),
        ForeignKey("workspace_users.user_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    org_id: Mapped[str | None] = mapped_column(
        String(64),
        ForeignKey("organizations.org_id", ondelete="CASCADE"),
        nullable=True,
        index=True,
    )
    record_type: Mapped[str] = mapped_column(String(48), nullable=False)
    record_id: Mapped[str] = mapped_column(String(128), nullable=False)
    version: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    nonce_b64: Mapped[str] = mapped_column(String(64), nullable=False)
    ciphertext_b64: Mapped[str] = mapped_column(Text, nullable=False)
    tag_b64: Mapped[str] = mapped_column(String(64), nullable=False)
    key_epoch: Mapped[int] = mapped_column(Integer, default=1, nullable=False)
    deleted: Mapped[bool] = mapped_column(Boolean, default=False, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=_utcnow,
        onupdate=_utcnow,
        nullable=False,
    )


def provision_row_to_dict(row: LegalProvisionRow, instrument: LegalInstrumentRow | None = None) -> dict[str, Any]:
    return {
        "canonical_ref": row.canonical_ref,
        "instrument_id": row.instrument_id,
        "act_code": instrument.short_code if instrument else row.instrument_id,
        "act_name": instrument.title if instrument else row.instrument_id,
        "section_number": row.number,
        "title": row.title,
        "chapter": row.part_or_chapter,
        "text": row.official_text,
        "book_page": row.book_page,
        "consolidated_status": row.consolidated_status,
        "verification_status": row.verification_status,
        "source_url": row.source_url,
        "legacy_mapping": row.legacy_mapping,
    }
