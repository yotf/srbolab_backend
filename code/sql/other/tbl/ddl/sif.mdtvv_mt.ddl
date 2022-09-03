/* Table sif.mdtvv_mt */
DROP TABLE IF EXISTS sif.mdtvv_mt CASCADE;
-- Table sif.mdtvv_mt
CREATE TABLE sif.mdtvv_mt
(
  mr_id integer NOT NULL,
  md_id integer NOT NULL,
  mdtvv_id integer NOT NULL,
  mt_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.mdtvv_mt
COMMENT ON TABLE sif.mdtvv_mt IS 'Motori za model tip/varijanta/verzija';
COMMENT ON COLUMN sif.mdtvv_mt.mr_id IS 'ID marke';
COMMENT ON COLUMN sif.mdtvv_mt.md_id IS 'ID modela';
COMMENT ON COLUMN sif.mdtvv_mt.mdtvv_id IS 'ID model tip/varijanta/verzija';
COMMENT ON COLUMN sif.mdtvv_mt.mt_id IS 'ID motora';

-- Primary key on table sif.mdtvv_mt
ALTER TABLE sif.mdtvv_mt ADD CONSTRAINT PK_mdtvv_mt PRIMARY KEY (mdtvv_id, md_id, mr_id, mt_id);

-- Foreign keys on table sif.mdtvv_mt
ALTER TABLE sif.mdtvv_mt ADD CONSTRAINT mdtvvmt_mdtvv_fk FOREIGN KEY (mdtvv_id, md_id, mr_id) REFERENCES sif.md_tvv (mdtvv_id, md_id, mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.mdtvv_mt ADD CONSTRAINT mdtvvmt_mrmt_fk FOREIGN KEY (mr_id, mt_id) REFERENCES sif.mr_mt (mr_id, mt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
