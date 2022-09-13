/* Table sif.mr_mt */
DROP TABLE IF EXISTS sif.mr_mt CASCADE;
-- Table sif.mr_mt
CREATE TABLE sif.mr_mt
(
  mr_id integer NOT NULL,
  mt_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.mr_mt
COMMENT ON TABLE sif.mr_mt IS 'Veza marke i motora';
COMMENT ON COLUMN sif.mr_mt.mr_id IS 'ID modela';
COMMENT ON COLUMN sif.mr_mt.mt_id IS 'ID motora';

-- Primary key on table sif.mr_mt
ALTER TABLE sif.mr_mt ADD CONSTRAINT PK_mr_mt PRIMARY KEY (mr_id, mt_id);

-- Foreign keys on table sif.mr_mt
ALTER TABLE sif.mr_mt ADD CONSTRAINT mrmt_mr_fk FOREIGN KEY (mr_id) REFERENCES sif.marka (mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.mr_mt ADD CONSTRAINT mrmt_mt_fk FOREIGN KEY (mt_id) REFERENCES sif.motor (mt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
