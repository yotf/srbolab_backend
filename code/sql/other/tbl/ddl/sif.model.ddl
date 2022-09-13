/* Table sif.model */
DROP TABLE IF EXISTS sif.model CASCADE;
-- Table sif.model
CREATE TABLE sif.model
(
  mr_id integer NOT NULL,
  md_id integer NOT NULL,
  md_naziv_k character varying(50) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.model
COMMENT ON TABLE sif.model IS 'Model';
COMMENT ON COLUMN sif.model.mr_id IS 'ID marke';
COMMENT ON COLUMN sif.model.md_id IS 'ID modela';
COMMENT ON COLUMN sif.model.md_naziv_k IS 'Komercijalni naziv modela';

-- Indexes on table sif.model
CREATE UNIQUE INDEX md_uk1_i ON sif.model (mr_id, md_naziv_k);

-- Primary key on table sif.model
ALTER TABLE sif.model ADD CONSTRAINT md_pk PRIMARY KEY (md_id, mr_id);

-- Foreign keys on table sif.model
ALTER TABLE sif.model ADD CONSTRAINT md_mr_fk FOREIGN KEY (mr_id) REFERENCES sif.marka (mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
