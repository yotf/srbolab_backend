/* Table sif.agp_agh */
DROP TABLE IF EXISTS sif.agp_agh CASCADE;
-- Table sif.agp_agh
CREATE TABLE sif.agp_agh
(
  agp_id integer NOT NULL,
  agh_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.agp_agh
COMMENT ON TABLE sif.agp_agh IS 'Homologacije za proizvođača';
COMMENT ON COLUMN sif.agp_agh.agp_id IS 'ID proizvođača';
COMMENT ON COLUMN sif.agp_agh.agh_id IS 'ID homologacije';

-- Primary key on table sif.agp_agh
ALTER TABLE sif.agp_agh ADD CONSTRAINT agph_pk PRIMARY KEY (agp_id, agh_id);

-- Foreign keys on table sif.agp_agh
ALTER TABLE sif.agp_agh ADD CONSTRAINT agph_agp_fk FOREIGN KEY (agp_id) REFERENCES sif.ag_proizvodjac (agp_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sif.agp_agh ADD CONSTRAINT agph_agh FOREIGN KEY (agh_id) REFERENCES sif.ag_homologacija (agh_id) ON DELETE CASCADE ON UPDATE NO ACTION;

COMMIT;
