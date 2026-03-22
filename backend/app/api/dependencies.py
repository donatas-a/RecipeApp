from functools import lru_cache

from app.repositories.recipes import InMemoryRecipesRepository
from app.services.recipes_service import RecipesService


@lru_cache(maxsize=1)
def get_recipes_service() -> RecipesService:
    return RecipesService(repo=InMemoryRecipesRepository())
