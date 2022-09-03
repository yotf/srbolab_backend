/* Table sif.md_mdvtt */
DROP TABLE IF EXISTS sif.md_mdvtt CASCADE;
-- Table sif.md_mdvtt
CREATE TABLE sif.md_mdvtt
(
  mr_id integer NOT NULL,
  md_id integer NOT NULL,
  mdt_id integer NOT NULL,
  mdvr_id integer NOT NULL,
  mdvz_id integer NOT NULL,
  mt_id integer
) WITH (autovacuum_enabled=true);

-- Comments on table sif.md_mdvtt
COMMENT ON TABLE sif.md_mdvtt IS 'Veza modela i tip/varijanta/verzija';

-- Indexes on table sif.md_mdvtt
CREATE INDEX mdvtt_mrmt_fk_i ON sif.md_mdvtt (mt_id, mr_id);

-- Primary key on table sif.md_mdvtt
ALTER TABLE sif.md_mdvtt ADD CONSTRAINT mdvtt_pk PRIMARY KEY (md_id, mdt_id, mdvr_id, mdvz_id, mr_id);

-- Foreign keys on table sif.md_mdvtt
ALTER TABLE sif.md_mdvtt ADD CONSTRAINT mdvtt_md_fk FOREIGN KEY (md_id, mr_id) REFERENCES sif.model (md_id, mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.md_mdvtt ADD CONSTRAINT mdvtt_mdtvr_fk FOREIGN KEY (mdt_id, mdvr_id) REFERENCES sif.mdt_mdvr (mdt_id, mdvr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.md_mdvtt ADD CONSTRAINT mdvtt_mdvrz_fk FOREIGN KEY (mdvr_id, mdvz_id) REFERENCES sif.mdvr_mdvz (mdvr_id, mdvz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.md_mdvtt ADD CONSTRAINT mdvtt_mrmt_fk FOREIGN KEY (mr_id, mt_id) REFERENCES sif.mr_mt (mr_id, mt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
