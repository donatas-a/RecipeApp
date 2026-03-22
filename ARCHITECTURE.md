# Backend + Frontend Architecture (Preloaded Database)

This document defines a pragmatic architecture for building the app on top of the existing preloaded recipe database.

## Goals

- Ship a stable **read-first** product quickly (browse and recipe detail).
- Keep domain/business logic centralized in backend services.
- Keep frontend focused on UI state, routing, and rendering.
- Preserve flexibility to enable writes (favorites, custom recipes, ratings) later.


## Relationship to requirements

- `ARCHITECTURE.md` defines **how the system is structured**.
- `API_REQUIREMENTS.md` defines **API component delivery requirements**.
- `FRONTEND_REQUIREMENTS.md` defines **frontend component delivery requirements**.

---

## 1) High-level architecture

```text
Frontend (Web SPA/SSR)
    |
    | HTTPS (JSON)
    v
Backend API (BFF)
    |
    | SQL/RPC
    v
PostgreSQL/Supabase (preloaded recipes)
```

### Why this shape

- A **BFF (Backend for Frontend)** isolates UI from raw DB schema changes.
- Backend can enforce contracts, pagination, filtering, caching, and auth checks.
- Frontend consumes a stable API tailored to screens, not tables.

---

## 2) Backend structure

Use feature-based modules with clean layering.

```text
backend/
  src/
    app/                     # app bootstrap, DI/config wiring
    modules/
      recipes/
        recipes.controller   # HTTP handlers / route mapping
        recipes.service      # business use-cases
        recipes.repo         # SQL / DB access
        recipes.dto          # request/response contracts
        recipes.mapper       # DB row -> API model
      ingredients/
      nutrition/
      search/
      health/
    shared/
      db/                    # DB client + query helpers
      cache/                 # redis/in-memory cache wrappers
      auth/                  # auth middleware / guards
      errors/                # domain + HTTP error mapping
      observability/         # logging, metrics, tracing
    tests/
      integration/
      contract/
```

### Layer responsibilities

- **Controller**: parse request, validate params, call service, serialize response.
- **Service**: orchestrate use-cases, combine repos, apply domain rules.
- **Repo**: only DB access (SQL/RPC), no HTTP/UI logic.
- **DTO/Mapper**: explicit contract; avoid leaking raw table columns.

### Core read APIs (phase 1)

- `GET /api/v1/recipes`
  - query: `q`, `cuisine`, `maxTime`, `difficulty`, `limit`, `cursor`
- `GET /api/v1/recipes/:id`
  - full recipe details (ingredients, steps, nutrition summary)
- `GET /api/v1/filters`
  - dynamic filter values for UI facets
- `GET /api/v1/health`

### Backend cross-cutting decisions

- **Pagination**: cursor-based for scalable listing.
- **Validation**: request schema validation at boundary.
- **Caching**:
  - list/search responses (short TTL)
  - recipe detail by id (medium TTL)
- **Observability**:
  - structured logs with request id
  - latency + error-rate metrics per endpoint
- **Security**:
  - read-only DB role for phase 1
  - input sanitization + rate limiting for public endpoints

---

## 3) Frontend structure

Use route-first + feature modules with a thin data layer.

```text
frontend/
  src/
    app/
      router/                # route definitions
      providers/             # query client, theme, i18n
      layouts/
    pages/
      recipes-list/
      recipe-detail/
    features/
      recipes/
        components/
        hooks/               # useRecipes, useRecipeDetail
        api/                 # typed API client functions
        model/               # ui view models + transformers
        state/               # local feature state if needed
      filters/
      search/
    shared/
      ui/                    # reusable presentational components
      lib/                   # utility functions
      config/                # env, constants
      types/                 # common TS types
```

### Frontend data approach

- Use a query library (e.g., TanStack Query) for server-state.
- Keep server data in query cache; avoid duplicating it in global state.
- Keep global state only for UI concerns (theme, layout, ephemeral filters).

### Screen contracts

- **Recipes List**
  - consumes `/recipes` + `/filters`
  - supports search, faceted filters, infinite/cursor pagination
- **Recipe Detail**
  - consumes `/recipes/:id`
  - displays ingredient table, steps, nutrition block

### UI patterns

- Skeleton loading states for list + detail.
- Error boundaries with retry actions.
- URL-driven filters (`?q=&cuisine=&...`) for shareable searches.

---

## 4) Shared API contract strategy

- Version endpoints: `/api/v1`.
- Keep OpenAPI spec in repo (`/contracts/openapi.yaml`).
- Generate TypeScript client types from OpenAPI.
- Treat API responses as view-friendly objects (flatten and pre-shape where useful).

Example list response shape:

```json
{
  "items": [
    {
      "id": "uuid",
      "title": "Shakshuka",
      "imageUrl": "https://...",
      "cookTimeMinutes": 35,
      "difficulty": "easy",
      "tags": ["vegetarian", "high-protein"]
    }
  ],
  "nextCursor": "opaque_cursor"
}
```

---

## 5) Rollout plan

1. **Phase 1 (Read-only MVP)**
   - Implement list/detail/filter endpoints.
   - Build recipes list + detail screens.
   - Add telemetry and basic caching.
2. **Phase 2 (Personalization)**
   - Auth, saved recipes, recently viewed.
3. **Phase 3 (Writes + curation)**
   - User-submitted recipes, ratings, moderation workflows.

---

## 6) Definition of done for phase 1

- P95 API latency targets met for list/detail endpoints.
- API and frontend contracts typed and validated.
- List/detail pages pass accessibility baseline checks.
- Logs and metrics available for each request path.
- Read-only permissions enforced at DB and backend levels.
