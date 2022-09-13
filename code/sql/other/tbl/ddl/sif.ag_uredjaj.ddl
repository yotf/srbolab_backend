/* Table sif.ag_uredjaj */
DROP TABLE IF EXISTS sif.ag_uredjaj CASCADE;
-- Table sif.ag_uredjaj
CREATE TABLE sif.ag_uredjaj
(
  agu_id integer NOT NULL,
  agu_oznaka character(2) DEFAULT 'RZ' NOT NULL CHECK (agu_oznaka IN ('MV', 'RD', 'RZ')),
  agu_naziv character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.ag_uredjaj
COMMENT ON TABLE sif.ag_uredjaj IS 'Delovi gasnog uređaja';
COMMENT ON COLUMN sif.ag_uredjaj.agu_id IS 'ID dela gasnog uređaja';
COMMENT ON COLUMN sif.ag_uredjaj.agu_oznaka IS 'Oznaka dela gasnog uređaja';
COMMENT ON COLUMN sif.ag_uredjaj.agu_naziv IS 'Naziv dela gasnog uređaja';

-- Primary key on table sif.ag_uredjaj
ALTER TABLE sif.ag_uredjaj ADD CONSTRAINT agu_pk PRIMARY KEY (agu_id);

-- Alternate keys on table sif.ag_uredjaj
ALTER TABLE sif.ag_uredjaj ADD CONSTRAINT agu_oznaka_uk UNIQUE (agu_oznaka);
ALTER TABLE sif.ag_uredjaj ADD CONSTRAINT agu_naziv_uk UNIQUE (agu_naziv);

COMMIT;
