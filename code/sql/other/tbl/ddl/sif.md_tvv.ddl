/* Table sif.md_tvv */
DROP TABLE IF EXISTS sif.md_tvv CASCADE;
-- Table sif.md_tvv
CREATE TABLE sif.md_tvv
(
  mr_id integer NOT NULL,
  md_id integer NOT NULL,
  mdtvv_id integer NOT NULL,
  mdt_id integer NOT NULL,
  mdvr_id integer NOT NULL,
  mdvz_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.md_tvv
COMMENT ON TABLE sif.md_tvv IS 'Model tip/varijanta/verzija';
COMMENT ON COLUMN sif.md_tvv.mr_id IS 'ID marke';
COMMENT ON COLUMN sif.md_tvv.md_id IS 'ID modela';
COMMENT ON COLUMN sif.md_tvv.mdtvv_id IS 'ID model tip/varijanta/verzija';
COMMENT ON COLUMN sif.md_tvv.mdt_id IS 'ID tipa modela';
COMMENT ON COLUMN sif.md_tvv.mdvr_id IS 'ID varijante modela';
COMMENT ON COLUMN sif.md_tvv.mdvz_id IS 'ID verzije modela';

-- Indexes on table sif.md_tvv
CREATE INDEX mdtvv_mdtvr_fk_i ON sif.md_tvv (mdt_id, mdvr_id);
CREATE INDEX mdtvv_mdvrz_fk_i ON sif.md_tvv (mdvr_id, mdvz_id);
CREATE UNIQUE INDEX mdtvv_uk1_i ON sif.md_tvv (mr_id, md_id, mdt_id, mdvr_id, mdvz_id);

-- Primary key on table sif.md_tvv
ALTER TABLE sif.md_tvv ADD CONSTRAINT mdtvv_pk PRIMARY KEY (mdtvv_id, md_id, mr_id);

-- Foreign keys on table sif.md_tvv
ALTER TABLE sif.md_tvv ADD CONSTRAINT mdtvv_md_fk FOREIGN KEY (md_id, mr_id) REFERENCES sif.model (md_id, mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.md_tvv ADD CONSTRAINT mdtvv_mdtvr_fk FOREIGN KEY (mdt_id, mdvr_id) REFERENCES sif.mdt_mdvr (mdt_id, mdvr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.md_tvv ADD CONSTRAINT mdtvv_mdvrz_fk FOREIGN KEY (mdvr_id, mdvz_id) REFERENCES sif.mdvr_mdvz (mdvr_id, mdvz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
