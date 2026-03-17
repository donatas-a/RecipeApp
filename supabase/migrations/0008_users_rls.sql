BEGIN;

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users FORCE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "service role manages users" ON public.users;
CREATE POLICY "service role manages users"
ON public.users
FOR ALL
USING (auth.role() = 'service_role')
WITH CHECK (auth.role() = 'service_role');

DROP POLICY IF EXISTS "admin can read users" ON public.users;
CREATE POLICY "admin can read users"
ON public.users
FOR SELECT
USING ((auth.jwt() ->> 'email') = 'admin');

COMMIT;
