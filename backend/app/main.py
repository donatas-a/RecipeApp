from __future__ import annotations

from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse

from app.api.routes import router
from app.core.errors import APIException
from app.core.trace import get_trace_id, trace_id_middleware
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://psychic-spork-655pjq9v7j5fw7j-4173.app.github.dev"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],


app = FastAPI(title="RecipeApp API", version="0.1.0")
app.middleware("http")(trace_id_middleware)
app.include_router(router)


@app.exception_handler(APIException)
async def handle_api_exception(_: Request, exc: APIException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"code": exc.code, "message": exc.message, "traceId": get_trace_id()},
    )


@app.exception_handler(RequestValidationError)
async def handle_validation_exception(_: Request, exc: RequestValidationError):
    first = exc.errors()[0]
    message = f"{first['loc'][-1]}: {first['msg']}"
    return JSONResponse(
        status_code=400,
        content={"code": "validation_error", "message": message, "traceId": get_trace_id()},
    )


@app.exception_handler(Exception)
async def handle_unknown_error(_: Request, __: Exception):
    return JSONResponse(
        status_code=500,
        content={"code": "internal_server_error", "message": "Unexpected server error", "traceId": get_trace_id()},
    )
