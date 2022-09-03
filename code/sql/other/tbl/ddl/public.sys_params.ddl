/* Table public.sys_params */
DROP TABLE IF EXISTS public.sys_params CASCADE;
-- Table public.sys_params
CREATE TABLE public.sys_params
(
  fir_id integer NOT NULL,
  fir_naziv character varying(30),
  fir_mesto character varying(20),
  fir_adresa character varying(60),
  fir_tel1 character varying(20),
  fir_tel2 character varying(20),
  fir_mail character varying(30),
  fir_web character varying(30),
  fir_logo character varying(100),
  fir_pib character varying(20),
  fir_mbr character varying(20),
  fir_banka character varying(60),
  fir_ziro_rac character varying(20),
  sr_cir character(1) DEFAULT 'N' CHECK (sr_cir IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

-- Comments on table public.sys_params
COMMENT ON TABLE public.sys_params IS 'Sistemski parametri';
COMMENT ON COLUMN public.sys_params.fir_id IS 'ID firme';
COMMENT ON COLUMN public.sys_params.fir_naziv IS 'Naziv firme';
COMMENT ON COLUMN public.sys_params.fir_mesto IS 'Mesto sedišta firme';
COMMENT ON COLUMN public.sys_params.fir_adresa IS 'Adresa sedišta firme';
COMMENT ON COLUMN public.sys_params.fir_tel1 IS 'Telefon firme 1';
COMMENT ON COLUMN public.sys_params.fir_tel2 IS 'Telefon firme 1';
COMMENT ON COLUMN public.sys_params.fir_mail IS 'E-mail firme';
COMMENT ON COLUMN public.sys_params.fir_web IS 'Web stranica firme';
COMMENT ON COLUMN public.sys_params.fir_logo IS 'Logo firme';
COMMENT ON COLUMN public.sys_params.fir_pib IS 'PIB firme';
COMMENT ON COLUMN public.sys_params.fir_mbr IS 'Matični broj firme';
COMMENT ON COLUMN public.sys_params.fir_banka IS 'Banka firme';
COMMENT ON COLUMN public.sys_params.fir_ziro_rac IS 'Žiro račun firme';
COMMENT ON COLUMN public.sys_params.sr_cir IS 'Ćirilica?';

-- Primary key on table public.sys_params
ALTER TABLE public.sys_params ADD CONSTRAINT sysp_pk PRIMARY KEY (fir_id);

COMMIT;
