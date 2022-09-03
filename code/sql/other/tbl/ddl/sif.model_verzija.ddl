/* Table sif.model_verzija */
DROP TABLE IF EXISTS sif.model_verzija CASCADE;
-- Table sif.model_verzija
CREATE TABLE sif.model_verzija
(
  mdvz_id integer NOT NULL,
  mdvz_oznaka character varying(50) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.model_verzija
COMMENT ON TABLE sif.model_verzija IS 'Verzija modela';
COMMENT ON COLUMN sif.model_verzija.mdvz_id IS 'ID verzije modela';
COMMENT ON COLUMN sif.model_verzija.mdvz_oznaka IS 'Oznaka verzije modela';

-- Primary key on table sif.model_verzija
ALTER TABLE sif.model_verzija ADD CONSTRAINT mdvz_pk PRIMARY KEY (mdvz_id);

-- Alternate keys on table sif.model_verzija
ALTER TABLE sif.model_verzija ADD CONSTRAINT mdvz_oznaka_uk UNIQUE (mdvz_oznaka);

COMMIT;
