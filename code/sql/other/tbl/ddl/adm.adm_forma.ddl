/* Table adm.adm_forma */
DROP TABLE IF EXISTS adm.adm_forma CASCADE;
-- Table adm.adm_forma
CREATE TABLE adm.adm_forma
(
  afo_id integer NOT NULL,
  afo_naziv character varying(30) NOT NULL,
  afo_tabele character varying(4000) NOT NULL,
  afo_izvestaji character varying(4000),
  aap_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table adm.adm_forma
COMMENT ON TABLE adm.adm_forma IS 'Forme';
COMMENT ON COLUMN adm.adm_forma.afo_id IS 'ID forme';
COMMENT ON COLUMN adm.adm_forma.afo_naziv IS 'Naziv forme';
COMMENT ON COLUMN adm.adm_forma.afo_tabele IS 'Tabele forme';
COMMENT ON COLUMN adm.adm_forma.afo_izvestaji IS 'Izveštaji na formi';
COMMENT ON COLUMN adm.adm_forma.aap_id IS 'ID aplikacije';

-- Indexes on table adm.adm_forma
CREATE INDEX afo_aap_fk_i ON adm.adm_forma (aap_id);

-- Primary key on table adm.adm_forma
ALTER TABLE adm.adm_forma ADD CONSTRAINT afo_pk PRIMARY KEY (afo_id);

-- Foreign keys on table adm.adm_forma
ALTER TABLE adm.adm_forma ADD CONSTRAINT afo_aap_fk FOREIGN KEY (aap_id) REFERENCES adm.adm_aplikacija (aap_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
