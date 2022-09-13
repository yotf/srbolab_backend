/* Table sys.cenovnik */
DROP TABLE IF EXISTS sys.cenovnik CASCADE;
-- Table sys.cenovnik
CREATE TABLE sys.cenovnik
(
  ck_id integer NOT NULL,
  ck_datum date DEFAULT current_date NOT NULL,
  ck_napomena character varying(100)
) WITH (autovacuum_enabled=true);

-- Comments on table sys.cenovnik
COMMENT ON TABLE sys.cenovnik IS 'Cenovnici';
COMMENT ON COLUMN sys.cenovnik.ck_id IS 'ID cenovnika';
COMMENT ON COLUMN sys.cenovnik.ck_datum IS 'Datum od kada važi cenovnik';
COMMENT ON COLUMN sys.cenovnik.ck_napomena IS 'Napomena za cenovnik';

-- Primary key on table sys.cenovnik
ALTER TABLE sys.cenovnik ADD CONSTRAINT ck_pk PRIMARY KEY (ck_id);

-- Alternate keys on table sys.cenovnik
ALTER TABLE sys.cenovnik ADD CONSTRAINT ck_datum_uk UNIQUE (ck_datum);

COMMIT;
