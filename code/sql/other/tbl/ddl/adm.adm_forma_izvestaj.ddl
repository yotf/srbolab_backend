/* Table adm.adm_forma_izvestaj */
DROP TABLE IF EXISTS adm.adm_forma_izvestaj CASCADE;
-- Table adm.adm_forma_izvestaj
CREATE TABLE adm.adm_forma_izvestaj
(
  afo_id integer NOT NULL,
  aiz_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table adm.adm_forma_izvestaj
COMMENT ON TABLE adm.adm_forma_izvestaj IS 'Izveštaji za formu';

-- Primary key on table adm.adm_forma_izvestaj
ALTER TABLE adm.adm_forma_izvestaj ADD CONSTRAINT afi_pk PRIMARY KEY (afo_id, aiz_id);

-- Foreign keys on table adm.adm_forma_izvestaj
ALTER TABLE adm.adm_forma_izvestaj ADD CONSTRAINT afi_afo FOREIGN KEY (afo_id) REFERENCES adm.adm_forma (afo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.adm_forma_izvestaj ADD CONSTRAINT afi_aiz FOREIGN KEY (aiz_id) REFERENCES adm.adm_izvestaji (aiz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
