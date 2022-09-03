/* Table sif.model_tvv */
DROP TABLE IF EXISTS sif.model_tvv CASCADE;
-- Table sif.model_tvv
CREATE TABLE sif.model_tvv
(
  mr_id integer NOT NULL,
  md_id integer NOT NULL,
  mdtvv_id integer NOT NULL,
  mdt_id integer NOT NULL,
  mdvr_id integer NOT NULL,
  mdvz_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.model_tvv
COMMENT ON TABLE sif.model_tvv IS 'Model tip/varijanta/verzija';
COMMENT ON COLUMN sif.model_tvv.mdtvv_id IS 'ID model tip/varijanta/verzija';

-- Indexes on table sif.model_tvv
CREATE INDEX mdtvv_mdtvr_fk_i ON sif.model_tvv (mdt_id, mdvr_id);
CREATE INDEX mdtvv_mdvrz_fk_i ON sif.model_tvv (mdvr_id, mdvz_id);
CREATE UNIQUE INDEX mdtvv_uk1_i ON sif.model_tvv (mr_id, md_id, mdt_id, mdvr_id, mdvz_id);

-- Primary key on table sif.model_tvv
ALTER TABLE sif.model_tvv ADD CONSTRAINT mdtvv_pk PRIMARY KEY (mdtvv_id, md_id, mr_id);

-- Foreign keys on table sif.model_tvv
ALTER TABLE sif.model_tvv ADD CONSTRAINT mdtvv_md_fk FOREIGN KEY (md_id, mr_id) REFERENCES sif.model (md_id, mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.model_tvv ADD CONSTRAINT mdtvv_mdtvr_fk FOREIGN KEY (mdt_id, mdvr_id) REFERENCES sif.mdt_mdvr (mdt_id, mdvr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.model_tvv ADD CONSTRAINT mdtvv_mdvrz_fk FOREIGN KEY (mdvr_id, mdvz_id) REFERENCES sif.mdvr_mdvz (mdvr_id, mdvz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
