/* Table sif.vozilo_podvrsta */
DROP TABLE IF EXISTS sif.vozilo_podvrsta CASCADE;
-- Table sif.vozilo_podvrsta
CREATE TABLE sif.vozilo_podvrsta
(
  vzpv_id integer NOT NULL,
  vzpv_oznaka character varying(10) NOT NULL,
  vzpv_naziv character varying(100) NOT NULL,
  vzv_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.vozilo_podvrsta
COMMENT ON TABLE sif.vozilo_podvrsta IS 'Kategorije vozila';
COMMENT ON COLUMN sif.vozilo_podvrsta.vzpv_id IS 'ID kategorije vozila';
COMMENT ON COLUMN sif.vozilo_podvrsta.vzpv_oznaka IS 'Oznaka kategorije vozila';
COMMENT ON COLUMN sif.vozilo_podvrsta.vzpv_naziv IS 'Naziv kategorije vozila';
COMMENT ON COLUMN sif.vozilo_podvrsta.vzv_id IS 'ID vrste vozila';

-- Indexes on table sif.vozilo_podvrsta
CREATE INDEX vzpv_vzv_fk_i ON sif.vozilo_podvrsta (vzv_id);

-- Primary key on table sif.vozilo_podvrsta
ALTER TABLE sif.vozilo_podvrsta ADD CONSTRAINT vzpv_pk PRIMARY KEY (vzpv_id);

-- Alternate keys on table sif.vozilo_podvrsta
ALTER TABLE sif.vozilo_podvrsta ADD CONSTRAINT vzpv_oznaka_uk UNIQUE (vzpv_oznaka);

-- Foreign keys on table sif.vozilo_podvrsta
ALTER TABLE sif.vozilo_podvrsta ADD CONSTRAINT vzpv_vzv_fk FOREIGN KEY (vzv_id) REFERENCES sif.vozilo_vrsta (vzv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
