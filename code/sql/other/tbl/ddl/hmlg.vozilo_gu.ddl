/* Table hmlg.vozilo_gu */
DROP TABLE IF EXISTS hmlg.vozilo_gu CASCADE;
-- Table hmlg.vozilo_gu
CREATE TABLE hmlg.vozilo_gu
(
  vz_id integer NOT NULL,
  vzg_id integer NOT NULL,
  vzgu_id integer NOT NULL,
  vzgu_broj character varying(20) NOT NULL,
  agu_id integer NOT NULL,
  agp_id integer NOT NULL,
  agh_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vozilo_gu
COMMENT ON TABLE hmlg.vozilo_gu IS 'Delovi gasnog uređaja za vozilo';
COMMENT ON COLUMN hmlg.vozilo_gu.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo_gu.vzg_id IS 'ID gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gu.vzgu_id IS 'ID dela gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gu.vzgu_broj IS 'Broj dela gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gu.agu_id IS 'ID dela gasnog uređaja';

-- Indexes on table hmlg.vozilo_gu
CREATE INDEX vzgu_agu_fk_i ON hmlg.vozilo_gu (agu_id);
CREATE INDEX vzgu_agph_fk_i ON hmlg.vozilo_gu (agp_id, agh_id);

-- Primary key on table hmlg.vozilo_gu
ALTER TABLE hmlg.vozilo_gu ADD CONSTRAINT vzgu_pk PRIMARY KEY (vz_id, vzg_id, vzgu_id);

-- Foreign keys on table hmlg.vozilo_gu
ALTER TABLE hmlg.vozilo_gu ADD CONSTRAINT vzgu_vzg_fk FOREIGN KEY (vz_id, vzg_id) REFERENCES hmlg.vozilo_gas (vz_id, vzg_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gu ADD CONSTRAINT vzgu_agu_fk FOREIGN KEY (agu_id) REFERENCES sif.ag_uredjaj (agu_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gu ADD CONSTRAINT vzgu_agp_agh_fk FOREIGN KEY (agp_id, agh_id) REFERENCES sif.agp_agh (agp_id, agh_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
