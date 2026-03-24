# Database

PostgreSQL schema for Recipe App.

## Structure
- migrations/ – ordered, immutable schema changes
- schema/     – schema snapshot (optional)

## Key design decisions
- UUID primary keys
- Ingredient nutrition stored per 100g
- Recipe nutrition is derived, not authoritative
- Raw imports preserved for re-parsing

## Apply migrations locally
psql $DATABASE_URL -f db/migrations/0001_init.sql

## GitHub Actions migrations

The CI workflow reads `SUPABASE_DB_URL` from a GitHub Actions secret and runs:

```bash
supabase db push --db-url "$SUPABASE_DB_URL"
```

This workflow is intentionally DB-URL based: it does **not** call `supabase login` or `supabase link`. Using access-token/project-ref login flows in GitHub Actions can fail with `Unauthorized` if the token is not authorized for the target project.

When configuring that secret for GitHub-hosted runners, use the **Supavisor pooler** connection string from the Supabase dashboard rather than the direct database host (`db.<project-ref>.supabase.co:5432`). The direct host often resolves to IPv6 and can fail from GitHub Actions with `network is unreachable`.
