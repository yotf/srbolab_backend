/* Table hmlg.vzs_vzk */
DROP TABLE IF EXISTS hmlg.vzs_vzk CASCADE;
-- Table hmlg.vzs_vzk
CREATE TABLE hmlg.vzs_vzk
(
  vzs_id integer NOT NULL,
  vzk_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vzs_vzk
COMMENT ON TABLE hmlg.vzs_vzk IS 'Karoserije vozila';
COMMENT ON COLUMN hmlg.vzs_vzk.vzs_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vzs_vzk.vzk_id IS 'ID karoserije vozila';

-- Primary key on table hmlg.vzs_vzk
ALTER TABLE hmlg.vzs_vzk ADD CONSTRAINT vzs_vzk_pk PRIMARY KEY (vzs_id, vzk_id);

-- Foreign keys on table hmlg.vzs_vzk
ALTER TABLE hmlg.vzs_vzk ADD CONSTRAINT vzsvzk_vzk_fk FOREIGN KEY (vzk_id) REFERENCES sif.vozilo_karoserija (vzk_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vzs_vzk ADD CONSTRAINT vzsvzk_vzs_fk FOREIGN KEY (vzs_id) REFERENCES hmlg.vozilo_sert (vzs_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
