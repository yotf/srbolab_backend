/* Table hmlg.predmet_status */
DROP TABLE IF EXISTS hmlg.predmet_status CASCADE;
-- Table hmlg.predmet_status
CREATE TABLE hmlg.predmet_status
(
  prs_id integer NOT NULL,
  prs_oznaka character varying(10) NOT NULL,
  prs_naziv character varying(50),
  prs_priprema character(1) DEFAULT 'D' CHECK (prs_priprema IN ('D', 'N')),
  prs_cekanje character(1) DEFAULT 'N' CHECK (prs_cekanje IN ('D', 'N')),
  prs_zakljucen character(1) DEFAULT 'N' CHECK (prs_zakljucen IN ('D', 'N')),
  prs_neusag character(1) DEFAULT 'N' CHECK (prs_neusag IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.predmet_status
COMMENT ON TABLE hmlg.predmet_status IS 'Status predmeta';
COMMENT ON COLUMN hmlg.predmet_status.prs_id IS 'ID statusa predmeta';
COMMENT ON COLUMN hmlg.predmet_status.prs_oznaka IS 'Oznaka statusa predmeta';
COMMENT ON COLUMN hmlg.predmet_status.prs_naziv IS 'Naziv statusa predmeta';
COMMENT ON COLUMN hmlg.predmet_status.prs_priprema IS 'Predmet je u pripremi?';
COMMENT ON COLUMN hmlg.predmet_status.prs_cekanje IS 'Predmet je na čekanju?';
COMMENT ON COLUMN hmlg.predmet_status.prs_zakljucen IS 'Predmet je zaključen?';
COMMENT ON COLUMN hmlg.predmet_status.prs_neusag IS 'Neusaglašenost?';

-- Primary key on table hmlg.predmet_status
ALTER TABLE hmlg.predmet_status ADD CONSTRAINT prs_pk PRIMARY KEY (prs_id);

-- Alternate keys on table hmlg.predmet_status
ALTER TABLE hmlg.predmet_status ADD CONSTRAINT prs_oznaka_uk UNIQUE (prs_oznaka);

COMMIT;
