# API Component Requirements (Read-First MVP)

This document defines the implementation requirements for the API component, assuming the PostgreSQL/Supabase database is preloaded with recipes.

## 1) Scope

### In scope
- Read-only endpoints for recipe browsing.
- Search/filter/pagination contracts for list view.
- Detail contract including ingredients, steps, and nutrition summary.
- Validation, error handling, performance, and observability requirements.

### Out of scope
- Any write endpoint (`POST`, `PUT`, `PATCH`, `DELETE`) for recipe data.
- User-generated interactions (ratings/comments) in MVP phase.

---

## 2) Component boundaries

- Component name: `api` (BFF layer between frontend and database).
- Base path: `/api/v1`.
- Protocol: HTTPS JSON.
- Dependency: PostgreSQL/Supabase with read-only DB role.
- Responsibility: transform DB rows into stable API contracts for UI consumption.

---

## 3) Functional requirements

## 3.1 `GET /api/v1/recipes`

**Purpose**: List/search recipes for browse screen.

**Query parameters**
- `q` (optional, string, max 120)
- `tag` (optional, repeatable string)
- `maxPrepTime` (optional, integer, >= 0)
- `maxCookTime` (optional, integer, >= 0)
- `limit` (optional, integer, default 20, min 1, max 50)
- `cursor` (optional, opaque string)

**Success response (200)**
- `items[]`
  - `id` (uuid)
  - `title` (string)
  - `description` (string | null)
  - `servings` (number | null)
  - `prepTimeMinutes` (number | null)
  - `cookTimeMinutes` (number | null)
  - `tags` (string[])
- `nextCursor` (string | null)
- `totalApprox` (integer | null, optional)

## 3.2 `GET /api/v1/recipes/:id`

**Purpose**: Retrieve full recipe details.

**Path parameter**
- `id` (required, uuid)

**Success response (200)**
- `id`, `title`, `description`, `servings`, `prepTimeMinutes`, `cookTimeMinutes`, `sourceUrl`
- `ingredients[]` (ordered by `position`)
  - `id`, `name`, `quantity`, `unit`, `note`, `position`
- `steps[]` (ordered by `stepNumber`)
  - `stepNumber`, `instruction`
- `nutrition`
  - `kcalTotal`, `proteinGTotal`, `kcalPerServing`, `proteinGPerServing`
- `tags` (string[])

**Not found response (404)**
- `code`: `recipe_not_found`
- `message`: human-readable description
- `traceId`: request identifier

## 3.3 `GET /api/v1/filters`

**Purpose**: Return filter values for frontend facets.

**Success response (200)**
- `tags` (string[], sorted ascending)
- `maxPrepTimeOptions` (number[])
- `maxCookTimeOptions` (number[])

## 3.4 `GET /api/v1/health`

**Purpose**: Health probe endpoint.

**Success response (200)**
- `status`: `ok`
- `version`: build/service version string

---

## 4) Non-functional requirements

## 4.1 Validation
- Validate query and path parameters at controller boundary.
- Reject invalid input with `400` and stable machine-readable error code.

## 4.2 Error contract
- Standard error body:

```json
{
  "code": "validation_error",
  "message": "limit must be <= 50",
  "traceId": "req_abc123"
}
```

- `500` errors must not leak stack traces or SQL internals.

## 4.3 Security
- API must run with read-only DB credentials in MVP.
- Apply input sanitization for all user-provided query params.
- Apply rate limiting on public list/detail endpoints.

## 4.4 Performance
- `GET /recipes`: p95 < 400 ms for cached requests.
- `GET /recipes/:id`: p95 < 250 ms for cached requests.
- Allow cache staleness up to 5 minutes for browse flows.

## 4.5 Observability
- Structured logs with request path, status, duration, trace ID.
- Metrics: request count, latency (p50/p95), and error rate per endpoint.

---

## 5) Acceptance criteria

- API serves recipe list/detail from preloaded DB in read-only mode.
- Search/filter/pagination work according to endpoint contracts.
- 404 and validation errors follow stable error schema.
- Endpoint latency and logging/metrics requirements are met.
