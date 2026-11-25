from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any


class CorpusStore:
    """In-memory Indian statutory corpus store with keyword/citation retrieval.

    Can be swapped for pgvector or Chroma embeddings without changing routes.
    """

    def __init__(self, sections: list[dict[str, Any]]) -> None:
        self.sections = sections
        self._by_key: dict[tuple[str, str], dict[str, Any]] = {
            (s["act_code"].upper(), str(s["section_number"]).strip()): s
            for s in sections
        }

    @classmethod
    def from_file(cls, path: str | Path) -> CorpusStore:
        p = Path(path)
        if not p.exists():
            return cls([])
        data = json.loads(p.read_text(encoding="utf-8"))
        return cls(data.get("sections", []))

    def get_section(self, act: str, number: str) -> dict[str, Any] | None:
        return self._by_key.get((act.upper().strip(), number.strip()))

    def search(self, query: str, limit: int = 5) -> list[dict[str, Any]]:
        tokens = [
            t.lower()
            for t in re.findall(r"[a-zA-Z0-9]+", query)
            if len(t) >= 2
        ]
        if not tokens:
            return self.sections[:limit]

        scored: list[tuple[int, dict[str, Any]]] = []
        for s in self.sections:
            haystack = (
                f"{s['act_code']} {s['section_number']} "
                f"{s['title']} {s['chapter']} {s['text'][:600]}"
            ).lower()
            score = 0
            for tok in tokens:
                if tok == str(s["section_number"]).lower():
                    score += 10
                if tok in s["title"].lower():
                    score += 5
                if tok in haystack:
                    score += 1
            if score > 0:
                scored.append((score, s))

        scored.sort(key=lambda item: item[0], reverse=True)
        return [item[1] for item in scored[:limit]]
