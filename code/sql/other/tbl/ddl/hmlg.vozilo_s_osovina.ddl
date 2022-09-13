/* Table hmlg.vozilo_s_osovina */
DROP TABLE IF EXISTS hmlg.vozilo_s_osovina CASCADE;
-- Table hmlg.vozilo_s_osovina
CREATE TABLE hmlg.vozilo_s_osovina
(
  vzs_id integer NOT NULL,
  vzos_rb integer NOT NULL,
  vzos_nosivost integer DEFAULT 0 NOT NULL CHECK (vzos_nosivost>=0),
  vzos_tockova integer DEFAULT 0 NOT NULL CHECK (vzos_tockova>=0),
  vzos_pneumatik character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vozilo_s_osovina
COMMENT ON TABLE hmlg.vozilo_s_osovina IS 'Osovine vozila';
COMMENT ON COLUMN hmlg.vozilo_s_osovina.vzs_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo_s_osovina.vzos_rb IS 'Redni broj osovine';
COMMENT ON COLUMN hmlg.vozilo_s_osovina.vzos_nosivost IS 'Nosivost osovine';
COMMENT ON COLUMN hmlg.vozilo_s_osovina.vzos_tockova IS 'Broj točkova na osovini';
COMMENT ON COLUMN hmlg.vozilo_s_osovina.vzos_pneumatik IS 'Pneumatici za osovinu';

-- Primary key on table hmlg.vozilo_s_osovina
ALTER TABLE hmlg.vozilo_s_osovina ADD CONSTRAINT vzos_pk PRIMARY KEY (vzos_rb, vzs_id);

-- Foreign keys on table hmlg.vozilo_s_osovina
ALTER TABLE hmlg.vozilo_s_osovina ADD CONSTRAINT vzos_vzs_fk FOREIGN KEY (vzs_id) REFERENCES hmlg.vozilo_sert (vzs_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
