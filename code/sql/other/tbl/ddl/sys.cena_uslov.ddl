/* Table sys.cena_uslov */
DROP TABLE IF EXISTS sys.cena_uslov CASCADE;
-- Table sys.cena_uslov
CREATE TABLE sys.cena_uslov
(
  ck_id integer NOT NULL,
  cn_id integer NOT NULL,
  cnu_id integer NOT NULL,
  cnu_uslov_opis character varying(60),
  cnu_uslov character varying(100),
  vzv_id integer,
  vzpv_id integer,
  vzk_id integer
) WITH (autovacuum_enabled=true);

-- Comments on table sys.cena_uslov
COMMENT ON TABLE sys.cena_uslov IS 'Uslovi za cenu';
COMMENT ON COLUMN sys.cena_uslov.ck_id IS 'ID cenovnika';
COMMENT ON COLUMN sys.cena_uslov.cn_id IS 'ID cene';
COMMENT ON COLUMN sys.cena_uslov.cnu_id IS 'ID uslova';
COMMENT ON COLUMN sys.cena_uslov.cnu_uslov_opis IS 'Dodatni uslov za cenu (opis)';
COMMENT ON COLUMN sys.cena_uslov.cnu_uslov IS 'Dodatni uslov za cenu';
COMMENT ON COLUMN sys.cena_uslov.vzv_id IS 'ID vrste vozila';
COMMENT ON COLUMN sys.cena_uslov.vzpv_id IS 'ID podvrste vozila';
COMMENT ON COLUMN sys.cena_uslov.vzk_id IS 'ID karoserije';

-- Indexes on table sys.cena_uslov
CREATE INDEX cnu_vzv_fk_i ON sys.cena_uslov (vzv_id);
CREATE INDEX cnu_vzpv_fk_i ON sys.cena_uslov (vzpv_id);
CREATE INDEX cnu_vzk_fk_i ON sys.cena_uslov (vzk_id);
CREATE UNIQUE INDEX cnu_uk1_i ON sys.cena_uslov (ck_id, cn_id, vzv_id, vzpv_id, vzk_id, cnu_uslov);

-- Primary key on table sys.cena_uslov
ALTER TABLE sys.cena_uslov ADD CONSTRAINT cnu_pk PRIMARY KEY (ck_id, cn_id, cnu_id);

-- Foreign keys on table sys.cena_uslov
ALTER TABLE sys.cena_uslov ADD CONSTRAINT cnu_vzv_fk FOREIGN KEY (vzv_id) REFERENCES sif.vozilo_vrsta (vzv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.cena_uslov ADD CONSTRAINT cnu_vzpv_fk FOREIGN KEY (vzpv_id) REFERENCES sif.vozilo_podvrsta (vzpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.cena_uslov ADD CONSTRAINT cnu_vzk_fk FOREIGN KEY (vzk_id) REFERENCES sif.vozilo_karoserija (vzk_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.cena_uslov ADD CONSTRAINT cnu_cn_fk FOREIGN KEY (ck_id, cn_id) REFERENCES sys.cena (ck_id, cn_id) ON DELETE CASCADE ON UPDATE NO ACTION;

COMMIT;
