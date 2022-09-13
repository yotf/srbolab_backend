/* Table sif.vzk_vzpv */
DROP TABLE IF EXISTS sif.vzk_vzpv CASCADE;
-- Table sif.vzk_vzpv
CREATE TABLE sif.vzk_vzpv
(
  vzk_id integer NOT NULL,
  vzpv_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.vzk_vzpv
COMMENT ON TABLE sif.vzk_vzpv IS 'Veza karoserije i kategorije vozila';
COMMENT ON COLUMN sif.vzk_vzpv.vzk_id IS 'ID vrste karoserije';
COMMENT ON COLUMN sif.vzk_vzpv.vzpv_id IS 'ID podvrste vozila';

-- Primary key on table sif.vzk_vzpv
ALTER TABLE sif.vzk_vzpv ADD CONSTRAINT vkvpv_pk PRIMARY KEY (vzk_id, vzpv_id);

-- Foreign keys on table sif.vzk_vzpv
ALTER TABLE sif.vzk_vzpv ADD CONSTRAINT vzkpv_vzk_fk FOREIGN KEY (vzk_id) REFERENCES sif.vozilo_karoserija (vzk_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sif.vzk_vzpv ADD CONSTRAINT vzkpv_vzpv_fk FOREIGN KEY (vzpv_id) REFERENCES sif.vozilo_podvrsta (vzpv_id) ON DELETE CASCADE ON UPDATE NO ACTION;

COMMIT;
