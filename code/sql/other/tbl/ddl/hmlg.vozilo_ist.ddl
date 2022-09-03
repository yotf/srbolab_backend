/* Table hmlg.vozilo_ist */
DROP TABLE IF EXISTS hmlg.vozilo_ist CASCADE;
-- Table hmlg.vozilo_ist
CREATE TABLE hmlg.vozilo_ist
(
  vz_id integer NOT NULL,
  vz_sasija character varying(30) NOT NULL,
  vz_godina integer,
  vz_reg character varying(10),
  vz_br_osovina integer,
  vz_br_tockovi integer,
  vz_mesta_sedenje integer,
  vz_mesta_stajanje integer,
  vz_masa integer,
  vz_nosivost integer,
  vz_masa_max integer,
  vz_duzina integer,
  vz_sirina integer,
  vz_visina integer,
  vz_kuka character(1) DEFAULT 'N' CHECK (vz_kuka IN ('D', 'N')),
  vz_km integer,
  vz_max_brzina integer,
  vz_kw_kg numeric(20, 2),
  vz_motor character varying(30),
  vz_co2 numeric(20, 2),
  vz_elektro character(1) DEFAULT 'N' CHECK (vz_elektro IN ('D', 'N')),
  vz_vreme timestamp DEFAULT current_timestamp NOT NULL,
  mr_id integer,
  em_id integer,
  gr_id integer,
  md_id integer,
  mdt_id integer,
  mdvr_id integer,
  mdvz_id integer,
  vzv_id integer,
  vzpv_id integer,
  vzk_id integer,
  kr_id integer
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vozilo_ist
COMMENT ON TABLE hmlg.vozilo_ist IS 'Istorijat vozila';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_sasija IS 'Broj šasije';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_godina IS 'Godina proizvodnje';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_reg IS 'Registarska oznaka vozila';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_br_osovina IS 'Broj osovina';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_br_tockovi IS 'Broj točkova';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_mesta_sedenje IS 'Broj mesta za sedenje';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_mesta_stajanje IS 'Broj mesta za stajanje';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_masa IS 'Masa vozila spremnog za vožnju';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_nosivost IS 'Nosivost';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_masa_max IS 'Najveća dozvoljena masa';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_duzina IS 'Dužina';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_sirina IS 'Širina';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_visina IS 'Visina';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_kuka IS 'Ima kuku za vuču?';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_km IS 'Kilometraža (pređeni kilometri)';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_max_brzina IS 'Maksimalna brzina';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_kw_kg IS 'Odnos snage i mase';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_motor IS 'Broj motora';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_co2 IS 'Emisija CO2';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_elektro IS 'Ima elektro pogon?';
COMMENT ON COLUMN hmlg.vozilo_ist.vz_vreme IS 'Vreme promene';
COMMENT ON COLUMN hmlg.vozilo_ist.mr_id IS 'ID marke';
COMMENT ON COLUMN hmlg.vozilo_ist.em_id IS 'ID emisije';
COMMENT ON COLUMN hmlg.vozilo_ist.gr_id IS 'ID vrste goriva';
COMMENT ON COLUMN hmlg.vozilo_ist.md_id IS 'ID modela';
COMMENT ON COLUMN hmlg.vozilo_ist.mdt_id IS 'ID tipa modela';
COMMENT ON COLUMN hmlg.vozilo_ist.mdvr_id IS 'ID varijante modela';
COMMENT ON COLUMN hmlg.vozilo_ist.mdvz_id IS 'ID verzije modela';
COMMENT ON COLUMN hmlg.vozilo_ist.vzv_id IS 'ID vrste vozila';
COMMENT ON COLUMN hmlg.vozilo_ist.vzpv_id IS 'ID podvrste vozila';
COMMENT ON COLUMN hmlg.vozilo_ist.vzk_id IS 'ID karoserije';
COMMENT ON COLUMN hmlg.vozilo_ist.kr_id IS 'ID korisnika';

-- Primary key on table hmlg.vozilo_ist
ALTER TABLE hmlg.vozilo_ist ADD CONSTRAINT vzi_pk PRIMARY KEY (vz_id, vz_vreme);

-- Alternate keys on table hmlg.vozilo_ist
ALTER TABLE hmlg.vozilo_ist ADD CONSTRAINT vzi_vz_sasija_uk UNIQUE (vz_sasija, vz_vreme);

-- Foreign keys on table hmlg.vozilo_ist
ALTER TABLE hmlg.vozilo_ist ADD CONSTRAINT vzi_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
