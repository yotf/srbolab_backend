/* Table sys.cena */
DROP TABLE IF EXISTS sys.cena CASCADE;
-- Table sys.cena
CREATE TABLE sys.cena
(
  ck_id integer NOT NULL,
  cn_id integer NOT NULL,
  cn_cena numeric(20, 2) NOT NULL,
  us_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sys.cena
COMMENT ON TABLE sys.cena IS 'Cene';
COMMENT ON COLUMN sys.cena.ck_id IS 'ID cenovnika';
COMMENT ON COLUMN sys.cena.cn_id IS 'ID cene';
COMMENT ON COLUMN sys.cena.cn_cena IS 'Cena';
COMMENT ON COLUMN sys.cena.us_id IS 'ID usluge';

-- Indexes on table sys.cena
CREATE INDEX cn_us_fk_i ON sys.cena (us_id);

-- Primary key on table sys.cena
ALTER TABLE sys.cena ADD CONSTRAINT cn_pk PRIMARY KEY (ck_id, cn_id);

-- Foreign keys on table sys.cena
ALTER TABLE sys.cena ADD CONSTRAINT cn_ck_fk FOREIGN KEY (ck_id) REFERENCES sys.cenovnik (ck_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.cena ADD CONSTRAINT cn_us_fk FOREIGN KEY (us_id) REFERENCES sys.usluga (us_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
