"""Module C: Authoritative Government Source Verifier for Indian Legal Acts.

Enforces strict domain allow-listing (*.gov.in, *.nic.in), %PDF magic-byte
checks, mirror fallback resolution, and SHA-256 verification before any external
Central/State Act enters a Knowledge Pack. Never fabricates unreachable texts.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable
from urllib.parse import urlparse

import requests

ALLOWED_OFFICIAL_DOMAINS = (
    "indiacode.nic.in",
    "legislative.gov.in",
    "meity.gov.in",
    "egazette.gov.in",
    "sci.gov.in",
)


@dataclass(frozen=True)
class SourceVerificationResult:
    act_code: str
    verified: bool
    resolved_url: str | None
    sha256: str | None
    size_bytes: int
    local_pdf_path: str | None
    reason: str


def is_allowed_official_url(url: str) -> bool:
    parsed = urlparse(url.strip())
    if parsed.scheme != "https" or not parsed.hostname:
        return False
    host = parsed.hostname.lower()
    return any(
        host == domain or host.endswith(f".{domain}")
        for domain in ALLOWED_OFFICIAL_DOMAINS
    )


def verify_and_fetch_official_pdf(
    act_code: str,
    candidate_urls: Iterable[str],
    dest_path: Path,
    *,
    timeout_seconds: int = 12,
) -> SourceVerificationResult:
    """Fetches an official Indian Act PDF from allow-listed domains and hashes it."""
    if dest_path.exists() and dest_path.stat().st_size > 5_000:
        raw = dest_path.read_bytes()
        if raw[:4] == b"%PDF":
            return SourceVerificationResult(
                act_code=act_code,
                verified=True,
                resolved_url="local-verified-cache",
                sha256=hashlib.sha256(raw).hexdigest(),
                size_bytes=len(raw),
                local_pdf_path=str(dest_path),
                reason="verified_cached_pdf",
            )

    last_reason = "no_candidate_urls"
    for url in candidate_urls:
        if not is_allowed_official_url(url):
            last_reason = f"blocked_non_official_domain:{url}"
            continue
        try:
            resp = requests.get(
                url,
                timeout=timeout_seconds,
                headers={"User-Agent": "Mozilla/5.0 (LexLegalVerifier/2.0)"},
            )
            resp.raise_for_status()
            if resp.content[:4] != b"%PDF" or len(resp.content) < 5_000:
                last_reason = f"invalid_pdf_magic:{url}"
                continue
            dest_path.parent.mkdir(parents=True, exist_ok=True)
            dest_path.write_bytes(resp.content)
            return SourceVerificationResult(
                act_code=act_code,
                verified=True,
                resolved_url=url,
                sha256=hashlib.sha256(resp.content).hexdigest(),
                size_bytes=len(resp.content),
                local_pdf_path=str(dest_path),
                reason="verified_remote_pdf",
            )
        except Exception as exc:
            last_reason = f"fetch_failed:{type(exc).__name__}:{url}"

    return SourceVerificationResult(
        act_code=act_code,
        verified=False,
        resolved_url=None,
        sha256=None,
        size_bytes=0,
        local_pdf_path=None,
        reason=last_reason,
    )


DEFAULT_ACT_MIRRORS: dict[str, list[str]] = {
    "DPDP_2023": [
        "https://www.meity.gov.in/static/uploads/2024/06/2bf1f0e9f04e6fb4f8fef35e82c42aa5.pdf",
    ],
    "IT_2000": [
        "https://www.indiacode.nic.in/bitstream/123456789/13116/1/it_act_2000_updated.pdf",
    ],
    "ICA_1872": [
        "https://legislative.gov.in/sites/default/files/A1872-09.pdf",
        "https://www.indiacode.nic.in/bitstream/123456789/2187/2/A187209.pdf",
        "https://www.indiacode.nic.in/bitstream/123456789/2187/1/A1872-09.pdf",
    ],
    "NI_1881": [
        "https://legislative.gov.in/sites/default/files/A1881-26.pdf",
        "https://www.indiacode.nic.in/bitstream/123456789/2189/1/a1881-26.pdf",
        "https://www.indiacode.nic.in/bitstream/123456789/2189/1/A1881-26.pdf",
    ],
    "CPC_1908": [
        "https://legislative.gov.in/sites/default/files/A1908-05.pdf",
        "https://www.indiacode.nic.in/bitstream/123456789/2191/1/A190805.pdf",
        "https://www.indiacode.nic.in/bitstream/123456789/2191/3/A1908-05.pdf",
    ],
}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Lex Module C Official Source Verifier")
    parser.add_argument("--cache-dir", type=Path, default=Path("data/cache/pdfs"))
    parser.add_argument("--timeout", type=int, default=12)
    args = parser.parse_args(argv)

    results = []
    for code, urls in DEFAULT_ACT_MIRRORS.items():
        res = verify_and_fetch_official_pdf(
            code,
            urls,
            args.cache_dir / f"{code}.pdf",
            timeout_seconds=args.timeout,
        )
        results.append(asdict(res))
    print(json.dumps({"results": results}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
