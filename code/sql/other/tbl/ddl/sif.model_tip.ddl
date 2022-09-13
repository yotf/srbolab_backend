/* Table sif.model_tip */
DROP TABLE IF EXISTS sif.model_tip CASCADE;
-- Table sif.model_tip
CREATE TABLE sif.model_tip
(
  mdt_id integer NOT NULL,
  mdt_oznaka character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.model_tip
COMMENT ON TABLE sif.model_tip IS 'Tip modela';
COMMENT ON COLUMN sif.model_tip.mdt_id IS 'ID tipa modela';
COMMENT ON COLUMN sif.model_tip.mdt_oznaka IS 'Oznaka tipa modela';

-- Primary key on table sif.model_tip
ALTER TABLE sif.model_tip ADD CONSTRAINT mdt_pk PRIMARY KEY (mdt_id);

-- Alternate keys on table sif.model_tip
ALTER TABLE sif.model_tip ADD CONSTRAINT mdt_oznaka_uk UNIQUE (mdt_oznaka);

COMMIT;
