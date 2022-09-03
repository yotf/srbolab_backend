/* Table public.tuv_imp_sert */
DROP TABLE IF EXISTS public.tuv_imp_sert CASCADE;
-- Table public.tuv_imp_sert
CREATE TABLE public.tuv_imp_sert
(
  tis_part character(1) NOT NULL,
  tis_order integer NOT NULL,
  tis_lbl_coc character varying(10),
  tis_lbl_drvlc character varying(50),
  tis_desc_sr character varying(200) NOT NULL,
  tis_desc_en character varying(200) NOT NULL,
  tis_unit character varying(10),
  tis_column character varying(50)
) WITH (autovacuum_enabled=true);

-- Comments on table public.tuv_imp_sert
COMMENT ON TABLE public.tuv_imp_sert IS 'TUV import sertifikat';
COMMENT ON COLUMN public.tuv_imp_sert.tis_part IS 'Pripadnost reda';
COMMENT ON COLUMN public.tuv_imp_sert.tis_order IS 'Redni broj reda';
COMMENT ON COLUMN public.tuv_imp_sert.tis_lbl_coc IS 'COC';
COMMENT ON COLUMN public.tuv_imp_sert.tis_lbl_drvlc IS 'Vozačka dozvola';
COMMENT ON COLUMN public.tuv_imp_sert.tis_desc_sr IS 'Opis srpski';
COMMENT ON COLUMN public.tuv_imp_sert.tis_desc_en IS 'Opis engleski';
COMMENT ON COLUMN public.tuv_imp_sert.tis_unit IS 'Jedinica mere';
COMMENT ON COLUMN public.tuv_imp_sert.tis_column IS 'Kolona iz predmeta';

-- Primary key on table public.tuv_imp_sert
ALTER TABLE public.tuv_imp_sert ADD CONSTRAINT tis_pk PRIMARY KEY (tis_order, tis_part);

COMMIT;
