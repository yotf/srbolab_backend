/* Table hmlg.predmet_slike */
DROP TABLE IF EXISTS hmlg.predmet_slike CASCADE;
-- Table hmlg.predmet_slike
CREATE TABLE hmlg.predmet_slike
(
  pr_id integer NOT NULL,
  prs_id integer NOT NULL,
  prs_dir character varying(200) NOT NULL,
  prs_file character varying(60) NOT NULL,
  prs_ext character varying(10) NOT NULL,
  prd_id integer
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.predmet_slike
COMMENT ON TABLE hmlg.predmet_slike IS 'Slike za predmet';
COMMENT ON COLUMN hmlg.predmet_slike.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.predmet_slike.prs_id IS 'ID fajla predmeta';
COMMENT ON COLUMN hmlg.predmet_slike.prs_dir IS 'Direktorijum sa fajlovima';
COMMENT ON COLUMN hmlg.predmet_slike.prs_file IS 'Naziv fajl';
COMMENT ON COLUMN hmlg.predmet_slike.prs_ext IS 'Ekstenzija (tip) fajl';

-- Indexes on table hmlg.predmet_slike
CREATE INDEX prs_prd_fk_i ON hmlg.predmet_slike (prd_id);

-- Primary key on table hmlg.predmet_slike
ALTER TABLE hmlg.predmet_slike ADD CONSTRAINT prs_pk PRIMARY KEY (pr_id, prs_id);

-- Foreign keys on table hmlg.predmet_slike
ALTER TABLE hmlg.predmet_slike ADD CONSTRAINT prs_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet_slike ADD CONSTRAINT prs_prd_fk FOREIGN KEY (prd_id) REFERENCES sif.predmet_dokument (prd_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
