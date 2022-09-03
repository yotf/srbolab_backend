/* Table sys.usluga */
DROP TABLE IF EXISTS sys.usluga CASCADE;
-- Table sys.usluga
CREATE TABLE sys.usluga
(
  us_id integer NOT NULL,
  us_oznaka character varying(10) NOT NULL,
  us_naziv character varying(60) NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table sys.usluga
COMMENT ON TABLE sys.usluga IS 'Usluge';
COMMENT ON COLUMN sys.usluga.us_id IS 'ID usluge';
COMMENT ON COLUMN sys.usluga.us_oznaka IS 'Oznaka usluge';
COMMENT ON COLUMN sys.usluga.us_naziv IS 'Naziv usluge';

-- Primary key on table sys.usluga
ALTER TABLE sys.usluga ADD CONSTRAINT us_pk PRIMARY KEY (us_id);

-- Alternate keys on table sys.usluga
ALTER TABLE sys.usluga ADD CONSTRAINT us_naziv_uk UNIQUE (us_naziv);
ALTER TABLE sys.usluga ADD CONSTRAINT us_oznaka_uk UNIQUE (us_oznaka);

COMMIT;
