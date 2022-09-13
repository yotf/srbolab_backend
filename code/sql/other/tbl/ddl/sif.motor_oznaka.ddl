/* Table sif.motor_oznaka */
DROP TABLE IF EXISTS sif.motor_oznaka CASCADE;
-- Table sif.motor_oznaka
CREATE TABLE sif.motor_oznaka
(
  mto_id integer NOT NULL,
  mto_oznaka character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.motor_oznaka
COMMENT ON TABLE sif.motor_oznaka IS 'Oznake motora';
COMMENT ON COLUMN sif.motor_oznaka.mto_id IS 'ID oznake motora';
COMMENT ON COLUMN sif.motor_oznaka.mto_oznaka IS 'Oznaka motora';

-- Primary key on table sif.motor_oznaka
ALTER TABLE sif.motor_oznaka ADD CONSTRAINT mto_pk PRIMARY KEY (mto_id);

-- Alternate keys on table sif.motor_oznaka
ALTER TABLE sif.motor_oznaka ADD CONSTRAINT mto_oznaka_uk UNIQUE (mto_oznaka);

COMMIT;
