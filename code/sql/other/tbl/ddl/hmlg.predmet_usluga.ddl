/* Table hmlg.predmet_usluga */
DROP TABLE IF EXISTS hmlg.predmet_usluga CASCADE;
-- Table hmlg.predmet_usluga
CREATE TABLE hmlg.predmet_usluga
(
  pr_id integer NOT NULL,
  us_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.predmet_usluga
COMMENT ON TABLE hmlg.predmet_usluga IS 'Usluge za predmet';
COMMENT ON COLUMN hmlg.predmet_usluga.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.predmet_usluga.us_id IS 'ID usluge';

-- Primary key on table hmlg.predmet_usluga
ALTER TABLE hmlg.predmet_usluga ADD CONSTRAINT prus_pk PRIMARY KEY (pr_id, us_id);

-- Foreign keys on table hmlg.predmet_usluga
ALTER TABLE hmlg.predmet_usluga ADD CONSTRAINT prus_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet_usluga ADD CONSTRAINT prus_us_fk FOREIGN KEY (us_id) REFERENCES sys.usluga (us_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
