/* Table adm.adm_aplikacija */
DROP TABLE IF EXISTS adm.adm_aplikacija CASCADE;
-- Table adm.adm_aplikacija
CREATE TABLE adm.adm_aplikacija
(
  aap_id integer NOT NULL,
  aap_naziv character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table adm.adm_aplikacija
COMMENT ON TABLE adm.adm_aplikacija IS 'Aplikacije (grupe formi)';
COMMENT ON COLUMN adm.adm_aplikacija.aap_id IS 'ID aplikacije';
COMMENT ON COLUMN adm.adm_aplikacija.aap_naziv IS 'Naziv aplikacije';

-- Primary key on table adm.adm_aplikacija
ALTER TABLE adm.adm_aplikacija ADD CONSTRAINT aap_pk PRIMARY KEY (aap_id);

COMMIT;
