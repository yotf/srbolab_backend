/* Table sif.mdt_mdvr */
DROP TABLE IF EXISTS sif.mdt_mdvr CASCADE;
-- Table sif.mdt_mdvr
CREATE TABLE sif.mdt_mdvr
(
  mdt_id integer NOT NULL,
  mdvr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.mdt_mdvr
COMMENT ON TABLE sif.mdt_mdvr IS 'Veza tipa i varijante';

-- Primary key on table sif.mdt_mdvr
ALTER TABLE sif.mdt_mdvr ADD CONSTRAINT mdtvr_pk PRIMARY KEY (mdt_id, mdvr_id);

-- Foreign keys on table sif.mdt_mdvr
ALTER TABLE sif.mdt_mdvr ADD CONSTRAINT mdtvr_mdt_fk FOREIGN KEY (mdt_id) REFERENCES sif.model_tip (mdt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.mdt_mdvr ADD CONSTRAINT mdtvr_mdvr_fk FOREIGN KEY (mdvr_id) REFERENCES sif.model_varijanta (mdvr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
