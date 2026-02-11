-- 0006_translations.sql
-- Add localized translations for recipes, recipe steps, and ingredients

BEGIN;

CREATE TABLE recipe_translations (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id    uuid NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  locale       text NOT NULL,
  title        text NOT NULL,
  description  text,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_recipe_translations_recipe_locale UNIQUE (recipe_id, locale)
);

CREATE TABLE recipe_step_translations (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_step_id  uuid NOT NULL REFERENCES recipe_steps(id) ON DELETE CASCADE,
  locale          text NOT NULL,
  instruction     text NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_recipe_step_translations_step_locale UNIQUE (recipe_step_id, locale)
);

CREATE TABLE ingredient_translations (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  ingredient_id  uuid NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
  locale         text NOT NULL,
  name           text NOT NULL,
  created_at     timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_ingredient_translations_ingredient_locale UNIQUE (ingredient_id, locale)
);

CREATE INDEX idx_recipe_translations_recipe_id ON recipe_translations(recipe_id);
CREATE INDEX idx_recipe_translations_locale ON recipe_translations(locale);

CREATE INDEX idx_recipe_step_translations_step_id ON recipe_step_translations(recipe_step_id);
CREATE INDEX idx_recipe_step_translations_locale ON recipe_step_translations(locale);

CREATE INDEX idx_ingredient_translations_ingredient_id ON ingredient_translations(ingredient_id);
CREATE INDEX idx_ingredient_translations_locale ON ingredient_translations(locale);

COMMIT;
