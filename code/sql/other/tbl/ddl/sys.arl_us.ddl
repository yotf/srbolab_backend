/* Table sys.arl_us */
DROP TABLE IF EXISTS sys.arl_us CASCADE;
-- Table sys.arl_us
CREATE TABLE sys.arl_us
(
  arl_id integer NOT NULL,
  us_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sys.arl_us
COMMENT ON TABLE sys.arl_us IS 'Usluge za rolu';
COMMENT ON COLUMN sys.arl_us.arl_id IS 'ID role';
COMMENT ON COLUMN sys.arl_us.us_id IS 'ID usluge';

-- Primary key on table sys.arl_us
ALTER TABLE sys.arl_us ADD CONSTRAINT arlus_pk PRIMARY KEY (us_id, arl_id);

-- Foreign keys on table sys.arl_us
ALTER TABLE sys.arl_us ADD CONSTRAINT kr_us_us_fk FOREIGN KEY (us_id) REFERENCES sys.usluga (us_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.arl_us ADD CONSTRAINT arlus_arl_fk FOREIGN KEY (arl_id) REFERENCES adm.adm_rola (arl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
