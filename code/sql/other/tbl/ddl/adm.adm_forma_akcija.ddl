/* Table adm.adm_forma_akcija */
DROP TABLE IF EXISTS adm.adm_forma_akcija CASCADE;
-- Table adm.adm_forma_akcija
CREATE TABLE adm.adm_forma_akcija
(
  afo_id integer NOT NULL,
  aac_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table adm.adm_forma_akcija
COMMENT ON TABLE adm.adm_forma_akcija IS 'Akcije za formu';

-- Primary key on table adm.adm_forma_akcija
ALTER TABLE adm.adm_forma_akcija ADD CONSTRAINT afa_pk PRIMARY KEY (afo_id, aac_id);

-- Foreign keys on table adm.adm_forma_akcija
ALTER TABLE adm.adm_forma_akcija ADD CONSTRAINT afa_afo_fk FOREIGN KEY (afo_id) REFERENCES adm.adm_forma (afo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.adm_forma_akcija ADD CONSTRAINT afa_aac_fk FOREIGN KEY (aac_id) REFERENCES adm.adm_akcija (aac_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
