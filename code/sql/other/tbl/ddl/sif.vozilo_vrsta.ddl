/* Table sif.vozilo_vrsta */
DROP TABLE IF EXISTS sif.vozilo_vrsta CASCADE;
-- Table sif.vozilo_vrsta
CREATE TABLE sif.vozilo_vrsta
(
  vzv_id integer NOT NULL,
  vzv_oznaka character varying(10) NOT NULL,
  vzv_naziv character varying(100) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.vozilo_vrsta
COMMENT ON TABLE sif.vozilo_vrsta IS 'Vrste vozila';
COMMENT ON COLUMN sif.vozilo_vrsta.vzv_id IS 'ID vrste vozila';
COMMENT ON COLUMN sif.vozilo_vrsta.vzv_oznaka IS 'Oznaka vrste vozila';
COMMENT ON COLUMN sif.vozilo_vrsta.vzv_naziv IS 'Naziv vrste vozila';

-- Primary key on table sif.vozilo_vrsta
ALTER TABLE sif.vozilo_vrsta ADD CONSTRAINT vzv_pk PRIMARY KEY (vzv_id);

-- Alternate keys on table sif.vozilo_vrsta
ALTER TABLE sif.vozilo_vrsta ADD CONSTRAINT vzv_oznaka_uk UNIQUE (vzv_oznaka);

COMMIT;
