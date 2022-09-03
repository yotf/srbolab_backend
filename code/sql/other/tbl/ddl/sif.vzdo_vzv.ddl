/* Table sif.vzdo_vzv */
DROP TABLE IF EXISTS sif.vzdo_vzv CASCADE;
-- Table sif.vzdo_vzv
CREATE TABLE sif.vzdo_vzv
(
  vzdo_id integer NOT NULL,
  vzv_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.vzdo_vzv
COMMENT ON TABLE sif.vzdo_vzv IS 'Veza dodatne oznake i vrste vozila';
COMMENT ON COLUMN sif.vzdo_vzv.vzdo_id IS 'ID dodatne oznake';
COMMENT ON COLUMN sif.vzdo_vzv.vzv_id IS 'ID vrste vozila';

-- Indexes on table sif.vzdo_vzv
CREATE INDEX vzdov_vzv_fk_i ON sif.vzdo_vzv (vzv_id);

-- Primary key on table sif.vzdo_vzv
ALTER TABLE sif.vzdo_vzv ADD CONSTRAINT vzdov_pk PRIMARY KEY (vzdo_id, vzv_id);

-- Foreign keys on table sif.vzdo_vzv
ALTER TABLE sif.vzdo_vzv ADD CONSTRAINT vzdov_vzdo_fk FOREIGN KEY (vzdo_id) REFERENCES sif.vozilo_dod_oznaka (vzdo_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sif.vzdo_vzv ADD CONSTRAINT vzdov_vzv_fk FOREIGN KEY (vzv_id) REFERENCES sif.vozilo_vrsta (vzv_id) ON DELETE CASCADE ON UPDATE NO ACTION;

COMMIT;
