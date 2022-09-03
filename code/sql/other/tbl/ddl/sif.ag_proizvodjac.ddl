/* Table sif.ag_proizvodjac */
DROP TABLE IF EXISTS sif.ag_proizvodjac CASCADE;
-- Table sif.ag_proizvodjac
CREATE TABLE sif.ag_proizvodjac
(
  agp_id integer NOT NULL,
  agp_naziv character varying(60) NOT NULL,
  agp_napomena character varying(100)
) WITH (autovacuum_enabled=true);

-- Comments on table sif.ag_proizvodjac
COMMENT ON TABLE sif.ag_proizvodjac IS 'Proizvođači auto-gas opreme';
COMMENT ON COLUMN sif.ag_proizvodjac.agp_id IS 'ID proizvođača';
COMMENT ON COLUMN sif.ag_proizvodjac.agp_naziv IS 'Naziv proizvođača';
COMMENT ON COLUMN sif.ag_proizvodjac.agp_napomena IS 'Napomena za proizvođača';

-- Primary key on table sif.ag_proizvodjac
ALTER TABLE sif.ag_proizvodjac ADD CONSTRAINT agp_pk PRIMARY KEY (agp_id);

-- Alternate keys on table sif.ag_proizvodjac
ALTER TABLE sif.ag_proizvodjac ADD CONSTRAINT agp_naziv_uk UNIQUE (agp_naziv);

COMMIT;
