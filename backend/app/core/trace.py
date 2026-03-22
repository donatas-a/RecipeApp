from __future__ import annotations

from contextvars import ContextVar
from uuid import uuid4

from fastapi import Request

trace_id_ctx: ContextVar[str] = ContextVar("trace_id", default="")


async def trace_id_middleware(request: Request, call_next):
    trace_id = request.headers.get("x-request-id") or f"req_{uuid4().hex[:12]}"
    trace_id_ctx.set(trace_id)
    response = await call_next(request)
    response.headers["x-trace-id"] = trace_id
    return response


def get_trace_id() -> str:
    value = trace_id_ctx.get()
    return value or f"req_{uuid4().hex[:12]}"
