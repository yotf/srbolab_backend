/* Table hmlg.pr_dok */
DROP TABLE IF EXISTS hmlg.pr_dok CASCADE;
-- Table hmlg.pr_dok
CREATE TABLE hmlg.pr_dok
(
  pr_id integer NOT NULL,
  dok_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.pr_dok
COMMENT ON TABLE hmlg.pr_dok IS 'Dokumenta za predmet';
COMMENT ON COLUMN hmlg.pr_dok.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.pr_dok.dok_id IS 'ID dokumenta';

-- Primary key on table hmlg.pr_dok
ALTER TABLE hmlg.pr_dok ADD CONSTRAINT prd_pk PRIMARY KEY (pr_id, dok_id);

-- Foreign keys on table hmlg.pr_dok
ALTER TABLE hmlg.pr_dok ADD CONSTRAINT prd_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.pr_dok ADD CONSTRAINT prd_dok_fk FOREIGN KEY (dok_id) REFERENCES sif.dokument (dok_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
