/* Table adm.adm_log */
DROP TABLE IF EXISTS adm.adm_log CASCADE;
-- Table adm.adm_log
CREATE TABLE adm.adm_log
(
  alg_id character varying(50) NOT NULL,
  alg_ip character varying(20) NOT NULL,
  alg_login timestamp DEFAULT current_timestamp NOT NULL,
  alg_logout timestamp DEFAULT current_timestamp,
  alg_token character varying(4000) NOT NULL,
  kr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table adm.adm_log
COMMENT ON TABLE adm.adm_log IS 'Logovanje korisnika na aplikaciju';
COMMENT ON COLUMN adm.adm_log.alg_id IS 'ID sesije';
COMMENT ON COLUMN adm.adm_log.alg_ip IS 'IP adresa';
COMMENT ON COLUMN adm.adm_log.alg_login IS 'Vreme prijave';
COMMENT ON COLUMN adm.adm_log.alg_logout IS 'Vreme odjave';
COMMENT ON COLUMN adm.adm_log.alg_token IS 'Token';
COMMENT ON COLUMN adm.adm_log.kr_id IS 'ID korisnika';

-- Indexes on table adm.adm_log
CREATE INDEX alg_kr_fk_i ON adm.adm_log (kr_id);

-- Primary key on table adm.adm_log
ALTER TABLE adm.adm_log ADD CONSTRAINT alg_pk PRIMARY KEY (alg_id);

-- Foreign keys on table adm.adm_log
ALTER TABLE adm.adm_log ADD CONSTRAINT alg_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
