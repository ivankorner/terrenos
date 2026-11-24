-- Public catalog of land parcels shown on the landing page.
-- Only project admins (CLI / dashboard) may write; visitors can read all lots,
-- including sold ones, so the page can show their status.
CREATE TABLE public.lots (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  precio INTEGER,
  estado TEXT NOT NULL DEFAULT 'disponible' CHECK (estado IN ('disponible', 'vendido')),
  medidas TEXT NOT NULL,
  tamano_m2 INTEGER NOT NULL,
  tag TEXT,
  image_url TEXT,
  image_key TEXT,
  geometry JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX lots_estado_idx ON public.lots (estado);

CREATE TRIGGER lots_updated_at
  BEFORE UPDATE ON public.lots
  FOR EACH ROW EXECUTE FUNCTION system.update_updated_at();

ALTER TABLE public.lots ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anyone can read lots" ON public.lots
  FOR SELECT TO anon, authenticated
  USING (true);

GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT ON public.lots TO anon, authenticated;
-- Visitor roles must never be able to change prices or availability.
REVOKE INSERT, UPDATE, DELETE ON public.lots FROM anon, authenticated;
