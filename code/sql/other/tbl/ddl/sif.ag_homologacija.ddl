/* Table sif.ag_homologacija */
DROP TABLE IF EXISTS sif.ag_homologacija CASCADE;
-- Table sif.ag_homologacija
CREATE TABLE sif.ag_homologacija
(
  agh_id integer NOT NULL,
  agh_oznaka character varying(60) NOT NULL,
  agu_id integer
) WITH (autovacuum_enabled=true);

-- Comments on table sif.ag_homologacija
COMMENT ON TABLE sif.ag_homologacija IS 'Homologacije za uređaj';
COMMENT ON COLUMN sif.ag_homologacija.agh_id IS 'ID homologacije';
COMMENT ON COLUMN sif.ag_homologacija.agh_oznaka IS 'Oznaka homologacije';
COMMENT ON COLUMN sif.ag_homologacija.agu_id IS 'ID dela gasnog uređaja';

-- Indexes on table sif.ag_homologacija
CREATE UNIQUE INDEX agh_oznaka_uk_i ON sif.ag_homologacija (REPLACE(agh_oznaka, ' ', ''));
CREATE INDEX agh_agu_fk_i ON sif.ag_homologacija (agu_id);

-- Primary key on table sif.ag_homologacija
ALTER TABLE sif.ag_homologacija ADD CONSTRAINT agh_pk PRIMARY KEY (agh_id);

-- Alternate keys on table sif.ag_homologacija
ALTER TABLE sif.ag_homologacija ADD CONSTRAINT agh_oznaka_uk UNIQUE (agh_oznaka);

-- Foreign keys on table sif.ag_homologacija
ALTER TABLE sif.ag_homologacija ADD CONSTRAINT agh_agu_fk FOREIGN KEY (agu_id) REFERENCES sif.ag_uredjaj (agu_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
