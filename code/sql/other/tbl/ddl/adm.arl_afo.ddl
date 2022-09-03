/* Table adm.arl_afo */
DROP TABLE IF EXISTS adm.arl_afo CASCADE;
-- Table adm.arl_afo
CREATE TABLE adm.arl_afo
(
  arl_id integer NOT NULL,
  afo_id integer NOT NULL,
  arf_akcije_d character varying(1000) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table adm.arl_afo
COMMENT ON TABLE adm.arl_afo IS 'Forme za rolu';
COMMENT ON COLUMN adm.arl_afo.arl_id IS 'ID role';
COMMENT ON COLUMN adm.arl_afo.afo_id IS 'ID forme';
COMMENT ON COLUMN adm.arl_afo.arf_akcije_d IS 'Dozvoljene akcije za formu';

-- Primary key on table adm.arl_afo
ALTER TABLE adm.arl_afo ADD CONSTRAINT arf_pk PRIMARY KEY (arl_id, afo_id);

-- Foreign keys on table adm.arl_afo
ALTER TABLE adm.arl_afo ADD CONSTRAINT arf_arl_fk FOREIGN KEY (arl_id) REFERENCES adm.adm_rola (arl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.arl_afo ADD CONSTRAINT arf_afo_fk FOREIGN KEY (afo_id) REFERENCES adm.adm_forma (afo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
