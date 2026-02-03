-- 0002_indexes.sql

BEGIN;

-- recipes
CREATE INDEX idx_recipes_user_id ON recipes(user_id);
CREATE INDEX idx_recipes_user_title ON recipes(user_id, title);

-- ingredients
CREATE INDEX idx_ingredients_name ON ingredients(name);

-- recipe ingredients
CREATE INDEX idx_recipe_ingredients_recipe_id ON recipe_ingredients(recipe_id);
CREATE INDEX idx_recipe_ingredients_ingredient_id ON recipe_ingredients(ingredient_id);
CREATE INDEX idx_recipe_ingredients_recipe_pos ON recipe_ingredients(recipe_id, position);

CREATE UNIQUE INDEX uq_recipe_ingredient_once
ON recipe_ingredients (
  recipe_id,
  ingredient_id,
  COALESCE(unit, ''),
  COALESCE(note, '')
);

-- recipe imports
CREATE INDEX idx_recipe_imports_user_id ON recipe_imports(user_id);
CREATE INDEX idx_recipe_imports_recipe_id ON recipe_imports(recipe_id);

-- recipe steps
CREATE INDEX idx_recipe_steps_recipe_id ON recipe_steps(recipe_id);

COMMIT;
