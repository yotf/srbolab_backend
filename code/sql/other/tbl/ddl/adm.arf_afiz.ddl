/* Table adm.arf_afiz */
DROP TABLE IF EXISTS adm.arf_afiz CASCADE;
-- Table adm.arf_afiz
CREATE TABLE adm.arf_afiz
(
  arl_id integer NOT NULL,
  afo_id integer NOT NULL,
  aiz_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table adm.arf_afiz
COMMENT ON TABLE adm.arf_afiz IS 'Izveštaji za rolu';

-- Primary key on table adm.arf_afiz
ALTER TABLE adm.arf_afiz ADD CONSTRAINT arf_afiz_pk PRIMARY KEY (arl_id, afo_id, aiz_id);

-- Foreign keys on table adm.arf_afiz
ALTER TABLE adm.arf_afiz ADD CONSTRAINT arfiz_arf FOREIGN KEY (arl_id, afo_id) REFERENCES adm.arl_afo (arl_id, afo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.arf_afiz ADD CONSTRAINT arfiz_aiz FOREIGN KEY (afo_id, aiz_id) REFERENCES adm.adm_forma_izvestaj (afo_id, aiz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
