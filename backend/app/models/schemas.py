from __future__ import annotations

from typing import Literal
from uuid import UUID

from pydantic import BaseModel, Field


class RecipeCard(BaseModel):
    id: UUID
    title: str
    description: str | None = None
    servings: float | None = None
    prepTimeMinutes: int | None = None
    cookTimeMinutes: int | None = None
    tags: list[str] = Field(default_factory=list)


class RecipesListResponse(BaseModel):
    items: list[RecipeCard]
    nextCursor: str | None = None
    totalApprox: int | None = None


class IngredientItem(BaseModel):
    id: UUID
    name: str
    quantity: float | None = None
    unit: str | None = None
    note: str | None = None
    position: int


class StepItem(BaseModel):
    stepNumber: int
    instruction: str


class NutritionSummary(BaseModel):
    kcalTotal: float | None = None
    proteinGTotal: float | None = None
    kcalPerServing: float | None = None
    proteinGPerServing: float | None = None


class RecipeDetailResponse(BaseModel):
    id: UUID
    title: str
    description: str | None = None
    servings: float | None = None
    prepTimeMinutes: int | None = None
    cookTimeMinutes: int | None = None
    sourceUrl: str | None = None
    ingredients: list[IngredientItem]
    steps: list[StepItem]
    nutrition: NutritionSummary
    tags: list[str] = Field(default_factory=list)


class FiltersResponse(BaseModel):
    tags: list[str] = Field(default_factory=list)
    maxPrepTimeOptions: list[int] = Field(default_factory=list)
    maxCookTimeOptions: list[int] = Field(default_factory=list)


class HealthResponse(BaseModel):
    status: Literal["ok"] = "ok"
    version: str


class APIError(BaseModel):
    code: str
    message: str
    traceId: str
