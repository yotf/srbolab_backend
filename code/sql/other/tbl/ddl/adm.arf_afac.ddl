/* Table adm.arf_afac */
DROP TABLE IF EXISTS adm.arf_afac CASCADE;
-- Table adm.arf_afac
CREATE TABLE adm.arf_afac
(
  arl_id integer NOT NULL,
  afo_id integer NOT NULL,
  aac_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table adm.arf_afac
COMMENT ON TABLE adm.arf_afac IS 'Akcije za rolu';

-- Primary key on table adm.arf_afac
ALTER TABLE adm.arf_afac ADD CONSTRAINT arf_afac_pk PRIMARY KEY (arl_id, afo_id, aac_id);

-- Foreign keys on table adm.arf_afac
ALTER TABLE adm.arf_afac ADD CONSTRAINT arfac_arf FOREIGN KEY (arl_id, afo_id) REFERENCES adm.arl_afo (arl_id, afo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.arf_afac ADD CONSTRAINT arfac_afac FOREIGN KEY (afo_id, aac_id) REFERENCES adm.adm_forma_akcija (afo_id, aac_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
