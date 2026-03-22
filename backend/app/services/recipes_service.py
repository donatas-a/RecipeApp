from __future__ import annotations

from uuid import UUID

from app.core.errors import NotFoundException
from app.repositories.recipes import RecipeQuery, RecipesRepository


class RecipesService:
    def __init__(self, repo: RecipesRepository) -> None:
        self.repo = repo

    def list_recipes(self, query: RecipeQuery):
        return self.repo.list_recipes(query)

    def get_recipe(self, recipe_id: UUID):
        recipe = self.repo.get_recipe(recipe_id)
        if recipe is None:
            raise NotFoundException()
        return recipe

    def get_filters(self):
        return self.repo.get_filters()
