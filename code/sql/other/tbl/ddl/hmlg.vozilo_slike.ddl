/* Table hmlg.vozilo_slike */
DROP TABLE IF EXISTS hmlg.vozilo_slike CASCADE;
-- Table hmlg.vozilo_slike
CREATE TABLE hmlg.vozilo_slike
(
  pr_id integer NOT NULL,
  vzs_id integer NOT NULL,
  vzs_dir character varying(200) NOT NULL,
  vzs_file character varying(60) NOT NULL,
  vzs_ext character varying(10) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vozilo_slike
COMMENT ON TABLE hmlg.vozilo_slike IS 'Slike vozila';
COMMENT ON COLUMN hmlg.vozilo_slike.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.vozilo_slike.vzs_id IS 'ID slike vozila';
COMMENT ON COLUMN hmlg.vozilo_slike.vzs_dir IS 'Direktorijum sa slikama';
COMMENT ON COLUMN hmlg.vozilo_slike.vzs_file IS 'Naziv fajl sa slikom';
COMMENT ON COLUMN hmlg.vozilo_slike.vzs_ext IS 'Ekstenzija (tip) fajla sa slikom';

-- Primary key on table hmlg.vozilo_slike
ALTER TABLE hmlg.vozilo_slike ADD CONSTRAINT vzs_pk PRIMARY KEY (vzs_id, pr_id);

-- Foreign keys on table hmlg.vozilo_slike
ALTER TABLE hmlg.vozilo_slike ADD CONSTRAINT vzs_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
