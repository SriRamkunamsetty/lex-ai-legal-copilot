"""Initial Knowledge Engine, pgvector embeddings, and Review Queue schema."""

from __future__ import annotations

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

from app.database.types import PgVector

revision: str = "0001_initial_pgvector"
down_revision: Union[str, Sequence[str], None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    bind = op.get_bind()
    if bind.dialect.name == "postgresql":
        op.execute("CREATE EXTENSION IF NOT EXISTS vector")

    op.create_table(
        "legal_instruments",
        sa.Column("instrument_id", sa.String(length=64), nullable=False),
        sa.Column("instrument_type", sa.String(length=32), nullable=False),
        sa.Column("title", sa.String(length=256), nullable=False),
        sa.Column("short_code", sa.String(length=64), nullable=False),
        sa.Column("act_number", sa.String(length=64), nullable=False, server_default=""),
        sa.Column("source_authority", sa.String(length=256), nullable=False, server_default=""),
        sa.Column("source_url", sa.String(length=512), nullable=False, server_default=""),
        sa.Column("edition_date", sa.String(length=32), nullable=False, server_default=""),
        sa.Column("full_text_available", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column(
            "verification_status",
            sa.String(length=32),
            nullable=False,
            server_default="pending_review",
        ),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.PrimaryKeyConstraint("instrument_id"),
    )
    op.create_index("ix_legal_instruments_short_code", "legal_instruments", ["short_code"])
    op.create_index("ix_legal_instruments_status", "legal_instruments", ["verification_status"])

    op.create_table(
        "legal_provisions",
        sa.Column("canonical_ref", sa.String(length=128), nullable=False),
        sa.Column("instrument_id", sa.String(length=64), nullable=False),
        sa.Column("provision_type", sa.String(length=32), nullable=False),
        sa.Column("number", sa.String(length=64), nullable=False),
        sa.Column("title", sa.String(length=512), nullable=False),
        sa.Column("part_or_chapter", sa.String(length=256), nullable=False, server_default=""),
        sa.Column("book_page", sa.Integer(), nullable=True),
        sa.Column("official_text", sa.Text(), nullable=False),
        sa.Column("consolidated_status", sa.String(length=32), nullable=False, server_default="active"),
        sa.Column("legacy_mapping", sa.String(length=128), nullable=True),
        sa.Column("source_url", sa.String(length=512), nullable=False, server_default=""),
        sa.Column("verification_status", sa.String(length=32), nullable=False, server_default="verified"),
        sa.Column("embedding", PgVector(128), nullable=True),
        sa.ForeignKeyConstraint(["instrument_id"], ["legal_instruments.instrument_id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("canonical_ref"),
    )
    op.create_index("ix_legal_provisions_instrument_id", "legal_provisions", ["instrument_id"])
    op.create_index("ix_legal_provisions_number", "legal_provisions", ["number"])

    if bind.dialect.name == "postgresql":
        op.execute(
            "CREATE INDEX IF NOT EXISTS ix_legal_provisions_embedding_cosine "
            "ON legal_provisions USING ivfflat (embedding vector_cosine_ops) WITH (lists = 32)"
        )

    op.create_table(
        "legal_footnotes",
        sa.Column("footnote_id", sa.String(length=128), nullable=False),
        sa.Column("provision_ref", sa.String(length=128), nullable=False),
        sa.Column("footnote_marker", sa.String(length=32), nullable=False, server_default=""),
        sa.Column("footnote_type", sa.String(length=32), nullable=False, server_default="amendment"),
        sa.Column("note_text", sa.Text(), nullable=False),
        sa.Column("book_page", sa.Integer(), nullable=True),
        sa.ForeignKeyConstraint(["provision_ref"], ["legal_provisions.canonical_ref"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("footnote_id"),
    )
    op.create_index("ix_legal_footnotes_provision_ref", "legal_footnotes", ["provision_ref"])

    op.create_table(
        "legal_entities",
        sa.Column("entity_id", sa.String(length=128), nullable=False),
        sa.Column("entity_type", sa.String(length=48), nullable=False),
        sa.Column("label", sa.String(length=256), nullable=False),
        sa.Column("metadata_json", sa.Text(), nullable=False, server_default="{}"),
        sa.PrimaryKeyConstraint("entity_id"),
    )

    op.create_table(
        "legal_relations",
        sa.Column("relation_id", sa.String(length=128), nullable=False),
        sa.Column("source_entity_id", sa.String(length=128), nullable=False),
        sa.Column("relation_type", sa.String(length=48), nullable=False),
        sa.Column("target_entity_id", sa.String(length=128), nullable=False),
        sa.Column("evidence_ref", sa.String(length=128), nullable=False, server_default=""),
        sa.PrimaryKeyConstraint("relation_id"),
    )

    op.create_table(
        "knowledge_review_queue",
        sa.Column("reference_id", sa.String(length=128), nullable=False),
        sa.Column("instrument_id", sa.String(length=64), nullable=False),
        sa.Column("reference_type", sa.String(length=48), nullable=False),
        sa.Column("reference_number", sa.String(length=128), nullable=False),
        sa.Column("title", sa.String(length=512), nullable=False),
        sa.Column("source_text", sa.Text(), nullable=False),
        sa.Column("book_page", sa.Integer(), nullable=True),
        sa.Column("full_text_available", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("verification_status", sa.String(length=32), nullable=False, server_default="pending_review"),
        sa.Column("reviewer_id", sa.String(length=128), nullable=True),
        sa.Column("review_notes", sa.Text(), nullable=False, server_default=""),
        sa.Column("reviewed_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.PrimaryKeyConstraint("reference_id"),
    )

    op.create_table(
        "knowledge_pack_releases",
        sa.Column("release_id", sa.String(length=128), nullable=False),
        sa.Column("pack_id", sa.String(length=64), nullable=False),
        sa.Column("version", sa.String(length=32), nullable=False),
        sa.Column("sha256", sa.String(length=64), nullable=False),
        sa.Column("provision_count", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("published_by", sa.String(length=128), nullable=False),
        sa.Column("published_at", sa.DateTime(timezone=True), nullable=False),
        sa.PrimaryKeyConstraint("release_id"),
    )

    op.create_table(
        "admin_audit_logs",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("actor_id", sa.String(length=128), nullable=False),
        sa.Column("action", sa.String(length=64), nullable=False),
        sa.Column("target_id", sa.String(length=128), nullable=False),
        sa.Column("details_json", sa.Text(), nullable=False, server_default="{}"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_table(
        "device_rate_limits",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("device_hash", sa.String(length=64), nullable=False),
        sa.Column("created_epoch", sa.Integer(), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_rate_device_ts", "device_rate_limits", ["device_hash", "created_epoch"])


def downgrade() -> None:
    op.drop_table("device_rate_limits")
    op.drop_table("admin_audit_logs")
    op.drop_table("knowledge_pack_releases")
    op.drop_table("knowledge_review_queue")
    op.drop_table("legal_relations")
    op.drop_table("legal_entities")
    op.drop_table("legal_footnotes")
    op.drop_table("legal_provisions")
    op.drop_table("legal_instruments")
