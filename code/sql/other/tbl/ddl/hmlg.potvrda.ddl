/* Table hmlg.potvrda */
DROP TABLE IF EXISTS hmlg.potvrda CASCADE;
-- Table hmlg.potvrda
CREATE TABLE hmlg.potvrda
(
  pot_id integer NOT NULL,
  pot_broj character varying(10) NOT NULL,
  pot_datum date DEFAULT current_date NOT NULL,
  pot_vreme timestamp DEFAULT current_timestamp NOT NULL,
  pr_id integer NOT NULL,
  lk_id integer,
  kr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.potvrda
COMMENT ON TABLE hmlg.potvrda IS 'Potvrde o tehničkim karakteristikama vozila';
COMMENT ON COLUMN hmlg.potvrda.pot_id IS 'ID potvrde';
COMMENT ON COLUMN hmlg.potvrda.pot_broj IS 'Broj potvrde';
COMMENT ON COLUMN hmlg.potvrda.pot_datum IS 'Datum potvrde';
COMMENT ON COLUMN hmlg.potvrda.pot_vreme IS 'Vreme kreiranja potvrde';
COMMENT ON COLUMN hmlg.potvrda.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.potvrda.lk_id IS 'ID lokacije';
COMMENT ON COLUMN hmlg.potvrda.kr_id IS 'ID korisnika';

-- Indexes on table hmlg.potvrda
CREATE UNIQUE INDEX pot_pr_fk_i ON hmlg.potvrda (pr_id);
CREATE INDEX pot_lk_fk_i ON hmlg.potvrda (lk_id);
CREATE INDEX pot_kr_fk_i ON hmlg.potvrda (kr_id);

-- Primary key on table hmlg.potvrda
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_pk PRIMARY KEY (pot_id);

-- Alternate keys on table hmlg.potvrda
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_uk2 UNIQUE (pr_id);
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_uk1 UNIQUE (pot_broj);

-- Foreign keys on table hmlg.potvrda
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_lk_fk FOREIGN KEY (lk_id) REFERENCES sys.lokacija (lk_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
