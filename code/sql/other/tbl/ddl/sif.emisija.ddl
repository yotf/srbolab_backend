/* Table sif.emisija */
DROP TABLE IF EXISTS sif.emisija CASCADE;
-- Table sif.emisija
CREATE TABLE sif.emisija
(
  em_id integer NOT NULL,
  em_naziv character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.emisija
COMMENT ON TABLE sif.emisija IS 'EURO tip motora';
COMMENT ON COLUMN sif.emisija.em_id IS 'ID emisije';
COMMENT ON COLUMN sif.emisija.em_naziv IS 'Naziv emisije';

-- Primary key on table sif.emisija
ALTER TABLE sif.emisija ADD CONSTRAINT em_pk PRIMARY KEY (em_id);

-- Alternate keys on table sif.emisija
ALTER TABLE sif.emisija ADD CONSTRAINT em_naziv_uk UNIQUE (em_naziv);

COMMIT;
