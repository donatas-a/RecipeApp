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
