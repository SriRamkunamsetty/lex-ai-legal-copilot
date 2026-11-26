from __future__ import annotations

import json
import math
from typing import Any

from sqlalchemy.engine import Dialect
from sqlalchemy.types import TEXT, TypeDecorator, UserDefinedType


class _PgVectorType(UserDefinedType):
    cache_ok = True

    def __init__(self, dim: int = 128) -> None:
        self.dim = dim

    def get_col_spec(self, **kw: Any) -> str:
        return f"vector({self.dim})"


class PgVector(TypeDecorator[list[float]]):
    """Dialect-aware vector column: PostgreSQL pgvector(N) in prod, JSON text in SQLite."""

    impl = TEXT
    cache_ok = True

    def __init__(self, dim: int = 128) -> None:
        super().__init__()
        self.dim = dim

    def load_dialect_impl(self, dialect: Dialect) -> Any:
        if dialect.name == "postgresql":
            return dialect.type_descriptor(_PgVectorType(self.dim))
        return dialect.type_descriptor(TEXT())

    def process_bind_param(
        self,
        value: list[float] | None,
        dialect: Dialect,
    ) -> str | None:
        if value is None:
            return None
        if dialect.name == "postgresql":
            return "[" + ",".join(f"{float(v):.6f}" for v in value) + "]"
        return json.dumps([round(float(v), 6) for v in value])

    def process_result_value(
        self,
        value: Any,
        dialect: Dialect,
    ) -> list[float] | None:
        if value is None:
            return None
        if isinstance(value, list):
            return [float(x) for x in value]
        raw = str(value).strip()
        if not raw:
            return None
        if raw.startswith("["):
            return [float(x) for x in json.loads(raw)]
        return [float(x) for x in raw.strip("[]").split(",") if x.strip()]


def deterministic_legal_embedding(text: str, dim: int = 128) -> list[float]:
    """Produces a normalized 128-dim hashed lexical+semantic vector for hybrid retrieval."""
    import hashlib
    import re

    vec = [0.0] * dim
    tokens = re.findall(r"[a-zA-Z0-9_]+", text.lower())
    if not tokens:
        return vec
    for tok in tokens:
        digest = hashlib.blake2b(tok.encode("utf-8"), digest_size=8).digest()
        idx = int.from_bytes(digest[:4], "little") % dim
        sign = 1.0 if (digest[4] & 1) == 0 else -1.0
        weight = 1.5 if tok.isdigit() or tok.startswith(("art", "sec", "const")) else 1.0
        vec[idx] += sign * weight
    norm = math.sqrt(sum(v * v for v in vec)) or 1.0
    return [round(v / norm, 6) for v in vec]


def cosine_similarity(a: list[float] | None, b: list[float] | None) -> float:
    if not a or not b or len(a) != len(b):
        return 0.0
    dot = sum(x * y for x, y in zip(a, b))
    na = math.sqrt(sum(x * x for x in a))
    nb = math.sqrt(sum(y * y for y in b))
    if na == 0.0 or nb == 0.0:
        return 0.0
    return dot / (na * nb)
