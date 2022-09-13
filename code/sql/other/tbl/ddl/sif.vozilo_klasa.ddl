/* Table sif.vozilo_klasa */
DROP TABLE IF EXISTS sif.vozilo_klasa CASCADE;
-- Table sif.vozilo_klasa
CREATE TABLE sif.vozilo_klasa
(
  vzkl_id integer NOT NULL,
  vzkl_oznaka character varying(10) NOT NULL,
  vzkl_naziv character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.vozilo_klasa
COMMENT ON TABLE sif.vozilo_klasa IS 'Klase vozila';
COMMENT ON COLUMN sif.vozilo_klasa.vzkl_id IS 'ID klase vozila';
COMMENT ON COLUMN sif.vozilo_klasa.vzkl_oznaka IS 'Oznaka klase vozila';
COMMENT ON COLUMN sif.vozilo_klasa.vzkl_naziv IS 'Naziv klase vozila';

-- Primary key on table sif.vozilo_klasa
ALTER TABLE sif.vozilo_klasa ADD CONSTRAINT vzkl_pk PRIMARY KEY (vzkl_id);

-- Alternate keys on table sif.vozilo_klasa
ALTER TABLE sif.vozilo_klasa ADD CONSTRAINT vzkl_oznaka_uk UNIQUE (vzkl_oznaka);

COMMIT;
