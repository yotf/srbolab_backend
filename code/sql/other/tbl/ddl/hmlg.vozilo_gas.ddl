/* Table hmlg.vozilo_gas */
DROP TABLE IF EXISTS hmlg.vozilo_gas CASCADE;
-- Table hmlg.vozilo_gas
CREATE TABLE hmlg.vozilo_gas
(
  vz_id integer NOT NULL,
  vzg_id integer NOT NULL,
  vzg_tip character varying(10) DEFAULT 'TNG' CHECK (vzg_tip IN ('TNG', 'KPG')),
  vzg_aktivan character(1) DEFAULT 'D' CHECK (vzg_aktivan IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vozilo_gas
COMMENT ON TABLE hmlg.vozilo_gas IS 'Gasni uređaj za vozilo';
COMMENT ON COLUMN hmlg.vozilo_gas.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo_gas.vzg_id IS 'ID gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gas.vzg_tip IS 'Tip gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gas.vzg_aktivan IS 'Uređaj je aktivan?';

-- Primary key on table hmlg.vozilo_gas
ALTER TABLE hmlg.vozilo_gas ADD CONSTRAINT vzg_pk PRIMARY KEY (vz_id, vzg_id);

-- Foreign keys on table hmlg.vozilo_gas
ALTER TABLE hmlg.vozilo_gas ADD CONSTRAINT vzg_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
