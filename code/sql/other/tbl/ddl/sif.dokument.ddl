/* Table sif.dokument */
DROP TABLE IF EXISTS sif.dokument CASCADE;
-- Table sif.dokument
CREATE TABLE sif.dokument
(
  dok_id integer NOT NULL,
  dok_oznaka character varying(10) NOT NULL,
  dok_naziv character varying(60) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.dokument
COMMENT ON TABLE sif.dokument IS 'Dokumnta za predmet';
COMMENT ON COLUMN sif.dokument.dok_id IS 'ID dokumenta';
COMMENT ON COLUMN sif.dokument.dok_oznaka IS 'Oznaka dokumenta';
COMMENT ON COLUMN sif.dokument.dok_naziv IS 'Naziv dokumenta';

-- Primary key on table sif.dokument
ALTER TABLE sif.dokument ADD CONSTRAINT dok_pk PRIMARY KEY (dok_id);

-- Alternate keys on table sif.dokument
ALTER TABLE sif.dokument ADD CONSTRAINT dok_oznaka_uk UNIQUE (dok_oznaka);
ALTER TABLE sif.dokument ADD CONSTRAINT dok_naziv_uk UNIQUE (dok_naziv);

COMMIT;
