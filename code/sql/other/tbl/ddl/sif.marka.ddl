/* Table sif.marka */
DROP TABLE IF EXISTS sif.marka CASCADE;
-- Table sif.marka
CREATE TABLE sif.marka
(
  mr_id integer NOT NULL,
  mr_naziv character varying(50) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.marka
COMMENT ON TABLE sif.marka IS 'Marka proizvođača vozila';
COMMENT ON COLUMN sif.marka.mr_id IS 'ID marke';
COMMENT ON COLUMN sif.marka.mr_naziv IS 'Naziv marke';

-- Primary key on table sif.marka
ALTER TABLE sif.marka ADD CONSTRAINT mr_pk PRIMARY KEY (mr_id);

-- Alternate keys on table sif.marka
ALTER TABLE sif.marka ADD CONSTRAINT mr_naziv_uk UNIQUE (mr_naziv);

COMMIT;
