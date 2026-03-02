BEGIN;
ALTER TABLE public.recipes                  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipe_translations      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipe_ingredients       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipe_steps             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipe_step_translations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipe_nutrition_cache   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipe_tags              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tags                     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recipe_imports           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ingredients              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ingredient_translations  ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "read all recipes" ON public.recipes;
CREATE POLICY "read all recipes"
ON public.recipes
FOR SELECT
USING ((auth.jwt() ->> 'email') IN ('admin', 'user'));
DROP POLICY IF EXISTS "insert single owner recipes" ON public.recipes;
CREATE POLICY "insert single owner recipes"
ON public.recipes
FOR INSERT
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
);
DROP POLICY IF EXISTS "update single owner recipes" ON public.recipes;
CREATE POLICY "update single owner recipes"
ON public.recipes
FOR UPDATE
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
)
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
);
DROP POLICY IF EXISTS "delete single owner recipes" ON public.recipes;
CREATE POLICY "delete single owner recipes"
ON public.recipes
FOR DELETE
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
);
DROP POLICY IF EXISTS "read recipe_translations" ON public.recipe_translations;
CREATE POLICY "read recipe_translations"
ON public.recipe_translations
FOR SELECT
USING (
  (auth.jwt() ->> 'email') IN ('admin', 'user')
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_translations.recipe_id
  )
);
DROP POLICY IF EXISTS "modify translations for single owner recipes" ON public.recipe_translations;
CREATE POLICY "modify translations for single owner recipes"
ON public.recipe_translations
FOR ALL
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_translations.recipe_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
)
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_translations.recipe_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
);
DROP POLICY IF EXISTS "read recipe_ingredients" ON public.recipe_ingredients;
CREATE POLICY "read recipe_ingredients"
ON public.recipe_ingredients
FOR SELECT
USING (
  (auth.jwt() ->> 'email') IN ('admin', 'user')
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_ingredients.recipe_id
  )
);
DROP POLICY IF EXISTS "modify ingredients for single owner recipes" ON public.recipe_ingredients;
CREATE POLICY "modify ingredients for single owner recipes"
ON public.recipe_ingredients
FOR ALL
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_ingredients.recipe_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
)
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_ingredients.recipe_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
);
DROP POLICY IF EXISTS "read recipe_steps" ON public.recipe_steps;
CREATE POLICY "read recipe_steps"
ON public.recipe_steps
FOR SELECT
USING (
  (auth.jwt() ->> 'email') IN ('admin', 'user')
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_steps.recipe_id
  )
);
DROP POLICY IF EXISTS "modify steps for single owner recipes" ON public.recipe_steps;
CREATE POLICY "modify steps for single owner recipes"
ON public.recipe_steps
FOR ALL
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_steps.recipe_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
)
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_steps.recipe_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
);
DROP POLICY IF EXISTS "read recipe_step_translations" ON public.recipe_step_translations;
CREATE POLICY "read recipe_step_translations"
ON public.recipe_step_translations
FOR SELECT
USING (
  (auth.jwt() ->> 'email') IN ('admin', 'user')
  AND EXISTS (
    SELECT 1
    FROM public.recipe_steps s
    JOIN public.recipes r ON r.id = s.recipe_id
    WHERE s.id = recipe_step_translations.recipe_step_id
  )
);
DROP POLICY IF EXISTS "modify step translations for single owner recipes" ON public.recipe_step_translations;
CREATE POLICY "modify step translations for single owner recipes"
ON public.recipe_step_translations
FOR ALL
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1
    FROM public.recipe_steps s
    JOIN public.recipes r ON r.id = s.recipe_id
    WHERE s.id = recipe_step_translations.recipe_step_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
)
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1
    FROM public.recipe_steps s
    JOIN public.recipes r ON r.id = s.recipe_id
    WHERE s.id = recipe_step_translations.recipe_step_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
);
DROP POLICY IF EXISTS "read nutrition_cache" ON public.recipe_nutrition_cache;
CREATE POLICY "read nutrition_cache"
ON public.recipe_nutrition_cache
FOR SELECT
USING (
  (auth.jwt() ->> 'email') IN ('admin', 'user')
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_nutrition_cache.recipe_id
  )
);
DROP POLICY IF EXISTS "modify nutrition_cache for single owner recipes" ON public.recipe_nutrition_cache;
CREATE POLICY "modify nutrition_cache for single owner recipes"
ON public.recipe_nutrition_cache
FOR ALL
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_nutrition_cache.recipe_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
)
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_nutrition_cache.recipe_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
);
DROP POLICY IF EXISTS "read recipe_tags" ON public.recipe_tags;
CREATE POLICY "read recipe_tags"
ON public.recipe_tags
FOR SELECT
USING (
  (auth.jwt() ->> 'email') IN ('admin', 'user')
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_tags.recipe_id
  )
);
DROP POLICY IF EXISTS "modify recipe_tags for single owner recipes" ON public.recipe_tags;
CREATE POLICY "modify recipe_tags for single owner recipes"
ON public.recipe_tags
FOR ALL
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_tags.recipe_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
)
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND EXISTS (
    SELECT 1 FROM public.recipes r
    WHERE r.id = recipe_tags.recipe_id
      AND r.user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
  )
);
DROP POLICY IF EXISTS "read all tags" ON public.tags;
CREATE POLICY "read all tags"
ON public.tags
FOR SELECT
USING ((auth.jwt() ->> 'email') IN ('admin', 'user'));
DROP POLICY IF EXISTS "insert single owner tag" ON public.tags;
CREATE POLICY "insert single owner tag"
ON public.tags
FOR INSERT
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
);
DROP POLICY IF EXISTS "update single owner tag" ON public.tags;
CREATE POLICY "update single owner tag"
ON public.tags
FOR UPDATE
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
)
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
);
DROP POLICY IF EXISTS "delete single owner tag" ON public.tags;
CREATE POLICY "delete single owner tag"
ON public.tags
FOR DELETE
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
);
DROP POLICY IF EXISTS "read single owner recipe_imports" ON public.recipe_imports;
CREATE POLICY "read single owner recipe_imports"
ON public.recipe_imports
FOR SELECT
USING ((auth.jwt() ->> 'email') IN ('admin', 'user'));
DROP POLICY IF EXISTS "insert single owner recipe_imports" ON public.recipe_imports;
CREATE POLICY "insert single owner recipe_imports"
ON public.recipe_imports
FOR INSERT
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
);
DROP POLICY IF EXISTS "update single owner recipe_imports" ON public.recipe_imports;
CREATE POLICY "update single owner recipe_imports"
ON public.recipe_imports
FOR UPDATE
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
)
WITH CHECK (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
);
DROP POLICY IF EXISTS "delete single owner recipe_imports" ON public.recipe_imports;
CREATE POLICY "delete single owner recipe_imports"
ON public.recipe_imports
FOR DELETE
USING (
  (auth.jwt() ->> 'email') = 'admin'
  AND user_id = (SELECT id FROM public.users WHERE email = 'admin' ORDER BY created_at NULLS LAST, id LIMIT 1)
);
DROP POLICY IF EXISTS "read all ingredients" ON public.ingredients;
CREATE POLICY "read all ingredients"
ON public.ingredients
FOR SELECT
USING ((auth.jwt() ->> 'email') IN ('admin', 'user'));
DROP POLICY IF EXISTS "read all ingredient_translations" ON public.ingredient_translations;
CREATE POLICY "read all ingredient_translations"
ON public.ingredient_translations
FOR SELECT
USING ((auth.jwt() ->> 'email') IN ('admin', 'user'));
COMMIT;
