/* Table sif.vzkl_vzpv */
DROP TABLE IF EXISTS sif.vzkl_vzpv CASCADE;
-- Table sif.vzkl_vzpv
CREATE TABLE sif.vzkl_vzpv
(
  vzkl_id integer NOT NULL,
  vzpv_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.vzkl_vzpv
COMMENT ON TABLE sif.vzkl_vzpv IS 'Veza klase vozila i kategorije vozila';
COMMENT ON COLUMN sif.vzkl_vzpv.vzkl_id IS 'ID klase vozila';
COMMENT ON COLUMN sif.vzkl_vzpv.vzpv_id IS 'ID kategorije vozila';

-- Indexes on table sif.vzkl_vzpv
CREATE INDEX vzklpv_vzpv_fk_i ON sif.vzkl_vzpv (vzkl_id);
CREATE INDEX vzklpv_vzkl_fk_i ON sif.vzkl_vzpv (vzpv_id);

-- Primary key on table sif.vzkl_vzpv
ALTER TABLE sif.vzkl_vzpv ADD CONSTRAINT vzklpv_pk PRIMARY KEY (vzkl_id, vzpv_id);

-- Foreign keys on table sif.vzkl_vzpv
ALTER TABLE sif.vzkl_vzpv ADD CONSTRAINT vzklpv_vzkl_fk FOREIGN KEY (vzkl_id) REFERENCES sif.vozilo_klasa (vzkl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.vzkl_vzpv ADD CONSTRAINT vzklpv_vzpv_fk FOREIGN KEY (vzpv_id) REFERENCES sif.vozilo_podvrsta (vzpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
