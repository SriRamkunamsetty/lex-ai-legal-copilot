"""Milestone P5: Optional Workspace Accounts, Multi-Tenant Org RBAC & E2EE Sync Blobs."""

from __future__ import annotations

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = "0002_e2ee_sync_and_org_rbac"
down_revision: Union[str, Sequence[str], None] = "0001_initial_pgvector"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "workspace_users",
        sa.Column("user_id", sa.String(length=64), nullable=False),
        sa.Column("email_hash", sa.String(length=64), nullable=False),
        sa.Column("display_label", sa.String(length=128), nullable=False, server_default="Lex User"),
        sa.Column("password_salt_b64", sa.String(length=64), nullable=False),
        sa.Column("password_hash_b64", sa.String(length=128), nullable=False),
        sa.Column("active", sa.Boolean(), nullable=False, server_default=sa.true()),
        sa.Column("token_version", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.PrimaryKeyConstraint("user_id"),
    )
    op.create_index("ix_workspace_users_email_hash", "workspace_users", ["email_hash"], unique=True)

    op.create_table(
        "organizations",
        sa.Column("org_id", sa.String(length=64), nullable=False),
        sa.Column("name", sa.String(length=160), nullable=False),
        sa.Column("created_by_user_id", sa.String(length=64), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["created_by_user_id"], ["workspace_users.user_id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("org_id"),
    )

    op.create_table(
        "org_memberships",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("org_id", sa.String(length=64), nullable=False),
        sa.Column("user_id", sa.String(length=64), nullable=False),
        sa.Column("role", sa.String(length=32), nullable=False, server_default="viewer"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["org_id"], ["organizations.org_id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["user_id"], ["workspace_users.user_id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_org_user_unique", "org_memberships", ["org_id", "user_id"], unique=True)

    op.create_table(
        "device_registrations",
        sa.Column("device_id", sa.String(length=128), nullable=False),
        sa.Column("user_id", sa.String(length=64), nullable=False),
        sa.Column("device_name", sa.String(length=128), nullable=False, server_default="Mobile Device"),
        sa.Column("platform", sa.String(length=32), nullable=False, server_default="android"),
        sa.Column("revoked", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("last_seen_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["user_id"], ["workspace_users.user_id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("device_id"),
    )

    op.create_table(
        "encrypted_sync_blobs",
        sa.Column("blob_id", sa.String(length=128), nullable=False),
        sa.Column("owner_user_id", sa.String(length=64), nullable=False),
        sa.Column("org_id", sa.String(length=64), nullable=True),
        sa.Column("record_type", sa.String(length=48), nullable=False),
        sa.Column("record_id", sa.String(length=128), nullable=False),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("nonce_b64", sa.String(length=64), nullable=False),
        sa.Column("ciphertext_b64", sa.Text(), nullable=False),
        sa.Column("tag_b64", sa.String(length=64), nullable=False),
        sa.Column("key_epoch", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("deleted", sa.Boolean(), nullable=False, server_default=sa.false()),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(["owner_user_id"], ["workspace_users.user_id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["org_id"], ["organizations.org_id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("blob_id"),
    )
    op.create_index(
        "ix_sync_owner_org",
        "encrypted_sync_blobs",
        ["owner_user_id", "org_id", "record_type", "record_id"],
    )


def downgrade() -> None:
    op.drop_table("encrypted_sync_blobs")
    op.drop_table("device_registrations")
    op.drop_table("org_memberships")
    op.drop_table("organizations")
    op.drop_table("workspace_users")
