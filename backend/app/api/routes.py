from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query

from app.api.dependencies import get_recipes_service
from app.repositories.recipes import RecipeQuery
from app.models.schemas import FiltersResponse, HealthResponse, RecipeDetailResponse, RecipesListResponse
from app.services.recipes_service import RecipesService

router = APIRouter(prefix="/api/v1", tags=["recipes"])


@router.get("/recipes", response_model=RecipesListResponse)
def list_recipes(
    service: Annotated[RecipesService, Depends(get_recipes_service)],
    q: str | None = Query(default=None, max_length=120),
    tag: list[str] | None = Query(default=None),
    maxPrepTime: int | None = Query(default=None, ge=0),
    maxCookTime: int | None = Query(default=None, ge=0),
    limit: int = Query(default=20, ge=1, le=50),
    cursor: str | None = None,
):
    query = RecipeQuery(
        q=q,
        tag=tag,
        max_prep_time=maxPrepTime,
        max_cook_time=maxCookTime,
        limit=limit,
        cursor=cursor,
    )
    return service.list_recipes(query)


@router.get("/recipes/{recipe_id}", response_model=RecipeDetailResponse)
def get_recipe(recipe_id: UUID, service: Annotated[RecipesService, Depends(get_recipes_service)]):
    return service.get_recipe(recipe_id)


@router.get("/filters", response_model=FiltersResponse)
def get_filters(service: Annotated[RecipesService, Depends(get_recipes_service)]):
    return service.get_filters()


@router.get("/health", response_model=HealthResponse, tags=["health"])
def get_health() -> HealthResponse:
    return HealthResponse(version="0.1.0")
