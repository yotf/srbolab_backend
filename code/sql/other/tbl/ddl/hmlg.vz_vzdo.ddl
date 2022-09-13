/* Table hmlg.vz_vzdo */
DROP TABLE IF EXISTS hmlg.vz_vzdo CASCADE;
-- Table hmlg.vz_vzdo
CREATE TABLE hmlg.vz_vzdo
(
  vz_id integer NOT NULL,
  vzdo_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vz_vzdo
COMMENT ON TABLE hmlg.vz_vzdo IS 'Dodatne oznake vozila';
COMMENT ON COLUMN hmlg.vz_vzdo.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vz_vzdo.vzdo_id IS 'ID dodatne oznake vozila';

-- Primary key on table hmlg.vz_vzdo
ALTER TABLE hmlg.vz_vzdo ADD CONSTRAINT vz_vzdo_pk PRIMARY KEY (vz_id, vzdo_id);

-- Foreign keys on table hmlg.vz_vzdo
ALTER TABLE hmlg.vz_vzdo ADD CONSTRAINT vzvzdo_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vz_vzdo ADD CONSTRAINT vzvzdo_vzdo_fk FOREIGN KEY (vzdo_id) REFERENCES sif.vozilo_dod_oznaka (vzdo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
