/* Table sif.vozilo_karoserija */
DROP TABLE IF EXISTS sif.vozilo_karoserija CASCADE;
-- Table sif.vozilo_karoserija
CREATE TABLE sif.vozilo_karoserija
(
  vzk_id integer NOT NULL,
  vzk_oznaka character varying(10) NOT NULL,
  vzk_naziv character varying(100)
) WITH (autovacuum_enabled=true);

-- Comments on table sif.vozilo_karoserija
COMMENT ON TABLE sif.vozilo_karoserija IS 'Vrste karoserije vozila';
COMMENT ON COLUMN sif.vozilo_karoserija.vzk_id IS 'ID vrste karoserije';
COMMENT ON COLUMN sif.vozilo_karoserija.vzk_oznaka IS 'Oznaka vrste karoserije';
COMMENT ON COLUMN sif.vozilo_karoserija.vzk_naziv IS 'Naziv vrste karoserije';

-- Primary key on table sif.vozilo_karoserija
ALTER TABLE sif.vozilo_karoserija ADD CONSTRAINT vzk_pk PRIMARY KEY (vzk_id);

COMMIT;
