from __future__ import annotations

from dataclasses import dataclass
from typing import Protocol
from uuid import UUID, uuid4
import base64

from app.models.schemas import (
    FiltersResponse,
    NutritionSummary,
    RecipeCard,
    RecipeDetailResponse,
    RecipesListResponse,
    IngredientItem,
    StepItem,
)


@dataclass
class RecipeQuery:
    q: str | None = None
    tag: list[str] | None = None
    max_prep_time: int | None = None
    max_cook_time: int | None = None
    limit: int = 20
    cursor: str | None = None


class RecipesRepository(Protocol):
    def list_recipes(self, query: RecipeQuery) -> RecipesListResponse: ...

    def get_recipe(self, recipe_id: UUID) -> RecipeDetailResponse | None: ...

    def get_filters(self) -> FiltersResponse: ...


class InMemoryRecipesRepository:
    def __init__(self) -> None:
        first_id = uuid4()
        second_id = uuid4()
        self._recipes: list[RecipeDetailResponse] = [
            RecipeDetailResponse(
                id=first_id,
                title="Shakshuka",
                description="Poached eggs in tomato sauce",
                servings=2,
                prepTimeMinutes=10,
                cookTimeMinutes=25,
                sourceUrl="https://example.com/shakshuka",
                ingredients=[
                    IngredientItem(id=uuid4(), name="Tomato", quantity=400, unit="g", note=None, position=1),
                    IngredientItem(id=uuid4(), name="Egg", quantity=2, unit="pcs", note=None, position=2),
                ],
                steps=[
                    StepItem(stepNumber=1, instruction="Cook tomato sauce."),
                    StepItem(stepNumber=2, instruction="Poach eggs in sauce."),
                ],
                nutrition=NutritionSummary(kcalTotal=460, proteinGTotal=24, kcalPerServing=230, proteinGPerServing=12),
                tags=["vegetarian", "high-protein"],
            ),
            RecipeDetailResponse(
                id=second_id,
                title="Grilled Chicken Salad",
                description="Fresh greens with chicken breast",
                servings=2,
                prepTimeMinutes=15,
                cookTimeMinutes=15,
                sourceUrl="https://example.com/chicken-salad",
                ingredients=[
                    IngredientItem(id=uuid4(), name="Chicken breast", quantity=300, unit="g", note=None, position=1),
                    IngredientItem(id=uuid4(), name="Mixed greens", quantity=150, unit="g", note=None, position=2),
                ],
                steps=[
                    StepItem(stepNumber=1, instruction="Grill the chicken."),
                    StepItem(stepNumber=2, instruction="Slice and mix with greens."),
                ],
                nutrition=NutritionSummary(kcalTotal=520, proteinGTotal=58, kcalPerServing=260, proteinGPerServing=29),
                tags=["high-protein", "gluten-free"],
            ),
        ]

    def list_recipes(self, query: RecipeQuery) -> RecipesListResponse:
        results = self._recipes
        if query.q:
            q = query.q.lower()
            results = [r for r in results if q in r.title.lower() or (r.description and q in r.description.lower())]
        if query.tag:
            selected = {t.lower() for t in query.tag}
            results = [r for r in results if selected.intersection({t.lower() for t in r.tags})]
        if query.max_prep_time is not None:
            results = [r for r in results if r.prepTimeMinutes is None or r.prepTimeMinutes <= query.max_prep_time]
        if query.max_cook_time is not None:
            results = [r for r in results if r.cookTimeMinutes is None or r.cookTimeMinutes <= query.max_cook_time]

        start = self._decode_cursor(query.cursor)
        end = start + query.limit
        page = results[start:end]
        next_cursor = self._encode_cursor(end) if end < len(results) else None
        items = [
            RecipeCard(
                id=r.id,
                title=r.title,
                description=r.description,
                servings=r.servings,
                prepTimeMinutes=r.prepTimeMinutes,
                cookTimeMinutes=r.cookTimeMinutes,
                tags=r.tags,
            )
            for r in page
        ]
        return RecipesListResponse(items=items, nextCursor=next_cursor, totalApprox=len(results))

    def get_recipe(self, recipe_id: UUID) -> RecipeDetailResponse | None:
        return next((r for r in self._recipes if r.id == recipe_id), None)

    def get_filters(self) -> FiltersResponse:
        tags = sorted({tag for recipe in self._recipes for tag in recipe.tags})
        prep = sorted({r.prepTimeMinutes for r in self._recipes if r.prepTimeMinutes is not None})
        cook = sorted({r.cookTimeMinutes for r in self._recipes if r.cookTimeMinutes is not None})
        return FiltersResponse(tags=tags, maxPrepTimeOptions=prep, maxCookTimeOptions=cook)

    @staticmethod
    def _encode_cursor(index: int) -> str:
        return base64.urlsafe_b64encode(str(index).encode()).decode()

    @staticmethod
    def _decode_cursor(cursor: str | None) -> int:
        if not cursor:
            return 0
        try:
            return int(base64.urlsafe_b64decode(cursor.encode()).decode())
        except Exception:
            return 0
