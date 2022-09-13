/* Table hmlg.predmet_fajl */
DROP TABLE IF EXISTS hmlg.predmet_fajl CASCADE;
-- Table hmlg.predmet_fajl
CREATE TABLE hmlg.predmet_fajl
(
  pr_id integer NOT NULL,
  prf_id integer NOT NULL,
  prf_dir character varying(200) NOT NULL,
  prf_file character varying(60) NOT NULL,
  prf_ext character varying(10) NOT NULL,
  prd_id integer
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.predmet_fajl
COMMENT ON TABLE hmlg.predmet_fajl IS 'Fajlovi za predmet';
COMMENT ON COLUMN hmlg.predmet_fajl.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.predmet_fajl.prf_id IS 'ID fajla predmeta';
COMMENT ON COLUMN hmlg.predmet_fajl.prf_dir IS 'Direktorijum sa fajlovima';
COMMENT ON COLUMN hmlg.predmet_fajl.prf_file IS 'Naziv fajl';
COMMENT ON COLUMN hmlg.predmet_fajl.prf_ext IS 'Ekstenzija (tip) fajl';

-- Indexes on table hmlg.predmet_fajl
CREATE INDEX prf_prd_fk_i ON hmlg.predmet_fajl (prd_id);

-- Primary key on table hmlg.predmet_fajl
ALTER TABLE hmlg.predmet_fajl ADD CONSTRAINT prf_pk PRIMARY KEY (pr_id, prf_id);

-- Foreign keys on table hmlg.predmet_fajl
ALTER TABLE hmlg.predmet_fajl ADD CONSTRAINT prf_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet_fajl ADD CONSTRAINT prs_prd_fk FOREIGN KEY (prd_id) REFERENCES sif.predmet_dokument (prd_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
