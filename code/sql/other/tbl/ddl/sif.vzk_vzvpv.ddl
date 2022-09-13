/* Table sif.vzk_vzvpv */
DROP TABLE IF EXISTS sif.vzk_vzvpv CASCADE;
-- Table sif.vzk_vzvpv
CREATE TABLE sif.vzk_vzvpv
(
  vzk_id integer NOT NULL,
  vzpv_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.vzk_vzvpv
COMMENT ON TABLE sif.vzk_vzvpv IS 'Veza karoserije i podvrste vozila';
COMMENT ON COLUMN sif.vzk_vzvpv.vzk_id IS 'ID vrste karoserije';
COMMENT ON COLUMN sif.vzk_vzvpv.vzpv_id IS 'ID podvrste vozila';

-- Primary key on table sif.vzk_vzvpv
ALTER TABLE sif.vzk_vzvpv ADD CONSTRAINT vkvpv_pk PRIMARY KEY (vzk_id, vzpv_id);

-- Foreign keys on table sif.vzk_vzvpv
ALTER TABLE sif.vzk_vzvpv ADD CONSTRAINT vkvpv_vzk_fk FOREIGN KEY (vzk_id) REFERENCES sif.vozilo_karoserija (vzk_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sif.vzk_vzvpv ADD CONSTRAINT vkvpv_vzpv_fk FOREIGN KEY (vzpv_id) REFERENCES sif.vozilo_podvrsta (vzpv_id) ON DELETE CASCADE ON UPDATE NO ACTION;

COMMIT;
