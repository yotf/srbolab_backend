/* Table adm.adm_log_akcija */
DROP TABLE IF EXISTS adm.adm_log_akcija CASCADE;
-- Table adm.adm_log_akcija
CREATE TABLE adm.adm_log_akcija
(
  ala_vreme timestamp DEFAULT current_timestamp NOT NULL,
  ala_tabela character varying(50) NOT NULL,
  ala_akcija character varying(10) NOT NULL,
  ala_red_old text,
  ala_red_new text,
  kr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table adm.adm_log_akcija
COMMENT ON TABLE adm.adm_log_akcija IS 'Log akcija';
COMMENT ON COLUMN adm.adm_log_akcija.ala_vreme IS 'Vreme akcija';
COMMENT ON COLUMN adm.adm_log_akcija.ala_tabela IS 'Tabela akcije';
COMMENT ON COLUMN adm.adm_log_akcija.ala_akcija IS 'Akcija';
COMMENT ON COLUMN adm.adm_log_akcija.ala_red_old IS 'Stari red tabele';
COMMENT ON COLUMN adm.adm_log_akcija.ala_red_new IS 'Novi red tabele';
COMMENT ON COLUMN adm.adm_log_akcija.kr_id IS 'ID korisnika';

-- Indexes on table adm.adm_log_akcija
CREATE INDEX ala_kr_fk_i ON adm.adm_log_akcija (kr_id);

-- Primary key on table adm.adm_log_akcija
ALTER TABLE adm.adm_log_akcija ADD CONSTRAINT ala_pk PRIMARY KEY (ala_vreme, ala_tabela, ala_akcija);

-- Foreign keys on table adm.adm_log_akcija
ALTER TABLE adm.adm_log_akcija ADD CONSTRAINT ala_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
