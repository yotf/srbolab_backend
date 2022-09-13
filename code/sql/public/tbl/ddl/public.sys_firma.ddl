/* Table public.sys_firma */
DROP TABLE IF EXISTS public.sys_firma CASCADE;
-- Table public.sys_firma
CREATE TABLE public.sys_firma
(
  fir_id integer NOT NULL,
  fir_naziv character varying(50),
  fir_naziv_s character varying(50),
  fir_opis character varying(200),
  fir_opis_s character varying(200),
  fir_mesto_sediste character varying(50),
  fir_adresa_sediste character varying(100),
  fir_mesto character varying(50),
  fir_adresa character varying(100),
  fir_tel1 character varying(20),
  fir_tel2 character varying(20),
  fir_mail character varying(50),
  fir_web character varying(50),
  fir_logo character varying(100),
  fir_pib integer,
  fir_mbr integer,
  fir_banka character varying(60),
  fir_ziro_rac character varying(20),
  sr_cir character(1) DEFAULT 'N' CHECK (sr_cir IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

-- Comments on table public.sys_firma
COMMENT ON TABLE public.sys_firma IS 'Sistemski parametri';
COMMENT ON COLUMN public.sys_firma.fir_id IS 'ID firme';
COMMENT ON COLUMN public.sys_firma.fir_naziv IS 'Naziv firme';
COMMENT ON COLUMN public.sys_firma.fir_naziv_s IS 'Naziv firme (kratki)';
COMMENT ON COLUMN public.sys_firma.fir_opis IS 'Delatnost firme';
COMMENT ON COLUMN public.sys_firma.fir_opis_s IS 'Delatnost firme (kratka)';
COMMENT ON COLUMN public.sys_firma.fir_mesto_sediste IS 'Mesto sedišta firme';
COMMENT ON COLUMN public.sys_firma.fir_adresa_sediste IS 'Adresa sedišta firme';
COMMENT ON COLUMN public.sys_firma.fir_mesto IS 'Mesto sedišta firme';
COMMENT ON COLUMN public.sys_firma.fir_adresa IS 'Adresa sedišta firme';
COMMENT ON COLUMN public.sys_firma.fir_tel1 IS 'Telefon firme 1';
COMMENT ON COLUMN public.sys_firma.fir_tel2 IS 'Telefon firme 1';
COMMENT ON COLUMN public.sys_firma.fir_mail IS 'E-mail firme';
COMMENT ON COLUMN public.sys_firma.fir_web IS 'Web stranica firme';
COMMENT ON COLUMN public.sys_firma.fir_logo IS 'Logo firme';
COMMENT ON COLUMN public.sys_firma.fir_pib IS 'PIB firme';
COMMENT ON COLUMN public.sys_firma.fir_mbr IS 'Matični broj firme';
COMMENT ON COLUMN public.sys_firma.fir_banka IS 'Banka firme';
COMMENT ON COLUMN public.sys_firma.fir_ziro_rac IS 'Žiro račun firme';
COMMENT ON COLUMN public.sys_firma.sr_cir IS 'Ćirilica?';

-- Primary key on table public.sys_firma
ALTER TABLE public.sys_firma ADD CONSTRAINT sysp_pk PRIMARY KEY (fir_id);

COMMIT;
