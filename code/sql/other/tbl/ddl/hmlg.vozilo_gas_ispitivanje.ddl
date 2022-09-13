/* Table hmlg.vozilo_gas_ispitivanje */
DROP TABLE IF EXISTS hmlg.vozilo_gas_ispitivanje CASCADE;
-- Table hmlg.vozilo_gas_ispitivanje
CREATE TABLE hmlg.vozilo_gas_ispitivanje
(
  vz_id integer NOT NULL,
  vzg_id integer NOT NULL,
  vzgi_id integer NOT NULL,
  vzgi_broj character varying(20),
  vzgi_su_broj character varying(50),
  vzgi_su_datum date DEFAULT current_date,
  vzgi_su_rok date DEFAULT current_date,
  vzgi_potvrda_broj character varying(20),
  vzgi_potvrda_datum date DEFAULT current_date,
  vzgi_potvrda_rok date DEFAULT current_date,
  vzgi_zakljucak character varying(4000),
  org_id integer,
  kr_id integer
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vozilo_gas_ispitivanje
COMMENT ON TABLE hmlg.vozilo_gas_ispitivanje IS 'Ispitivanje gasnog uređaja za vozilo';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vzg_id IS 'ID gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vzgi_id IS 'ID ispitivanja gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vzgi_broj IS 'Broj uverenja';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vzgi_su_broj IS 'Broj starog uverenja';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vzgi_su_datum IS 'Datum starog uverenja';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vzgi_su_rok IS 'Datum važenja starog uverenja';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vzgi_potvrda_broj IS 'Broj potvrde';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vzgi_potvrda_datum IS 'Datum potvrde';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vzgi_potvrda_rok IS 'Datum važenja potvrde';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.vzgi_zakljucak IS 'Zaključak ispitivanja';
COMMENT ON COLUMN hmlg.vozilo_gas_ispitivanje.org_id IS 'ID organizacije';

-- Indexes on table hmlg.vozilo_gas_ispitivanje
CREATE INDEX vzgi_org_fk_i ON hmlg.vozilo_gas_ispitivanje (org_id);
CREATE INDEX vzgi_kr_fk_i ON hmlg.vozilo_gas_ispitivanje (kr_id);

-- Primary key on table hmlg.vozilo_gas_ispitivanje
ALTER TABLE hmlg.vozilo_gas_ispitivanje ADD CONSTRAINT vzgi_pk PRIMARY KEY (vz_id, vzg_id, vzgi_id);

-- Foreign keys on table hmlg.vozilo_gas_ispitivanje
ALTER TABLE hmlg.vozilo_gas_ispitivanje ADD CONSTRAINT vzgi_vzg_fk FOREIGN KEY (vz_id, vzg_id) REFERENCES hmlg.vozilo_gas (vz_id, vzg_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gas_ispitivanje ADD CONSTRAINT vzgi_org_fk FOREIGN KEY (org_id) REFERENCES sif.organizacija (org_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gas_ispitivanje ADD CONSTRAINT vzgi_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
