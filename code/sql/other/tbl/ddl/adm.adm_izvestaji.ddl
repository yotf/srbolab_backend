/* Table adm.adm_izvestaji */
DROP TABLE IF EXISTS adm.adm_izvestaji CASCADE;
-- Table adm.adm_izvestaji
CREATE TABLE adm.adm_izvestaji
(
  aiz_id integer NOT NULL,
  aiz_naziv character varying(50) NOT NULL,
  aiz_report character varying(50) NOT NULL,
  aiz_parametri character varying(100)
) WITH (autovacuum_enabled=true);

-- Comments on table adm.adm_izvestaji
COMMENT ON TABLE adm.adm_izvestaji IS 'Izveštaji';
COMMENT ON COLUMN adm.adm_izvestaji.aiz_id IS 'ID izveštaja';
COMMENT ON COLUMN adm.adm_izvestaji.aiz_naziv IS 'Naziv  izveštaja';
COMMENT ON COLUMN adm.adm_izvestaji.aiz_report IS '.jasper fajl izveštaja';
COMMENT ON COLUMN adm.adm_izvestaji.aiz_parametri IS 'Parametri izveštaja';

-- Primary key on table adm.adm_izvestaji
ALTER TABLE adm.adm_izvestaji ADD CONSTRAINT aiz_pk PRIMARY KEY (aiz_id);

COMMIT;
