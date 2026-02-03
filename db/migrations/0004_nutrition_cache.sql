-- 0004_nutrition_cache.sql

BEGIN;

CREATE TABLE recipe_nutrition_cache (
  recipe_id              uuid PRIMARY KEY REFERENCES recipes(id) ON DELETE CASCADE,
  kcal_total             numeric(12,2),
  protein_g_total        numeric(12,2),
  kcal_per_serving       numeric(12,2),
  protein_g_per_serving  numeric(12,2),
  calculated_at          timestamptz NOT NULL DEFAULT now()
);

COMMIT;
