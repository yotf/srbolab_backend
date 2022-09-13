/* Table sif.mr_oznaka */
DROP TABLE IF EXISTS sif.mr_oznaka CASCADE;
-- Table sif.mr_oznaka
CREATE TABLE sif.mr_oznaka
(
  mro_id integer NOT NULL,
  mro_oznaka character varying(6) NOT NULL,
  mr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.mr_oznaka
COMMENT ON TABLE sif.mr_oznaka IS 'Oznake marke';
COMMENT ON COLUMN sif.mr_oznaka.mro_id IS 'ID oznake marke';
COMMENT ON COLUMN sif.mr_oznaka.mro_oznaka IS 'Oznaka marke';
COMMENT ON COLUMN sif.mr_oznaka.mr_id IS 'ID marke';

-- Indexes on table sif.mr_oznaka
CREATE UNIQUE INDEX mro_uk1_i ON sif.mr_oznaka (mr_id, mro_oznaka);
CREATE INDEX mro_mr_fk_i ON sif.mr_oznaka (mr_id);

-- Primary key on table sif.mr_oznaka
ALTER TABLE sif.mr_oznaka ADD CONSTRAINT mro_pk PRIMARY KEY (mro_id);

-- Foreign keys on table sif.mr_oznaka
ALTER TABLE sif.mr_oznaka ADD CONSTRAINT mro_mr_fk FOREIGN KEY (mr_id) REFERENCES sif.marka (mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
