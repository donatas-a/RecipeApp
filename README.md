# RecipeApp

Find your meal.

## What to do with the Markdown files?

They are documentation only (no runtime effect):

- `README.md` (this file): high-level project notes.
- `supabase/README.md`: database/migration notes.

If you only care about running the app, you can ignore these files.
If docs are unwanted, they can be deleted safely.

## If your DB already has recipes

Build a small read-only browse flow:

1. Add `GET /recipes` (search + pagination).
2. Add `GET /recipes/:id` (ingredients + steps).
3. Render list/detail pages in your frontend.
4. Keep write actions disabled.
