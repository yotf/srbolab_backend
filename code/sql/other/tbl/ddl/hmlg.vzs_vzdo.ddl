/* Table hmlg.vzs_vzdo */
DROP TABLE IF EXISTS hmlg.vzs_vzdo CASCADE;
-- Table hmlg.vzs_vzdo
CREATE TABLE hmlg.vzs_vzdo
(
  vzs_id integer NOT NULL,
  vzdo_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vzs_vzdo
COMMENT ON TABLE hmlg.vzs_vzdo IS 'Dodatne oznake vozila';
COMMENT ON COLUMN hmlg.vzs_vzdo.vzs_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vzs_vzdo.vzdo_id IS 'ID dodatne oznake vozila';

-- Primary key on table hmlg.vzs_vzdo
ALTER TABLE hmlg.vzs_vzdo ADD CONSTRAINT vzs_vzdo_pk PRIMARY KEY (vzs_id, vzdo_id);

-- Foreign keys on table hmlg.vzs_vzdo
ALTER TABLE hmlg.vzs_vzdo ADD CONSTRAINT vzsvzdo_vzdo_fk FOREIGN KEY (vzdo_id) REFERENCES sif.vozilo_dod_oznaka (vzdo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vzs_vzdo ADD CONSTRAINT vzsvzk_vzs_fk FOREIGN KEY (vzs_id) REFERENCES hmlg.vozilo_sert (vzs_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
