/* Table sif.motor */
DROP TABLE IF EXISTS sif.motor CASCADE;
-- Table sif.motor
CREATE TABLE sif.motor
(
  mt_id integer NOT NULL,
  mt_cm3 numeric(10, 3) NOT NULL,
  mt_kw numeric(10, 3) NOT NULL,
  mto_id integer NOT NULL,
  mtt_id integer
) WITH (autovacuum_enabled=true);

-- Comments on table sif.motor
COMMENT ON TABLE sif.motor IS 'Motor';
COMMENT ON COLUMN sif.motor.mt_id IS 'ID motora';
COMMENT ON COLUMN sif.motor.mt_cm3 IS 'Zapremina motora';
COMMENT ON COLUMN sif.motor.mt_kw IS 'Snaga motora';
COMMENT ON COLUMN sif.motor.mto_id IS 'ID oznake motora';
COMMENT ON COLUMN sif.motor.mtt_id IS 'ID tipa motora';

-- Indexes on table sif.motor
CREATE UNIQUE INDEX mt_uk1_i ON sif.motor (mto_id, mt_cm3, mt_kw);
CREATE INDEX mt_mtt_fk_i ON sif.motor (mtt_id);
CREATE INDEX mt_mto_fk_i ON sif.motor (mto_id);

-- Primary key on table sif.motor
ALTER TABLE sif.motor ADD CONSTRAINT mt_pk PRIMARY KEY (mt_id);

-- Foreign keys on table sif.motor
ALTER TABLE sif.motor ADD CONSTRAINT mt_mtt_fk FOREIGN KEY (mtt_id) REFERENCES sif.motor_tip (mtt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.motor ADD CONSTRAINT mt_mto_fk FOREIGN KEY (mto_id) REFERENCES sif.motor_oznaka (mto_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
