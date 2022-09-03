/* Table hmlg.predmet */
DROP TABLE IF EXISTS hmlg.predmet CASCADE;
-- Table hmlg.predmet
CREATE TABLE hmlg.predmet
(
  pr_id integer NOT NULL,
  pr_broj character varying(10) NOT NULL,
  pr_datum date DEFAULT current_date NOT NULL,
  pr_datum_zak date DEFAULT current_date,
  pr_napomena character varying(4000),
  pr_primedbe character varying(4000),
  pr_zakljucak character varying(4000),
  pr_vreme timestamp DEFAULT current_timestamp NOT NULL,
  prs_id integer NOT NULL,
  kl_id integer NOT NULL,
  vz_id integer,
  kr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.predmet
COMMENT ON TABLE hmlg.predmet IS 'Predmeti';
COMMENT ON COLUMN hmlg.predmet.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_broj IS 'Broj predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_datum IS 'Datum otvaranja predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_datum_zak IS 'Datum zaključenja predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_napomena IS 'Napomena predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_primedbe IS 'Primedbe predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_zakljucak IS 'Zaključak predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_vreme IS 'Vreme izmene predmeta';
COMMENT ON COLUMN hmlg.predmet.prs_id IS 'ID statusa predmeta';
COMMENT ON COLUMN hmlg.predmet.kl_id IS 'ID klijenta';
COMMENT ON COLUMN hmlg.predmet.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.predmet.kr_id IS 'ID korisnika';

-- Indexes on table hmlg.predmet
CREATE INDEX pr_kr_fk_i ON hmlg.predmet (kr_id);
CREATE INDEX pr_kl_fk_i ON hmlg.predmet (kl_id);
CREATE INDEX pr_vz_fk_i ON hmlg.predmet (vz_id);
CREATE INDEX pr_prs_fk_i ON hmlg.predmet (prs_id);

-- Primary key on table hmlg.predmet
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_pk PRIMARY KEY (pr_id);

-- Alternate keys on table hmlg.predmet
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_broj_uk UNIQUE (pr_broj);

-- Foreign keys on table hmlg.predmet
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_kl_fk FOREIGN KEY (kl_id) REFERENCES hmlg.klijent (kl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_prs_fk FOREIGN KEY (prs_id) REFERENCES hmlg.predmet_status (prs_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
