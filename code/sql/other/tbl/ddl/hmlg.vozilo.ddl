/* Table hmlg.vozilo */
DROP TABLE IF EXISTS hmlg.vozilo CASCADE;
-- Table hmlg.vozilo
CREATE TABLE hmlg.vozilo
(
  vz_id integer NOT NULL,
  vz_sasija character varying(30) NOT NULL,
  vz_godina integer DEFAULT 0 CHECK (vz_godina>=0),
  vz_reg character varying(10),
  vz_mesta_sedenje integer DEFAULT 0 CHECK (vz_mesta_sedenje>=0),
  vz_mesta_stajanje integer DEFAULT 0 CHECK (vz_mesta_stajanje>=0),
  vz_masa integer DEFAULT 0 CHECK (vz_masa>=0),
  vz_nosivost integer DEFAULT 0 CHECK (vz_nosivost>=0),
  vz_masa_max integer DEFAULT 0 CHECK (vz_masa_max>=0),
  vz_duzina integer DEFAULT 0 CHECK (vz_duzina>=0),
  vz_sirina integer DEFAULT 0 CHECK (vz_sirina>=0),
  vz_visina integer DEFAULT 0 CHECK (vz_visina>=0),
  vz_kuka character(1) DEFAULT 'N' CHECK (vz_kuka IN ('D', 'N')),
  vz_kuka_sert character varying(50),
  vz_km integer DEFAULT 0 CHECK (vz_km>=0),
  vz_max_brzina integer DEFAULT 0 CHECK (vz_max_brzina>=0),
  vz_kw_kg numeric(20, 2),
  vz_motor character varying(30),
  vz_co2 numeric(10, 3),
  vz_elektro character(1) DEFAULT 'N' CHECK (vz_elektro IN ('D', 'N')),
  vz_sert_hmlg_tip character varying(50),
  vz_sert_emisija character varying(50),
  vz_sert_buka character varying(50),
  vz_vreme timestamp DEFAULT current_timestamp NOT NULL,
  mr_id integer,
  md_id integer,
  vzpv_id integer,
  vzkl_id integer,
  em_id integer,
  gr_id integer,
  mdt_id integer,
  mdvr_id integer,
  mdvz_id integer,
  mt_id integer,
  kr_id integer NOT NULL,
  vzs_id integer
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vozilo
COMMENT ON TABLE hmlg.vozilo IS 'Vozila';
COMMENT ON COLUMN hmlg.vozilo.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo.vz_sasija IS 'Broj šasije';
COMMENT ON COLUMN hmlg.vozilo.vz_godina IS 'Godina proizvodnje';
COMMENT ON COLUMN hmlg.vozilo.vz_reg IS 'Registarska oznaka vozila';
COMMENT ON COLUMN hmlg.vozilo.vz_mesta_sedenje IS 'Broj mesta za sedenje';
COMMENT ON COLUMN hmlg.vozilo.vz_mesta_stajanje IS 'Broj mesta za stajanje';
COMMENT ON COLUMN hmlg.vozilo.vz_masa IS 'Masa vozila spremnog za vožnju';
COMMENT ON COLUMN hmlg.vozilo.vz_nosivost IS 'Nosivost';
COMMENT ON COLUMN hmlg.vozilo.vz_masa_max IS 'Najveća dozvoljena masa';
COMMENT ON COLUMN hmlg.vozilo.vz_duzina IS 'Dužina';
COMMENT ON COLUMN hmlg.vozilo.vz_sirina IS 'Širina';
COMMENT ON COLUMN hmlg.vozilo.vz_visina IS 'Visina';
COMMENT ON COLUMN hmlg.vozilo.vz_kuka IS 'Ima kuku za vuču?';
COMMENT ON COLUMN hmlg.vozilo.vz_kuka_sert IS 'Sertifikat vučnog uređaja';
COMMENT ON COLUMN hmlg.vozilo.vz_km IS 'Kilometraža (pređeni kilometri)';
COMMENT ON COLUMN hmlg.vozilo.vz_max_brzina IS 'Maksimalna brzina';
COMMENT ON COLUMN hmlg.vozilo.vz_kw_kg IS 'Odnos snage i mase';
COMMENT ON COLUMN hmlg.vozilo.vz_motor IS 'Broj motora';
COMMENT ON COLUMN hmlg.vozilo.vz_co2 IS 'Emisija CO2';
COMMENT ON COLUMN hmlg.vozilo.vz_elektro IS 'Ima elektro pogon?';
COMMENT ON COLUMN hmlg.vozilo.vz_sert_hmlg_tip IS 'Broj sertifikata homologacije tipa vozila';
COMMENT ON COLUMN hmlg.vozilo.vz_sert_emisija IS 'Broj sertifikata za izduvnu emisiju';
COMMENT ON COLUMN hmlg.vozilo.vz_sert_buka IS 'Broj sertifikata za buku';
COMMENT ON COLUMN hmlg.vozilo.vz_vreme IS 'Vreme promene';
COMMENT ON COLUMN hmlg.vozilo.mr_id IS 'ID marke';
COMMENT ON COLUMN hmlg.vozilo.md_id IS 'ID modela';
COMMENT ON COLUMN hmlg.vozilo.vzpv_id IS 'ID kategorije vozila';
COMMENT ON COLUMN hmlg.vozilo.vzkl_id IS 'ID klase vozila';
COMMENT ON COLUMN hmlg.vozilo.em_id IS 'ID emisije';
COMMENT ON COLUMN hmlg.vozilo.gr_id IS 'ID goriva';
COMMENT ON COLUMN hmlg.vozilo.mdt_id IS 'ID tipa modela';
COMMENT ON COLUMN hmlg.vozilo.mdvr_id IS 'ID varijante modela';
COMMENT ON COLUMN hmlg.vozilo.mdvz_id IS 'ID verzije modela';
COMMENT ON COLUMN hmlg.vozilo.mt_id IS 'ID motora';
COMMENT ON COLUMN hmlg.vozilo.kr_id IS 'ID korisnika';
COMMENT ON COLUMN hmlg.vozilo.vzs_id IS 'ID sertifikovanog vozila';

-- Indexes on table hmlg.vozilo
CREATE INDEX vz_em_fk_i ON hmlg.vozilo (em_id);
CREATE INDEX vz_mr_fk_i ON hmlg.vozilo (mr_id);
CREATE INDEX vz_md_fk_i ON hmlg.vozilo (md_id, mr_id);
CREATE INDEX vz_mdt_fk_i ON hmlg.vozilo (mdt_id);
CREATE INDEX vz_mdvr_fk_i ON hmlg.vozilo (mdvr_id);
CREATE INDEX vz_mdvz_fk_i ON hmlg.vozilo (mdvz_id);
CREATE INDEX vz_kr_fk_i ON hmlg.vozilo (kr_id);
CREATE INDEX vz_mt_fk_i ON hmlg.vozilo (mt_id);
CREATE INDEX vz_gr_fk_i ON hmlg.vozilo (gr_id);
CREATE INDEX vz_vzkl_fk_i ON hmlg.vozilo (vzkl_id);
CREATE INDEX vz_vzpv_fk_i ON hmlg.vozilo (vzpv_id);
CREATE INDEX IX_vz_vzs_fk ON hmlg.vozilo (vzs_id);

-- Primary key on table hmlg.vozilo
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_pk PRIMARY KEY (vz_id);

-- Alternate keys on table hmlg.vozilo
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_sasija_uk UNIQUE (vz_sasija);

-- Foreign keys on table hmlg.vozilo
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_em_fk FOREIGN KEY (em_id) REFERENCES sif.emisija (em_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_mr_fk FOREIGN KEY (mr_id) REFERENCES sif.marka (mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_md_fk FOREIGN KEY (md_id, mr_id) REFERENCES sif.model (md_id, mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_mdt_fk FOREIGN KEY (mdt_id) REFERENCES sif.model_tip (mdt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_mdvr_fk FOREIGN KEY (mdvr_id) REFERENCES sif.model_varijanta (mdvr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_mdvz_fk FOREIGN KEY (mdvz_id) REFERENCES sif.model_verzija (mdvz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_mt_fk FOREIGN KEY (mt_id) REFERENCES sif.motor (mt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_gr_fk FOREIGN KEY (gr_id) REFERENCES sif.gorivo (gr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_vzkl_fk FOREIGN KEY (vzkl_id) REFERENCES sif.vozilo_klasa (vzkl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_vzpv_fk FOREIGN KEY (vzpv_id) REFERENCES sif.vozilo_podvrsta (vzpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_vzs_fk FOREIGN KEY (vzs_id) REFERENCES hmlg.vozilo_sert (vzs_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
