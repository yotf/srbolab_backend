/* Table adm.adm_rola */
DROP TABLE IF EXISTS adm.adm_rola CASCADE;
-- Table adm.adm_rola
CREATE TABLE adm.adm_rola
(
  arl_id integer NOT NULL,
  arl_naziv character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table adm.adm_rola
COMMENT ON TABLE adm.adm_rola IS 'Nivo kontrole';
COMMENT ON COLUMN adm.adm_rola.arl_id IS 'ID role';
COMMENT ON COLUMN adm.adm_rola.arl_naziv IS 'Naziv role';

-- Primary key on table adm.adm_rola
ALTER TABLE adm.adm_rola ADD CONSTRAINT arl_pk PRIMARY KEY (arl_id);

COMMIT;
