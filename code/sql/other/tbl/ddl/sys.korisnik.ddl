/* Table sys.korisnik */
DROP TABLE IF EXISTS sys.korisnik CASCADE;
-- Table sys.korisnik
CREATE TABLE sys.korisnik
(
  kr_id integer NOT NULL,
  kr_prezime character varying(20) NOT NULL,
  kr_ime character varying(20) NOT NULL,
  kr_username character varying(20) NOT NULL,
  kr_password character varying(300) NOT NULL,
  kr_aktivan character(1) DEFAULT 'D' NOT NULL CHECK (kr_aktivan IN ('D', 'N')),
  arl_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sys.korisnik
COMMENT ON TABLE sys.korisnik IS 'Korisnici sistema';
COMMENT ON COLUMN sys.korisnik.kr_id IS 'ID korisnika';
COMMENT ON COLUMN sys.korisnik.kr_prezime IS 'Prezime korisnika';
COMMENT ON COLUMN sys.korisnik.kr_ime IS 'Ime korisnika';
COMMENT ON COLUMN sys.korisnik.kr_username IS 'Korisničko ime korisnika';
COMMENT ON COLUMN sys.korisnik.kr_password IS 'Lozinka korisnika';
COMMENT ON COLUMN sys.korisnik.kr_aktivan IS 'Korisnik je aktivan?';
COMMENT ON COLUMN sys.korisnik.arl_id IS 'ID role';

-- Indexes on table sys.korisnik
CREATE INDEX kr_arl_fk_i ON sys.korisnik (arl_id);

-- Primary key on table sys.korisnik
ALTER TABLE sys.korisnik ADD CONSTRAINT kr_pk PRIMARY KEY (kr_id);

-- Alternate keys on table sys.korisnik
ALTER TABLE sys.korisnik ADD CONSTRAINT kr_username_uk UNIQUE (kr_username);
ALTER TABLE sys.korisnik ADD CONSTRAINT kr_password_uk UNIQUE (kr_password);

-- Foreign keys on table sys.korisnik
ALTER TABLE sys.korisnik ADD CONSTRAINT kr_arl_fk FOREIGN KEY (arl_id) REFERENCES adm.adm_rola (arl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
