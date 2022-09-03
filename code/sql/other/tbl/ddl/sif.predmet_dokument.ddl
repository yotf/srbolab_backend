/* Table sif.predmet_dokument */
DROP TABLE IF EXISTS sif.predmet_dokument CASCADE;
-- Table sif.predmet_dokument
CREATE TABLE sif.predmet_dokument
(
  prd_id integer NOT NULL,
  prd_oznaka character varying(10) NOT NULL,
  prd_naziv character varying(50) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.predmet_dokument
COMMENT ON TABLE sif.predmet_dokument IS 'Dokumenta za predmet';
COMMENT ON COLUMN sif.predmet_dokument.prd_id IS 'ID dokumenta za predmet';
COMMENT ON COLUMN sif.predmet_dokument.prd_oznaka IS 'Oznaka dokumenta za predmet';
COMMENT ON COLUMN sif.predmet_dokument.prd_naziv IS 'Naziv dokumenta za predmet';

-- Primary key on table sif.predmet_dokument
ALTER TABLE sif.predmet_dokument ADD CONSTRAINT prd_pk PRIMARY KEY (prd_id);

-- Alternate keys on table sif.predmet_dokument
ALTER TABLE sif.predmet_dokument ADD CONSTRAINT prd_oznaka_uk UNIQUE (prd_oznaka);
ALTER TABLE sif.predmet_dokument ADD CONSTRAINT prd_naziv_uk UNIQUE (prd_naziv);

COMMIT;
