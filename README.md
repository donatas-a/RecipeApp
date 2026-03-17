# RecipeApp

Find your meal.

## Documentation

- `README.md` (this file): high-level project notes.
- `ARCHITECTURE.md`: backend + frontend architecture based on a preloaded database.
- `API_REQUIREMENTS.md`: implementation requirements for the API component.
- `FRONTEND_REQUIREMENTS.md`: implementation requirements and acceptance criteria for the frontend component.
- `supabase/README.md`: database and migration notes.

## Current direction

Because the database is already preloaded, the project should start with a **read-first MVP**:

1. `GET /recipes` (search + pagination)
2. `GET /recipes/:id` (ingredients + steps + nutrition)
3. Frontend list/detail flows
4. Write actions disabled for phase 1

For system structure and module boundaries, see `ARCHITECTURE.md`. For delivery requirements, use `API_REQUIREMENTS.md` (API) and `FRONTEND_REQUIREMENTS.md` (frontend).


## API implementation

A FastAPI-based API component is available under `backend/`.

- App entrypoint: `backend/app/main.py`
- Routes: `/api/v1/recipes`, `/api/v1/recipes/{id}`, `/api/v1/filters`, `/api/v1/health`
- Setup/run instructions: `backend/README.md`

