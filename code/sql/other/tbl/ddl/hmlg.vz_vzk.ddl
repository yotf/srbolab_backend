/* Table hmlg.vz_vzk */
DROP TABLE IF EXISTS hmlg.vz_vzk CASCADE;
-- Table hmlg.vz_vzk
CREATE TABLE hmlg.vz_vzk
(
  vz_id integer NOT NULL,
  vzk_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vz_vzk
COMMENT ON TABLE hmlg.vz_vzk IS 'Karoserije vozila';
COMMENT ON COLUMN hmlg.vz_vzk.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vz_vzk.vzk_id IS 'ID karoserije vozila';

-- Primary key on table hmlg.vz_vzk
ALTER TABLE hmlg.vz_vzk ADD CONSTRAINT vz_vzk_pk PRIMARY KEY (vz_id, vzk_id);

-- Foreign keys on table hmlg.vz_vzk
ALTER TABLE hmlg.vz_vzk ADD CONSTRAINT vzvzk_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vz_vzk ADD CONSTRAINT vzvzk_vzk_fk FOREIGN KEY (vzk_id) REFERENCES sif.vozilo_karoserija (vzk_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
