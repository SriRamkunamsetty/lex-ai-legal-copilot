from __future__ import annotations

import logging
import time
from typing import Any

from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import Response

logger = logging.getLogger("lex.proxy")


class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    """Applies strict API security headers on every response."""

    async def dispatch(self, request: Request, call_next: Any) -> Response:
        response = await call_next(request)
        response.headers.setdefault("X-Content-Type-Options", "nosniff")
        response.headers.setdefault("X-Frame-Options", "DENY")
        response.headers.setdefault("Referrer-Policy", "no-referrer")
        response.headers.setdefault("Cache-Control", "no-store")
        response.headers.setdefault(
            "Permissions-Policy",
            "camera=(), microphone=(), geolocation=()",
        )
        response.headers.setdefault(
            "Content-Security-Policy",
            "default-src 'none'; frame-ancestors 'none'; base-uri 'none';",
        )
        return response


class PrivacyAuditLoggingMiddleware(BaseHTTPMiddleware):
    """Logs HTTP metadata + hashed device ID only — never bodies, queries, or PII."""

    async def dispatch(self, request: Request, call_next: Any) -> Response:
        start = time.perf_counter()
        response = await call_next(request)
        elapsed_ms = (time.perf_counter() - start) * 1000
        device_hash = getattr(request.state, "device_hash", "anon")
        logger.info(
            "method=%s path=%s status=%s latency_ms=%.1f device=%s",
            request.method,
            request.url.path,
            response.status_code,
            elapsed_ms,
            device_hash,
        )
        return response
