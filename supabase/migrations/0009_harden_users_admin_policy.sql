BEGIN;

DROP POLICY IF EXISTS "admin can read users" ON public.users;
CREATE POLICY "app admin can read users"
ON public.users
FOR SELECT
USING (
  auth.role() = 'authenticated'
  AND (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin'
);

COMMIT;
