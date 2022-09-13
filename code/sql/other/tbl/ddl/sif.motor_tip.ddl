/* Table sif.motor_tip */
DROP TABLE IF EXISTS sif.motor_tip CASCADE;
-- Table sif.motor_tip
CREATE TABLE sif.motor_tip
(
  mtt_id integer NOT NULL,
  mtt_oznaka character(1) DEFAULT 'B' NOT NULL CHECK (mtt_oznaka IN ('B', 'D', 'E')),
  mtt_naziv character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.motor_tip
COMMENT ON TABLE sif.motor_tip IS 'Tip motora';
COMMENT ON COLUMN sif.motor_tip.mtt_id IS 'ID tipa motora';
COMMENT ON COLUMN sif.motor_tip.mtt_oznaka IS 'Oznaka tipa motora';
COMMENT ON COLUMN sif.motor_tip.mtt_naziv IS 'Naziv tipa motora';

-- Primary key on table sif.motor_tip
ALTER TABLE sif.motor_tip ADD CONSTRAINT mtt_pk PRIMARY KEY (mtt_id);

-- Alternate keys on table sif.motor_tip
ALTER TABLE sif.motor_tip ADD CONSTRAINT mtt_oznaka_uk UNIQUE (mtt_oznaka);
ALTER TABLE sif.motor_tip ADD CONSTRAINT mtt_naziv_uk UNIQUE (mtt_naziv);

COMMIT;
