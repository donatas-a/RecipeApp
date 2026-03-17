# Frontend Component Requirements (Read-First MVP)

This document defines implementation requirements for the **frontend component**. API-specific requirements are documented in `API_REQUIREMENTS.md`.

## 1) Component overview

- Component name: `frontend`.
- Primary responsibility: provide recipe browse + recipe detail user experience.
- Upstream dependency: `/api/v1` contracts defined in `API_REQUIREMENTS.md`.
- MVP mode: read-only (no create/edit/delete user flows).

---

## 2) Scope

### In scope
- Recipe list/search/filter page.
- Recipe detail page.
- URL-driven state for shareable search/filter links.
- Robust handling of loading, empty, not-found, and error states.

### Out of scope
- Recipe creation and editing interfaces.
- Ratings, comments, and moderation UI.
- Multi-user dashboards and admin controls.

---

## 3) Functional requirements

## 3.1 Routing
- Route: `/recipes`
  - Supports query params: `q`, `tag`, `maxPrepTime`, `maxCookTime`, `cursor`.
- Route: `/recipes/:id`
  - Displays complete recipe information from API payload.
- Unknown routes should render standard application 404 page.

## 3.2 Recipes list page behavior
- Render recipe cards using `GET /api/v1/recipes`.
- Provide search input tied to `q` query parameter.
- Provide filter controls for `tag`, `maxPrepTime`, and `maxCookTime`.
- Support cursor pagination using `nextCursor`.
- Reset cursor when non-pagination filters change.
- Persist state in URL so page refresh preserves results.

## 3.3 Recipe detail page behavior
- Fetch detail using `GET /api/v1/recipes/:id`.
- Display recipe metadata:
  - title
  - description
  - servings
  - prep time and cook time
- Display ordered ingredient list and ordered preparation steps.
- Display nutrition summary block when nutrition data is present.
- Provide a back action that returns user to previous list state.

## 3.4 Filters metadata usage
- Fetch filter options from `GET /api/v1/filters`.
- Render filter options in deterministic sorted order.
- Handle missing/empty filter option payload gracefully.

---

## 4) UI and UX requirements

## 4.1 Required screen states
- **Loading**: skeleton placeholders for list and detail pages.
- **Empty**: clear no-results message on list page.
- **Error**: retryable error panel for failed API requests.
- **Not found**: dedicated recipe-not-found state for 404 details.

## 4.2 Interaction quality
- Search/filter changes should trigger predictable, debounced requests.
- Pagination interactions must prevent duplicate in-flight requests.
- User actions should have visible feedback (loading indicators/disabled controls).

## 4.3 Design consistency
- Reuse shared UI primitives for cards, badges, lists, and alerts.
- Maintain consistent spacing/typography between list and detail pages.

---

## 5) Data and state requirements

## 5.1 Server-state management
- Use a server-state library (e.g., TanStack Query).
- Query keys must include all request inputs.
- Use cache invalidation/refetch patterns rather than manual global mutations.

## 5.2 Client-state management
- Keep global state minimal and UI-centric (theme, transient UI toggles).
- Do not duplicate API entity data in long-lived global state stores.

## 5.3 Type safety
- Frontend API response types must align with `API_REQUIREMENTS.md`.
- Avoid untyped `any` usage for endpoint payloads.

---

## 6) Accessibility requirements

- All interactive controls must be keyboard accessible.
- Inputs/selectors must have accessible labels.
- Each page must have a single logical `h1` heading.
- Focus order must remain logical when filters/results update.
- Color contrast for text and controls must meet WCAG AA.

---

## 7) Observability requirements

- Emit frontend telemetry for:
  - list page view
  - detail page view
  - search usage
  - filter usage
- Include backend `traceId` in client-side error logs when available.
- Log route + query context for reproducible frontend errors.

---

## 8) Acceptance criteria

- User can browse, search, filter, and paginate recipes from preloaded data.
- User can open recipe detail and view ingredients and steps in correct order.
- Frontend correctly handles loading, empty, error, and not-found scenarios.
- UI presents no active write flows in MVP.
- Frontend builds against typed API contracts with no untyped payload handling.
