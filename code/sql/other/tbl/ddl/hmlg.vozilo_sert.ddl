/* Table hmlg.vozilo_sert */
DROP TABLE IF EXISTS hmlg.vozilo_sert CASCADE;
-- Table hmlg.vozilo_sert
CREATE TABLE hmlg.vozilo_sert
(
  vzs_id integer NOT NULL,
  vzs_oznaka character varying(50) NOT NULL,
  vzs_godina integer DEFAULT 0 CHECK (vzs_godina>=0),
  vzs_mesta_sedenje integer DEFAULT 0 CHECK (vzs_mesta_sedenje>=0),
  vzs_mesta_stajanje integer DEFAULT 0 CHECK (vzs_mesta_stajanje>=0),
  vzs_masa integer DEFAULT 0 CHECK (vzs_masa>=0),
  vzs_nosivost integer DEFAULT 0 CHECK (vzs_nosivost>=0),
  vzs_masa_max integer DEFAULT 0 CHECK (vzs_masa_max>=0),
  vzs_duzina integer DEFAULT 0 CHECK (vzs_duzina>=0),
  vzs_sirina integer DEFAULT 0 CHECK (vzs_sirina>=0),
  vzs_visina integer DEFAULT 0 CHECK (vzs_visina>=0),
  vzs_kuka_sert character varying(50),
  vzs_max_brzina integer DEFAULT 0 CHECK (vzs_max_brzina>=0),
  vzs_kw_kg numeric(20, 2),
  vzs_co2 numeric(10, 3),
  vzs_sert_hmlg_tip character varying(50),
  vzs_sert_emisija character varying(50),
  vzs_sert_buka character varying(50),
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
  kr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

-- Comments on table hmlg.vozilo_sert
COMMENT ON TABLE hmlg.vozilo_sert IS 'Vozila';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_id IS 'ID sertifikovanog vozila';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_oznaka IS 'Oznaka sertifikovanog vozila';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_godina IS 'Godina proizvodnje';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_mesta_sedenje IS 'Broj mesta za sedenje';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_mesta_stajanje IS 'Broj mesta za stajanje';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_masa IS 'Masa vozila spremnog za vožnju';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_nosivost IS 'Nosivost';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_masa_max IS 'Najveća dozvoljena masa';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_duzina IS 'Dužina';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_sirina IS 'Širina';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_visina IS 'Visina';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_kuka_sert IS 'Sertifikat vučnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_max_brzina IS 'Maksimalna brzina';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_kw_kg IS 'Odnos snage i mase';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_co2 IS 'Emisija CO2';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_sert_hmlg_tip IS 'Broj sertifikata homologacije tipa vozila';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_sert_emisija IS 'Broj sertifikata za izduvnu emisiju';
COMMENT ON COLUMN hmlg.vozilo_sert.vzs_sert_buka IS 'Broj sertifikata za buku';
COMMENT ON COLUMN hmlg.vozilo_sert.mr_id IS 'ID marke';
COMMENT ON COLUMN hmlg.vozilo_sert.md_id IS 'ID modela';
COMMENT ON COLUMN hmlg.vozilo_sert.vzpv_id IS 'ID kategorije vozila';
COMMENT ON COLUMN hmlg.vozilo_sert.vzkl_id IS 'ID klase vozila';
COMMENT ON COLUMN hmlg.vozilo_sert.em_id IS 'ID emisije';
COMMENT ON COLUMN hmlg.vozilo_sert.gr_id IS 'ID goriva';
COMMENT ON COLUMN hmlg.vozilo_sert.mdt_id IS 'ID tipa modela';
COMMENT ON COLUMN hmlg.vozilo_sert.mdvr_id IS 'ID varijante modela';
COMMENT ON COLUMN hmlg.vozilo_sert.mdvz_id IS 'ID verzije modela';
COMMENT ON COLUMN hmlg.vozilo_sert.mt_id IS 'ID motora';
COMMENT ON COLUMN hmlg.vozilo_sert.kr_id IS 'ID korisnika';

-- Indexes on table hmlg.vozilo_sert
CREATE INDEX vzs_em_fk_i ON hmlg.vozilo_sert (em_id);
CREATE INDEX vzs_mr_fk_i ON hmlg.vozilo_sert (mr_id);
CREATE INDEX vzs_md_fk_i ON hmlg.vozilo_sert (md_id, mr_id);
CREATE INDEX vzs_mdt_fk_i ON hmlg.vozilo_sert (mdt_id);
CREATE INDEX vzs_mdvr_fk_i ON hmlg.vozilo_sert (mdvr_id);
CREATE INDEX vzs_mdvz_fk_i ON hmlg.vozilo_sert (mdvz_id);
CREATE INDEX vzs_kr_fk_i ON hmlg.vozilo_sert (kr_id);
CREATE INDEX vzs_mt_fk_i ON hmlg.vozilo_sert (mt_id);
CREATE INDEX vzs_gr_fk_i ON hmlg.vozilo_sert (gr_id);
CREATE INDEX vzs_vzkl_fk_i ON hmlg.vozilo_sert (vzkl_id);
CREATE INDEX vzs_vzpv_fk_i ON hmlg.vozilo_sert (vzpv_id);

-- Primary key on table hmlg.vozilo_sert
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_pk PRIMARY KEY (vzs_id);

-- Alternate keys on table hmlg.vozilo_sert
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_oznaka_uk UNIQUE (vzs_oznaka);

-- Foreign keys on table hmlg.vozilo_sert
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_mr_fk FOREIGN KEY (mr_id) REFERENCES sif.marka (mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_md_fk FOREIGN KEY (md_id, mr_id) REFERENCES sif.model (md_id, mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_vzpv_fk FOREIGN KEY (vzpv_id) REFERENCES sif.vozilo_podvrsta (vzpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_vzkl_fk FOREIGN KEY (vzkl_id) REFERENCES sif.vozilo_klasa (vzkl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_em_fk FOREIGN KEY (em_id) REFERENCES sif.emisija (em_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_gr_fk FOREIGN KEY (gr_id) REFERENCES sif.gorivo (gr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_mdt_fk FOREIGN KEY (mdt_id) REFERENCES sif.model_tip (mdt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_mdvr_fk FOREIGN KEY (mdvr_id) REFERENCES sif.model_varijanta (mdvr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_mdvz_fk FOREIGN KEY (mdvz_id) REFERENCES sif.model_verzija (mdvz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_mt_fk FOREIGN KEY (mt_id) REFERENCES sif.motor (mt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;

COMMIT;
