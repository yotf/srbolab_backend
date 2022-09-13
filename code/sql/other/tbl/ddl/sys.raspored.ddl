/* Table sys.raspored */
DROP TABLE IF EXISTS sys.raspored CASCADE;
-- Table sys.raspored
CREATE TABLE sys.raspored
(
  kn_datum date DEFAULT current_date NOT NULL,
  kr_id integer NOT NULL,
  lk_id integer NOT NULL,
  rs_napomena character varying(300)
) WITH (autovacuum_enabled=true);

-- Comments on table sys.raspored
COMMENT ON TABLE sys.raspored IS 'Raspored rada po lokacijama';
COMMENT ON COLUMN sys.raspored.kn_datum IS 'Datum';
COMMENT ON COLUMN sys.raspored.kr_id IS 'ID korisnika';
COMMENT ON COLUMN sys.raspored.lk_id IS 'ID lokacije';
COMMENT ON COLUMN sys.raspored.rs_napomena IS 'Napomena za raspored';

-- Indexes on table sys.raspored
CREATE INDEX rs_lk_fk_i ON sys.raspored (lk_id);

-- Primary key on table sys.raspored
ALTER TABLE sys.raspored ADD CONSTRAINT rs_pk PRIMARY KEY (kn_datum, kr_id);

-- Foreign keys on table sys.raspored
ALTER TABLE sys.raspored ADD CONSTRAINT rs_kn_fk FOREIGN KEY (kn_datum) REFERENCES sys.kalendar (kn_datum) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sys.raspored ADD CONSTRAINT rs_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.raspored ADD CONSTRAINT rs_lk_fk FOREIGN KEY (lk_id) REFERENCES sys.lokacija (lk_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
