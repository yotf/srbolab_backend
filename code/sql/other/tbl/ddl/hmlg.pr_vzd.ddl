/* Table hmlg.pr_vzd */
DROP TABLE IF EXISTS hmlg.pr_vzd CASCADE;
-- Table hmlg.pr_vzd
CREATE TABLE hmlg.pr_vzd
(
  pr_id integer NOT NULL,
  vzd_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.pr_vzd
COMMENT ON TABLE hmlg.pr_vzd IS 'Dokumnta za vozilo za predmet';
COMMENT ON COLUMN hmlg.pr_vzd.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.pr_vzd.vzd_id IS 'ID dokumenta';

-- Primary key on table hmlg.pr_vzd
ALTER TABLE hmlg.pr_vzd ADD CONSTRAINT prd_pk PRIMARY KEY (pr_id, vzd_id);

-- Foreign keys on table hmlg.pr_vzd
ALTER TABLE hmlg.pr_vzd ADD CONSTRAINT prd_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.pr_vzd ADD CONSTRAINT prd_dok_fk FOREIGN KEY (vzd_id) REFERENCES sif.vozilo_dokument (vzd_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
