/* Table hmlg.vozilo_osovina */
DROP TABLE IF EXISTS hmlg.vozilo_osovina CASCADE;
-- Table hmlg.vozilo_osovina
CREATE TABLE hmlg.vozilo_osovina
(
  vz_id integer NOT NULL,
  vzo_rb integer NOT NULL,
  vzo_nosivost integer DEFAULT 0 NOT NULL CHECK (vzo_nosivost>=0),
  vzo_tockova integer DEFAULT 0 NOT NULL CHECK (vzo_tockova>=0),
  vzo_pneumatik character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vozilo_osovina
COMMENT ON TABLE hmlg.vozilo_osovina IS 'Osovine vozila';
COMMENT ON COLUMN hmlg.vozilo_osovina.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo_osovina.vzo_rb IS 'Redni broj osovine';
COMMENT ON COLUMN hmlg.vozilo_osovina.vzo_nosivost IS 'Nosivost osovine';
COMMENT ON COLUMN hmlg.vozilo_osovina.vzo_tockova IS 'Broj točkova na osovini';
COMMENT ON COLUMN hmlg.vozilo_osovina.vzo_pneumatik IS 'Pneumatici za osovinu';

-- Primary key on table hmlg.vozilo_osovina
ALTER TABLE hmlg.vozilo_osovina ADD CONSTRAINT vzo_pk PRIMARY KEY (vzo_rb, vz_id);

-- Foreign keys on table hmlg.vozilo_osovina
ALTER TABLE hmlg.vozilo_osovina ADD CONSTRAINT vzo_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
