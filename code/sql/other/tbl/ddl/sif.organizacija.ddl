/* Table sif.organizacija */
DROP TABLE IF EXISTS sif.organizacija CASCADE;
-- Table sif.organizacija
CREATE TABLE sif.organizacija
(
  org_id integer NOT NULL,
  org_naziv character varying(200) NOT NULL,
  org_napomena character varying(200)
) WITH (autovacuum_enabled=true);

-- Comments on table sif.organizacija
COMMENT ON TABLE sif.organizacija IS 'Ovlašćene organizacije';
COMMENT ON COLUMN sif.organizacija.org_id IS 'ID organizacije';
COMMENT ON COLUMN sif.organizacija.org_naziv IS 'Naziv organizacije';
COMMENT ON COLUMN sif.organizacija.org_napomena IS 'Napomena za organizaciju';

-- Primary key on table sif.organizacija
ALTER TABLE sif.organizacija ADD CONSTRAINT org_pk PRIMARY KEY (org_id);

-- Alternate keys on table sif.organizacija
ALTER TABLE sif.organizacija ADD CONSTRAINT org_naziv_uk UNIQUE (org_naziv);

COMMIT;
