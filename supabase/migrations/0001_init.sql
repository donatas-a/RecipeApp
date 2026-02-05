-- 0001_init.sql
-- Initial schema

BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =========================
-- USERS
-- =========================
CREATE TABLE users (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email         text NOT NULL UNIQUE,
  password_hash text NOT NULL,
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- =========================
-- RECIPES
-- =========================
CREATE TABLE recipes (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title             text NOT NULL,
  description       text,
  servings          numeric(6,2),
  prep_time_minutes integer,
  cook_time_minutes integer,
  source_url        text,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now()
);

-- =========================
-- INGREDIENTS
-- =========================
CREATE TABLE ingredients (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name               text NOT NULL,
  name_normalized    text NOT NULL,
  default_unit       text NOT NULL DEFAULT 'g',
  kcal_per_100g      numeric(10,2),
  protein_g_per_100g numeric(10,2),
  created_at         timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_ingredients_name_normalized UNIQUE (name_normalized)
);

-- =========================
-- RECIPE INGREDIENTS
-- =========================
CREATE TABLE recipe_ingredients (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id     uuid NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  ingredient_id uuid NOT NULL REFERENCES ingredients(id) ON DELETE RESTRICT,
  quantity      numeric(10,3),
  unit          text,
  note          text,
  position      integer NOT NULL DEFAULT 1,
  created_at    timestamptz NOT NULL DEFAULT now()
);

-- =========================
-- RECIPE STEPS
-- =========================
CREATE TABLE recipe_steps (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id    uuid NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  step_number  integer NOT NULL,
  instruction  text NOT NULL,
  created_at   timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_recipe_steps UNIQUE (recipe_id, step_number)
);

-- =========================
-- RAW IMPORTS
-- =========================
CREATE TABLE recipe_imports (
  id                 uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id            uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  recipe_id          uuid REFERENCES recipes(id) ON DELETE SET NULL,
  source_type        text NOT NULL,
  source_filename    text,
  source_sheet_name  text,
  raw_text           text NOT NULL,
  parser_version     text,
  parse_status       text NOT NULL DEFAULT 'pending',
  parse_errors       jsonb,
  created_at         timestamptz NOT NULL DEFAULT now()
);

-- =========================
-- TAGS
-- =========================
CREATE TABLE tags (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name       text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uq_tags_user_name UNIQUE (user_id, name)
);

CREATE TABLE recipe_tags (
  recipe_id  uuid NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  tag_id     uuid NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (recipe_id, tag_id)
);

COMMIT;
