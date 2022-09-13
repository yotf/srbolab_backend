/* Table sif.gorivo */
DROP TABLE IF EXISTS sif.gorivo CASCADE;
-- Table sif.gorivo
CREATE TABLE sif.gorivo
(
  gr_id integer NOT NULL,
  gr_naziv character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.gorivo
COMMENT ON TABLE sif.gorivo IS 'Vrste goriva';
COMMENT ON COLUMN sif.gorivo.gr_id IS 'ID vrste goriva';
COMMENT ON COLUMN sif.gorivo.gr_naziv IS 'Naziv vrste goriva';

-- Primary key on table sif.gorivo
ALTER TABLE sif.gorivo ADD CONSTRAINT gr_pk PRIMARY KEY (gr_id);

-- Alternate keys on table sif.gorivo
ALTER TABLE sif.gorivo ADD CONSTRAINT gr_naziv_uk UNIQUE (gr_naziv);

COMMIT;
