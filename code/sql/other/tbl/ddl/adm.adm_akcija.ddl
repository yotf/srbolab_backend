/* Table adm.adm_akcija */
DROP TABLE IF EXISTS adm.adm_akcija CASCADE;
-- Table adm.adm_akcija
CREATE TABLE adm.adm_akcija
(
  aac_id integer NOT NULL,
  aac_oznaka character varying(10) NOT NULL,
  aac_naziv character varying(50),
  aac_tip character(1) CHECK (aac_tip IN ('V', 'I', 'U', 'D', 'C', 'O'))
) WITH (autovacuum_enabled=true);

-- Comments on table adm.adm_akcija
COMMENT ON TABLE adm.adm_akcija IS 'Akcije forme';
COMMENT ON COLUMN adm.adm_akcija.aac_id IS 'ID akcije';
COMMENT ON COLUMN adm.adm_akcija.aac_oznaka IS 'Oznaka akcije';
COMMENT ON COLUMN adm.adm_akcija.aac_naziv IS 'Naziv akcije';
COMMENT ON COLUMN adm.adm_akcija.aac_tip IS 'Tip akcije';

-- Primary key on table adm.adm_akcija
ALTER TABLE adm.adm_akcija ADD CONSTRAINT aac_pk PRIMARY KEY (aac_id);

-- Alternate keys on table adm.adm_akcija
ALTER TABLE adm.adm_akcija ADD CONSTRAINT aac_oznaka_uk UNIQUE (aac_oznaka);

COMMIT;
