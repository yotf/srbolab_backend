/* Table sif.vozilo_dokument */
DROP TABLE IF EXISTS sif.vozilo_dokument CASCADE;
-- Table sif.vozilo_dokument
CREATE TABLE sif.vozilo_dokument
(
  vzd_id integer NOT NULL,
  vzd_oznaka character varying(10) NOT NULL,
  vzd_naziv character varying(60) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.vozilo_dokument
COMMENT ON TABLE sif.vozilo_dokument IS 'Dokumnta za vozilo';
COMMENT ON COLUMN sif.vozilo_dokument.vzd_id IS 'ID dokumenta';
COMMENT ON COLUMN sif.vozilo_dokument.vzd_oznaka IS 'Oznaka dokumenta';
COMMENT ON COLUMN sif.vozilo_dokument.vzd_naziv IS 'Naziv dokumenta';

-- Primary key on table sif.vozilo_dokument
ALTER TABLE sif.vozilo_dokument ADD CONSTRAINT dok_pk PRIMARY KEY (vzd_id);

-- Alternate keys on table sif.vozilo_dokument
ALTER TABLE sif.vozilo_dokument ADD CONSTRAINT dok_oznaka_uk UNIQUE (vzd_oznaka);
ALTER TABLE sif.vozilo_dokument ADD CONSTRAINT dok_naziv_uk UNIQUE (vzd_naziv);

COMMIT;
