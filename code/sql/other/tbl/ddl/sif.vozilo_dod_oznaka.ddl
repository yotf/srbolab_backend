/* Table sif.vozilo_dod_oznaka */
DROP TABLE IF EXISTS sif.vozilo_dod_oznaka CASCADE;
-- Table sif.vozilo_dod_oznaka
CREATE TABLE sif.vozilo_dod_oznaka
(
  vzdo_id integer NOT NULL,
  vzdo_oznaka character varying(10) NOT NULL,
  vzdo_oznaka1 character varying(10),
  vzdo_naziv character varying(100)
) WITH (autovacuum_enabled=true);

-- Comments on table sif.vozilo_dod_oznaka
COMMENT ON TABLE sif.vozilo_dod_oznaka IS 'Dodatna oznaka vozila';
COMMENT ON COLUMN sif.vozilo_dod_oznaka.vzdo_id IS 'ID dodatne oznake';
COMMENT ON COLUMN sif.vozilo_dod_oznaka.vzdo_oznaka IS 'Dodatna oznaka';
COMMENT ON COLUMN sif.vozilo_dod_oznaka.vzdo_oznaka1 IS 'Dodatna oznaka1';
COMMENT ON COLUMN sif.vozilo_dod_oznaka.vzdo_naziv IS 'Naziv dodatne oznake';

-- Indexes on table sif.vozilo_dod_oznaka
CREATE UNIQUE INDEX vzdo_uk1 ON sif.vozilo_dod_oznaka (vzdo_oznaka, vzdo_oznaka1);

-- Primary key on table sif.vozilo_dod_oznaka
ALTER TABLE sif.vozilo_dod_oznaka ADD CONSTRAINT vzdo_pk PRIMARY KEY (vzdo_id);

COMMIT;
