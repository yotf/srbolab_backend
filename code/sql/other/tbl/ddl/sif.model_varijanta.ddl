/* Table sif.model_varijanta */
DROP TABLE IF EXISTS sif.model_varijanta CASCADE;
-- Table sif.model_varijanta
CREATE TABLE sif.model_varijanta
(
  mdvr_id integer NOT NULL,
  mdvr_oznaka character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.model_varijanta
COMMENT ON TABLE sif.model_varijanta IS 'Varijanta modela';
COMMENT ON COLUMN sif.model_varijanta.mdvr_id IS 'ID varijante modela';
COMMENT ON COLUMN sif.model_varijanta.mdvr_oznaka IS 'Oznaka varijante modela';

-- Primary key on table sif.model_varijanta
ALTER TABLE sif.model_varijanta ADD CONSTRAINT mdvr_pk PRIMARY KEY (mdvr_id);

-- Alternate keys on table sif.model_varijanta
ALTER TABLE sif.model_varijanta ADD CONSTRAINT mdvr_oznaka_uk UNIQUE (mdvr_oznaka);

COMMIT;
