/* Table sys.kalendar */
DROP TABLE IF EXISTS sys.kalendar CASCADE;
-- Table sys.kalendar
CREATE TABLE sys.kalendar
(
  kn_datum date DEFAULT current_date NOT NULL,
  kn_napomena character varying(200)
) WITH (autovacuum_enabled=true);

-- Comments on table sys.kalendar
COMMENT ON TABLE sys.kalendar IS 'Kalendar';
COMMENT ON COLUMN sys.kalendar.kn_datum IS 'Datum';
COMMENT ON COLUMN sys.kalendar.kn_napomena IS 'Napomena';

-- Primary key on table sys.kalendar
ALTER TABLE sys.kalendar ADD CONSTRAINT kn_pk PRIMARY KEY (kn_datum);

COMMIT;
