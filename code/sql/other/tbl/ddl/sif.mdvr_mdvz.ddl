/* Table sif.mdvr_mdvz */
DROP TABLE IF EXISTS sif.mdvr_mdvz CASCADE;
-- Table sif.mdvr_mdvz
CREATE TABLE sif.mdvr_mdvz
(
  mdvr_id integer NOT NULL,
  mdvz_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sif.mdvr_mdvz
COMMENT ON TABLE sif.mdvr_mdvz IS 'Veza varijane i verzije';

-- Primary key on table sif.mdvr_mdvz
ALTER TABLE sif.mdvr_mdvz ADD CONSTRAINT mdvrz_pk PRIMARY KEY (mdvr_id, mdvz_id);

-- Foreign keys on table sif.mdvr_mdvz
ALTER TABLE sif.mdvr_mdvz ADD CONSTRAINT mdvrz_mdvr_fk FOREIGN KEY (mdvr_id) REFERENCES sif.model_varijanta (mdvr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.mdvr_mdvz ADD CONSTRAINT mdvrz_mdvz_fk FOREIGN KEY (mdvz_id) REFERENCES sif.model_verzija (mdvz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
