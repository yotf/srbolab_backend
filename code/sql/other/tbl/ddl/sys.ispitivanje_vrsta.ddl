/* Table sys.ispitivanje_vrsta */
DROP TABLE IF EXISTS sys.ispitivanje_vrsta CASCADE;
-- Table sys.ispitivanje_vrsta
CREATE TABLE sys.ispitivanje_vrsta
(
  isv_id integer NOT NULL,
  isv_naziv character varying(100) NOT NULL,
  isv_napomena character varying(1000),
  isv_zakljucak character varying(1000)
) WITH (autovacuum_enabled=true);

-- Comments on table sys.ispitivanje_vrsta
COMMENT ON TABLE sys.ispitivanje_vrsta IS 'Vrste ispitivanja';
COMMENT ON COLUMN sys.ispitivanje_vrsta.isv_id IS 'ID vrste ispitivanja';
COMMENT ON COLUMN sys.ispitivanje_vrsta.isv_naziv IS 'Naziv vrste ispitivanja';
COMMENT ON COLUMN sys.ispitivanje_vrsta.isv_napomena IS 'Napomena vrste ispitivanja';
COMMENT ON COLUMN sys.ispitivanje_vrsta.isv_zakljucak IS 'Zaključak vrste ispitivanja';

-- Primary key on table sys.ispitivanje_vrsta
ALTER TABLE sys.ispitivanje_vrsta ADD CONSTRAINT isv_pk PRIMARY KEY (isv_id);

COMMIT;
