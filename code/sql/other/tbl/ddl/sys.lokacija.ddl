/* Table sys.lokacija */
DROP TABLE IF EXISTS sys.lokacija CASCADE;
-- Table sys.lokacija
CREATE TABLE sys.lokacija
(
  lk_id integer NOT NULL,
  lk_naziv character varying(30) NOT NULL,
  lk_naziv_l character varying(30) NOT NULL,
  lk_ip character varying(20) NOT NULL,
  lk_aktivna character(1) DEFAULT 'D' NOT NULL CHECK (lk_aktivna IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

-- Comments on table sys.lokacija
COMMENT ON TABLE sys.lokacija IS 'Lokacije';
COMMENT ON COLUMN sys.lokacija.lk_id IS 'ID lokacije';
COMMENT ON COLUMN sys.lokacija.lk_naziv IS 'Naziv lokacije';
COMMENT ON COLUMN sys.lokacija.lk_naziv_l IS 'Naziv lokacije lokativ';
COMMENT ON COLUMN sys.lokacija.lk_ip IS 'IP adresa lokacije';
COMMENT ON COLUMN sys.lokacija.lk_aktivna IS 'Lokacija je aktivna?';

-- Primary key on table sys.lokacija
ALTER TABLE sys.lokacija ADD CONSTRAINT lk_pk PRIMARY KEY (lk_id);

-- Alternate keys on table sys.lokacija
ALTER TABLE sys.lokacija ADD CONSTRAINT lk_ip_uk UNIQUE (lk_ip);
ALTER TABLE sys.lokacija ADD CONSTRAINT lk_naziv_uk UNIQUE (lk_naziv);

COMMIT;
