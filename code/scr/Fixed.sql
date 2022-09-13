/*
Created: 07.08.2020.
Modified: 23.02.2021.
Project: Homologacija
Model: Homologacija
Version: 5.0
Database: PostgreSQL 10
*/

-- Create tables section -------------------------------------------------

-- Table adm.adm_rola
CREATE TABLE adm.adm_rola
(
  arl_id integer NOT NULL,
  arl_naziv character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.adm_rola IS 'Nivo kontrole';
COMMENT ON COLUMN adm.adm_rola.arl_id IS 'ID role';
COMMENT ON COLUMN adm.adm_rola.arl_naziv IS 'Naziv role';

-- Add keys for table adm.adm_rola
ALTER TABLE adm.adm_rola ADD CONSTRAINT arl_pk PRIMARY KEY (arl_id);

-- Table sys.kalendar
CREATE TABLE sys.kalendar
(
  kn_datum date DEFAULT current_date NOT NULL,
  kn_napomena character varying(200)
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sys.kalendar IS 'Kalendar';
COMMENT ON COLUMN sys.kalendar.kn_datum IS 'Datum';
COMMENT ON COLUMN sys.kalendar.kn_napomena IS 'Napomena';

-- Add keys for table sys.kalendar
ALTER TABLE sys.kalendar ADD CONSTRAINT kn_pk PRIMARY KEY (kn_datum);

-- Table sys.lokacija
CREATE TABLE sys.lokacija
(
  lk_id integer NOT NULL,
  lk_naziv character varying(30) NOT NULL,
  lk_naziv_l character varying(30) NOT NULL,
  lk_ip character varying(20) NOT NULL,
  lk_aktivna character(1) DEFAULT 'D' NOT NULL CHECK (lk_aktivna IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sys.lokacija IS 'Lokacije';
COMMENT ON COLUMN sys.lokacija.lk_id IS 'ID lokacije';
COMMENT ON COLUMN sys.lokacija.lk_naziv IS 'Naziv lokacije';
COMMENT ON COLUMN sys.lokacija.lk_naziv_l IS 'Naziv lokacije lokativ';
COMMENT ON COLUMN sys.lokacija.lk_ip IS 'IP adresa lokacije';
COMMENT ON COLUMN sys.lokacija.lk_aktivna IS 'Lokacija je aktivna?';

-- Add keys for table sys.lokacija
ALTER TABLE sys.lokacija ADD CONSTRAINT lk_pk PRIMARY KEY (lk_id);
ALTER TABLE sys.lokacija ADD CONSTRAINT lk_ip_uk UNIQUE (lk_ip);
ALTER TABLE sys.lokacija ADD CONSTRAINT lk_naziv_uk UNIQUE (lk_naziv);

-- Table hmlg.klijent
CREATE TABLE hmlg.klijent
(
  kl_id integer NOT NULL,
  kl_naziv character varying(100) NOT NULL,
  kl_adresa character varying(100),
  kl_telefon character varying(20),
  kl_firma character(1) DEFAULT 'N' CHECK (kl_firma IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.klijent IS 'Klijenti (podnosioci zahteva)';
COMMENT ON COLUMN hmlg.klijent.kl_id IS 'ID klijenta';
COMMENT ON COLUMN hmlg.klijent.kl_naziv IS 'Naziv klijenta';
COMMENT ON COLUMN hmlg.klijent.kl_adresa IS 'Adresa klijenta';
COMMENT ON COLUMN hmlg.klijent.kl_telefon IS 'Telefon kontakta';
COMMENT ON COLUMN hmlg.klijent.kl_firma IS 'Klijent je pravno lice?';

-- Add keys for table hmlg.klijent
ALTER TABLE hmlg.klijent ADD CONSTRAINT kl_pk PRIMARY KEY (kl_id);

-- Table hmlg.predmet
CREATE TABLE hmlg.predmet
(
  pr_id integer NOT NULL,
  pr_broj character varying(10) NOT NULL,
  pr_datum date DEFAULT current_date NOT NULL,
  pr_datum_zak date DEFAULT current_date,
  pr_napomena character varying(4000),
  pr_primedbe character varying(4000),
  pr_zakljucak character varying(4000),
  pr_vreme timestamp DEFAULT current_timestamp NOT NULL,
  prs_id integer NOT NULL,
  kl_id integer NOT NULL,
  vz_id integer,
  kr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.predmet IS 'Predmeti';
COMMENT ON COLUMN hmlg.predmet.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_broj IS 'Broj predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_datum IS 'Datum otvaranja predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_datum_zak IS 'Datum zaključenja predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_napomena IS 'Napomena predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_primedbe IS 'Primedbe predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_zakljucak IS 'Zaključak predmeta';
COMMENT ON COLUMN hmlg.predmet.pr_vreme IS 'Vreme izmene predmeta';
COMMENT ON COLUMN hmlg.predmet.prs_id IS 'ID statusa predmeta';
COMMENT ON COLUMN hmlg.predmet.kl_id IS 'ID klijenta';
COMMENT ON COLUMN hmlg.predmet.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.predmet.kr_id IS 'ID korisnika';

-- Create indexes for table hmlg.predmet
CREATE INDEX pr_kr_fk_i ON hmlg.predmet (kr_id);
CREATE INDEX pr_kl_fk_i ON hmlg.predmet (kl_id);
CREATE INDEX pr_vz_fk_i ON hmlg.predmet (vz_id);
CREATE INDEX pr_prs_fk_i ON hmlg.predmet (prs_id);

-- Add keys for table hmlg.predmet
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_pk PRIMARY KEY (pr_id);
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_broj_uk UNIQUE (pr_broj);

-- Table sif.gorivo
CREATE TABLE sif.gorivo
(
  gr_id integer NOT NULL,
  gr_naziv character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.gorivo IS 'Vrste goriva';
COMMENT ON COLUMN sif.gorivo.gr_id IS 'ID vrste goriva';
COMMENT ON COLUMN sif.gorivo.gr_naziv IS 'Naziv vrste goriva';

-- Add keys for table sif.gorivo
ALTER TABLE sif.gorivo ADD CONSTRAINT gr_pk PRIMARY KEY (gr_id);
ALTER TABLE sif.gorivo ADD CONSTRAINT gr_naziv_uk UNIQUE (gr_naziv);

-- Table sif.emisija
CREATE TABLE sif.emisija
(
  em_id integer NOT NULL,
  em_naziv character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.emisija IS 'EURO tip motora';
COMMENT ON COLUMN sif.emisija.em_id IS 'ID emisije';
COMMENT ON COLUMN sif.emisija.em_naziv IS 'Naziv emisije';

-- Add keys for table sif.emisija
ALTER TABLE sif.emisija ADD CONSTRAINT em_pk PRIMARY KEY (em_id);
ALTER TABLE sif.emisija ADD CONSTRAINT em_naziv_uk UNIQUE (em_naziv);

-- Table sif.organizacija
CREATE TABLE sif.organizacija
(
  org_id integer NOT NULL,
  org_naziv character varying(200) NOT NULL,
  org_napomena character varying(200)
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.organizacija IS 'Ovlašćene organizacije';
COMMENT ON COLUMN sif.organizacija.org_id IS 'ID organizacije';
COMMENT ON COLUMN sif.organizacija.org_naziv IS 'Naziv organizacije';
COMMENT ON COLUMN sif.organizacija.org_napomena IS 'Napomena za organizaciju';

-- Add keys for table sif.organizacija
ALTER TABLE sif.organizacija ADD CONSTRAINT org_pk PRIMARY KEY (org_id);
ALTER TABLE sif.organizacija ADD CONSTRAINT org_naziv_uk UNIQUE (org_naziv);

-- Table sif.vozilo_vrsta
CREATE TABLE sif.vozilo_vrsta
(
  vzv_id integer NOT NULL,
  vzv_oznaka character varying(10) NOT NULL,
  vzv_naziv character varying(100) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.vozilo_vrsta IS 'Vrste vozila';
COMMENT ON COLUMN sif.vozilo_vrsta.vzv_id IS 'ID vrste vozila';
COMMENT ON COLUMN sif.vozilo_vrsta.vzv_oznaka IS 'Oznaka vrste vozila';
COMMENT ON COLUMN sif.vozilo_vrsta.vzv_naziv IS 'Naziv vrste vozila';

-- Add keys for table sif.vozilo_vrsta
ALTER TABLE sif.vozilo_vrsta ADD CONSTRAINT vzv_pk PRIMARY KEY (vzv_id);
ALTER TABLE sif.vozilo_vrsta ADD CONSTRAINT vzv_oznaka_uk UNIQUE (vzv_oznaka);

-- Table sif.vozilo_karoserija
CREATE TABLE sif.vozilo_karoserija
(
  vzk_id integer NOT NULL,
  vzk_oznaka character varying(10) NOT NULL,
  vzk_naziv character varying(100)
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.vozilo_karoserija IS 'Vrste karoserije vozila';
COMMENT ON COLUMN sif.vozilo_karoserija.vzk_id IS 'ID vrste karoserije';
COMMENT ON COLUMN sif.vozilo_karoserija.vzk_oznaka IS 'Oznaka vrste karoserije';
COMMENT ON COLUMN sif.vozilo_karoserija.vzk_naziv IS 'Naziv vrste karoserije';

-- Add keys for table sif.vozilo_karoserija
ALTER TABLE sif.vozilo_karoserija ADD CONSTRAINT vzk_pk PRIMARY KEY (vzk_id);

-- Table sif.vozilo_klasa
CREATE TABLE sif.vozilo_klasa
(
  vzkl_id integer NOT NULL,
  vzkl_oznaka character varying(10) NOT NULL,
  vzkl_naziv character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.vozilo_klasa IS 'Klase vozila';
COMMENT ON COLUMN sif.vozilo_klasa.vzkl_id IS 'ID klase vozila';
COMMENT ON COLUMN sif.vozilo_klasa.vzkl_oznaka IS 'Oznaka klase vozila';
COMMENT ON COLUMN sif.vozilo_klasa.vzkl_naziv IS 'Naziv klase vozila';

-- Add keys for table sif.vozilo_klasa
ALTER TABLE sif.vozilo_klasa ADD CONSTRAINT vzkl_pk PRIMARY KEY (vzkl_id);
ALTER TABLE sif.vozilo_klasa ADD CONSTRAINT vzkl_oznaka_uk UNIQUE (vzkl_oznaka);

-- Table sif.vozilo_dod_oznaka
CREATE TABLE sif.vozilo_dod_oznaka
(
  vzdo_id integer NOT NULL,
  vzdo_oznaka character varying(10) NOT NULL,
  vzdo_oznaka1 character varying(10),
  vzdo_naziv character varying(100)
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.vozilo_dod_oznaka IS 'Dodatna oznaka vozila';
COMMENT ON COLUMN sif.vozilo_dod_oznaka.vzdo_id IS 'ID dodatne oznake';
COMMENT ON COLUMN sif.vozilo_dod_oznaka.vzdo_oznaka IS 'Dodatna oznaka';
COMMENT ON COLUMN sif.vozilo_dod_oznaka.vzdo_oznaka1 IS 'Dodatna oznaka1';
COMMENT ON COLUMN sif.vozilo_dod_oznaka.vzdo_naziv IS 'Naziv dodatne oznake';

-- Create indexes for table sif.vozilo_dod_oznaka

CREATE UNIQUE INDEX vzdo_uk1 ON sif.vozilo_dod_oznaka (vzdo_oznaka, vzdo_oznaka1);

-- Add keys for table sif.vozilo_dod_oznaka
ALTER TABLE sif.vozilo_dod_oznaka ADD CONSTRAINT vzdo_pk PRIMARY KEY (vzdo_id);

-- Table sif.ag_proizvodjac
CREATE TABLE sif.ag_proizvodjac
(
  agp_id integer NOT NULL,
  agp_naziv character varying(60) NOT NULL,
  agp_napomena character varying(100)
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.ag_proizvodjac IS 'Proizvođači auto-gas opreme';
COMMENT ON COLUMN sif.ag_proizvodjac.agp_id IS 'ID proizvođača';
COMMENT ON COLUMN sif.ag_proizvodjac.agp_naziv IS 'Naziv proizvođača';
COMMENT ON COLUMN sif.ag_proizvodjac.agp_napomena IS 'Napomena za proizvođača';

-- Add keys for table sif.ag_proizvodjac
ALTER TABLE sif.ag_proizvodjac ADD CONSTRAINT agp_pk PRIMARY KEY (agp_id);
ALTER TABLE sif.ag_proizvodjac ADD CONSTRAINT agp_naziv_uk UNIQUE (agp_naziv);

-- Table sif.ag_homologacija
CREATE TABLE sif.ag_homologacija
(
  agh_id integer NOT NULL,
  agh_oznaka character varying(60) NOT NULL,
  agu_id integer
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.ag_homologacija IS 'Homologacije za uređaj';
COMMENT ON COLUMN sif.ag_homologacija.agh_id IS 'ID homologacije';
COMMENT ON COLUMN sif.ag_homologacija.agh_oznaka IS 'Oznaka homologacije';
COMMENT ON COLUMN sif.ag_homologacija.agu_id IS 'ID dela gasnog uređaja';

-- Create indexes for table sif.ag_homologacija

CREATE UNIQUE INDEX agh_oznaka_uk_i ON sif.ag_homologacija (REPLACE(agh_oznaka, ' ', ''));
CREATE INDEX agh_agu_fk_i ON sif.ag_homologacija (agu_id);

-- Add keys for table sif.ag_homologacija
ALTER TABLE sif.ag_homologacija ADD CONSTRAINT agh_pk PRIMARY KEY (agh_id);
ALTER TABLE sif.ag_homologacija ADD CONSTRAINT agh_oznaka_uk UNIQUE (agh_oznaka);

-- Table sys.ispitivanje_vrsta
CREATE TABLE sys.ispitivanje_vrsta
(
  isv_id integer NOT NULL,
  isv_naziv character varying(100) NOT NULL,
  isv_napomena character varying(1000),
  isv_zakljucak character varying(1000)
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sys.ispitivanje_vrsta IS 'Vrste ispitivanja';
COMMENT ON COLUMN sys.ispitivanje_vrsta.isv_id IS 'ID vrste ispitivanja';
COMMENT ON COLUMN sys.ispitivanje_vrsta.isv_naziv IS 'Naziv vrste ispitivanja';
COMMENT ON COLUMN sys.ispitivanje_vrsta.isv_napomena IS 'Napomena vrste ispitivanja';
COMMENT ON COLUMN sys.ispitivanje_vrsta.isv_zakljucak IS 'Zaključak vrste ispitivanja';

-- Add keys for table sys.ispitivanje_vrsta
ALTER TABLE sys.ispitivanje_vrsta ADD CONSTRAINT isv_pk PRIMARY KEY (isv_id);

-- Table sif.marka
CREATE TABLE sif.marka
(
  mr_id integer NOT NULL,
  mr_naziv character varying(50) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.marka IS 'Marka proizvođača vozila';
COMMENT ON COLUMN sif.marka.mr_id IS 'ID marke';
COMMENT ON COLUMN sif.marka.mr_naziv IS 'Naziv marke';

-- Add keys for table sif.marka
ALTER TABLE sif.marka ADD CONSTRAINT mr_pk PRIMARY KEY (mr_id);
ALTER TABLE sif.marka ADD CONSTRAINT mr_naziv_uk UNIQUE (mr_naziv);

-- Table sys.korisnik
CREATE TABLE sys.korisnik
(
  kr_id integer NOT NULL,
  kr_prezime character varying(20) NOT NULL,
  kr_ime character varying(20) NOT NULL,
  kr_username character varying(20) NOT NULL,
  kr_password character varying(300) NOT NULL,
  kr_aktivan character(1) DEFAULT 'D' NOT NULL CHECK (kr_aktivan IN ('D', 'N')),
  arl_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sys.korisnik IS 'Korisnici sistema';
COMMENT ON COLUMN sys.korisnik.kr_id IS 'ID korisnika';
COMMENT ON COLUMN sys.korisnik.kr_prezime IS 'Prezime korisnika';
COMMENT ON COLUMN sys.korisnik.kr_ime IS 'Ime korisnika';
COMMENT ON COLUMN sys.korisnik.kr_username IS 'Korisničko ime korisnika';
COMMENT ON COLUMN sys.korisnik.kr_password IS 'Lozinka korisnika';
COMMENT ON COLUMN sys.korisnik.kr_aktivan IS 'Korisnik je aktivan?';
COMMENT ON COLUMN sys.korisnik.arl_id IS 'ID role';

-- Create indexes for table sys.korisnik
CREATE INDEX kr_arl_fk_i ON sys.korisnik (arl_id);

-- Add keys for table sys.korisnik
ALTER TABLE sys.korisnik ADD CONSTRAINT kr_pk PRIMARY KEY (kr_id);
ALTER TABLE sys.korisnik ADD CONSTRAINT kr_username_uk UNIQUE (kr_username);
ALTER TABLE sys.korisnik ADD CONSTRAINT kr_password_uk UNIQUE (kr_password);

-- Table sys.raspored
CREATE TABLE sys.raspored
(
  kn_datum date DEFAULT current_date NOT NULL,
  kr_id integer NOT NULL,
  lk_id integer NOT NULL,
  rs_napomena character varying(300)
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sys.raspored IS 'Raspored rada po lokacijama';
COMMENT ON COLUMN sys.raspored.kn_datum IS 'Datum';
COMMENT ON COLUMN sys.raspored.kr_id IS 'ID korisnika';
COMMENT ON COLUMN sys.raspored.lk_id IS 'ID lokacije';
COMMENT ON COLUMN sys.raspored.rs_napomena IS 'Napomena za raspored';

-- Create indexes for table sys.raspored
CREATE INDEX rs_lk_fk_i ON sys.raspored (lk_id);

-- Add keys for table sys.raspored
ALTER TABLE sys.raspored ADD CONSTRAINT rs_pk PRIMARY KEY (kn_datum, kr_id);

-- Table sif.vozilo_podvrsta
CREATE TABLE sif.vozilo_podvrsta
(
  vzpv_id integer NOT NULL,
  vzpv_oznaka character varying(10) NOT NULL,
  vzpv_naziv character varying(100) NOT NULL,
  vzv_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.vozilo_podvrsta IS 'Kategorije vozila';
COMMENT ON COLUMN sif.vozilo_podvrsta.vzpv_id IS 'ID kategorije vozila';
COMMENT ON COLUMN sif.vozilo_podvrsta.vzpv_oznaka IS 'Oznaka kategorije vozila';
COMMENT ON COLUMN sif.vozilo_podvrsta.vzpv_naziv IS 'Naziv kategorije vozila';
COMMENT ON COLUMN sif.vozilo_podvrsta.vzv_id IS 'ID vrste vozila';

-- Create indexes for table sif.vozilo_podvrsta
CREATE INDEX vzpv_vzv_fk_i ON sif.vozilo_podvrsta (vzv_id);

-- Add keys for table sif.vozilo_podvrsta
ALTER TABLE sif.vozilo_podvrsta ADD CONSTRAINT vzpv_pk PRIMARY KEY (vzpv_id);
ALTER TABLE sif.vozilo_podvrsta ADD CONSTRAINT vzpv_oznaka_uk UNIQUE (vzpv_oznaka);

-- Table sif.agp_agh
CREATE TABLE sif.agp_agh
(
  agp_id integer NOT NULL,
  agh_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.agp_agh IS 'Homologacije za proizvođača';
COMMENT ON COLUMN sif.agp_agh.agp_id IS 'ID proizvođača';
COMMENT ON COLUMN sif.agp_agh.agh_id IS 'ID homologacije';

-- Add keys for table sif.agp_agh
ALTER TABLE sif.agp_agh ADD CONSTRAINT agph_pk PRIMARY KEY (agp_id, agh_id);

-- Table sif.model
CREATE TABLE sif.model
(
  mr_id integer NOT NULL,
  md_id integer NOT NULL,
  md_naziv_k character varying(50) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.model IS 'Model';
COMMENT ON COLUMN sif.model.mr_id IS 'ID marke';
COMMENT ON COLUMN sif.model.md_id IS 'ID modela';
COMMENT ON COLUMN sif.model.md_naziv_k IS 'Komercijalni naziv modela';

-- Create indexes for table sif.model

CREATE UNIQUE INDEX md_uk1_i ON sif.model (mr_id, md_naziv_k);

-- Add keys for table sif.model
ALTER TABLE sif.model ADD CONSTRAINT md_pk PRIMARY KEY (md_id, mr_id);

-- Table sif.motor
CREATE TABLE sif.motor
(
  mt_id integer NOT NULL,
  mt_cm3 numeric(10, 3) NOT NULL,
  mt_kw numeric(10, 3) NOT NULL,
  mto_id integer NOT NULL,
  mtt_id integer
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.motor IS 'Motor';
COMMENT ON COLUMN sif.motor.mt_id IS 'ID motora';
COMMENT ON COLUMN sif.motor.mt_cm3 IS 'Zapremina motora';
COMMENT ON COLUMN sif.motor.mt_kw IS 'Snaga motora';
COMMENT ON COLUMN sif.motor.mto_id IS 'ID oznake motora';
COMMENT ON COLUMN sif.motor.mtt_id IS 'ID tipa motora';

-- Create indexes for table sif.motor

CREATE UNIQUE INDEX mt_uk1_i ON sif.motor (mto_id, mt_cm3, mt_kw);
CREATE INDEX mt_mtt_fk_i ON sif.motor (mtt_id);
CREATE INDEX mt_mto_fk_i ON sif.motor (mto_id);

-- Add keys for table sif.motor
ALTER TABLE sif.motor ADD CONSTRAINT mt_pk PRIMARY KEY (mt_id);

-- Table sif.model_tip
CREATE TABLE sif.model_tip
(
  mdt_id integer NOT NULL,
  mdt_oznaka character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.model_tip IS 'Tip modela';
COMMENT ON COLUMN sif.model_tip.mdt_id IS 'ID tipa modela';
COMMENT ON COLUMN sif.model_tip.mdt_oznaka IS 'Oznaka tipa modela';

-- Add keys for table sif.model_tip
ALTER TABLE sif.model_tip ADD CONSTRAINT mdt_pk PRIMARY KEY (mdt_id);
ALTER TABLE sif.model_tip ADD CONSTRAINT mdt_oznaka_uk UNIQUE (mdt_oznaka);

-- Table sif.vzk_vzpv
CREATE TABLE sif.vzk_vzpv
(
  vzk_id integer NOT NULL,
  vzpv_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.vzk_vzpv IS 'Veza karoserije i kategorije vozila';
COMMENT ON COLUMN sif.vzk_vzpv.vzk_id IS 'ID vrste karoserije';
COMMENT ON COLUMN sif.vzk_vzpv.vzpv_id IS 'ID podvrste vozila';

-- Add keys for table sif.vzk_vzpv
ALTER TABLE sif.vzk_vzpv ADD CONSTRAINT vkvpv_pk PRIMARY KEY (vzk_id, vzpv_id);

-- Table sif.vzkl_vzpv
CREATE TABLE sif.vzkl_vzpv
(
  vzkl_id integer NOT NULL,
  vzpv_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.vzkl_vzpv IS 'Veza klase vozila i kategorije vozila';
COMMENT ON COLUMN sif.vzkl_vzpv.vzkl_id IS 'ID klase vozila';
COMMENT ON COLUMN sif.vzkl_vzpv.vzpv_id IS 'ID kategorije vozila';

-- Create indexes for table sif.vzkl_vzpv
CREATE INDEX vzklpv_vzpv_fk_i ON sif.vzkl_vzpv (vzkl_id);
CREATE INDEX vzklpv_vzkl_fk_i ON sif.vzkl_vzpv (vzpv_id);

-- Add keys for table sif.vzkl_vzpv
ALTER TABLE sif.vzkl_vzpv ADD CONSTRAINT vzklpv_pk PRIMARY KEY (vzkl_id, vzpv_id);

-- Table sif.vzdo_vzv
CREATE TABLE sif.vzdo_vzv
(
  vzdo_id integer NOT NULL,
  vzv_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.vzdo_vzv IS 'Veza dodatne oznake i vrste vozila';
COMMENT ON COLUMN sif.vzdo_vzv.vzdo_id IS 'ID dodatne oznake';
COMMENT ON COLUMN sif.vzdo_vzv.vzv_id IS 'ID vrste vozila';

-- Create indexes for table sif.vzdo_vzv
CREATE INDEX vzdov_vzv_fk_i ON sif.vzdo_vzv (vzv_id);

-- Add keys for table sif.vzdo_vzv
ALTER TABLE sif.vzdo_vzv ADD CONSTRAINT vzdov_pk PRIMARY KEY (vzdo_id, vzv_id);

-- Table sif.model_varijanta
CREATE TABLE sif.model_varijanta
(
  mdvr_id integer NOT NULL,
  mdvr_oznaka character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.model_varijanta IS 'Varijanta modela';
COMMENT ON COLUMN sif.model_varijanta.mdvr_id IS 'ID varijante modela';
COMMENT ON COLUMN sif.model_varijanta.mdvr_oznaka IS 'Oznaka varijante modela';

-- Add keys for table sif.model_varijanta
ALTER TABLE sif.model_varijanta ADD CONSTRAINT mdvr_pk PRIMARY KEY (mdvr_id);
ALTER TABLE sif.model_varijanta ADD CONSTRAINT mdvr_oznaka_uk UNIQUE (mdvr_oznaka);

-- Table sif.model_verzija
CREATE TABLE sif.model_verzija
(
  mdvz_id integer NOT NULL,
  mdvz_oznaka character varying(50) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.model_verzija IS 'Verzija modela';
COMMENT ON COLUMN sif.model_verzija.mdvz_id IS 'ID verzije modela';
COMMENT ON COLUMN sif.model_verzija.mdvz_oznaka IS 'Oznaka verzije modela';

-- Add keys for table sif.model_verzija
ALTER TABLE sif.model_verzija ADD CONSTRAINT mdvz_pk PRIMARY KEY (mdvz_id);
ALTER TABLE sif.model_verzija ADD CONSTRAINT mdvz_oznaka_uk UNIQUE (mdvz_oznaka);

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

-- Create indexes for table hmlg.vozilo
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

-- Add keys for table hmlg.vozilo
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_pk PRIMARY KEY (vz_id);
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_sasija_uk UNIQUE (vz_sasija);

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

-- Create indexes for table hmlg.vozilo_sert
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

-- Add keys for table hmlg.vozilo_sert
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_pk PRIMARY KEY (vzs_id);
ALTER TABLE hmlg.vozilo_sert ADD CONSTRAINT vzs_oznaka_uk UNIQUE (vzs_oznaka);

-- Table hmlg.vozilo_osovina
CREATE TABLE hmlg.vozilo_osovina
(
  vz_id integer NOT NULL,
  vzo_rb integer NOT NULL,
  vzo_nosivost integer DEFAULT 0 NOT NULL CHECK (vzo_nosivost>=0),
  vzo_tockova integer DEFAULT 0 NOT NULL CHECK (vzo_tockova>=0),
  vzo_pneumatik character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.vozilo_osovina IS 'Osovine vozila';
COMMENT ON COLUMN hmlg.vozilo_osovina.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo_osovina.vzo_rb IS 'Redni broj osovine';
COMMENT ON COLUMN hmlg.vozilo_osovina.vzo_nosivost IS 'Nosivost osovine';
COMMENT ON COLUMN hmlg.vozilo_osovina.vzo_tockova IS 'Broj točkova na osovini';
COMMENT ON COLUMN hmlg.vozilo_osovina.vzo_pneumatik IS 'Pneumatici za osovinu';

-- Add keys for table hmlg.vozilo_osovina
ALTER TABLE hmlg.vozilo_osovina ADD CONSTRAINT vzo_pk PRIMARY KEY (vzo_rb, vz_id);

-- Table hmlg.vozilo_s_osovina
CREATE TABLE hmlg.vozilo_s_osovina
(
  vzs_id integer NOT NULL,
  vzos_rb integer NOT NULL,
  vzos_nosivost integer DEFAULT 0 NOT NULL CHECK (vzos_nosivost>=0),
  vzos_tockova integer DEFAULT 0 NOT NULL CHECK (vzos_tockova>=0),
  vzos_pneumatik character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.vozilo_s_osovina IS 'Osovine vozila';
COMMENT ON COLUMN hmlg.vozilo_s_osovina.vzs_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo_s_osovina.vzos_rb IS 'Redni broj osovine';
COMMENT ON COLUMN hmlg.vozilo_s_osovina.vzos_nosivost IS 'Nosivost osovine';
COMMENT ON COLUMN hmlg.vozilo_s_osovina.vzos_tockova IS 'Broj točkova na osovini';
COMMENT ON COLUMN hmlg.vozilo_s_osovina.vzos_pneumatik IS 'Pneumatici za osovinu';

-- Add keys for table hmlg.vozilo_s_osovina
ALTER TABLE hmlg.vozilo_s_osovina ADD CONSTRAINT vzos_pk PRIMARY KEY (vzos_rb, vzs_id);

-- Table adm.adm_aplikacija
CREATE TABLE adm.adm_aplikacija
(
  aap_id integer NOT NULL,
  aap_naziv character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.adm_aplikacija IS 'Aplikacije (grupe formi)';
COMMENT ON COLUMN adm.adm_aplikacija.aap_id IS 'ID aplikacije';
COMMENT ON COLUMN adm.adm_aplikacija.aap_naziv IS 'Naziv aplikacije';

-- Add keys for table adm.adm_aplikacija
ALTER TABLE adm.adm_aplikacija ADD CONSTRAINT aap_pk PRIMARY KEY (aap_id);

-- Table adm.adm_forma
CREATE TABLE adm.adm_forma
(
  afo_id integer NOT NULL,
  afo_naziv character varying(30) NOT NULL,
  afo_tabele character varying(4000) NOT NULL,
  afo_izvestaji character varying(4000),
  aap_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.adm_forma IS 'Forme';
COMMENT ON COLUMN adm.adm_forma.afo_id IS 'ID forme';
COMMENT ON COLUMN adm.adm_forma.afo_naziv IS 'Naziv forme';
COMMENT ON COLUMN adm.adm_forma.afo_tabele IS 'Tabele forme';
COMMENT ON COLUMN adm.adm_forma.afo_izvestaji IS 'Izveštaji na formi';
COMMENT ON COLUMN adm.adm_forma.aap_id IS 'ID aplikacije';

-- Create indexes for table adm.adm_forma
CREATE INDEX afo_aap_fk_i ON adm.adm_forma (aap_id);

-- Add keys for table adm.adm_forma
ALTER TABLE adm.adm_forma ADD CONSTRAINT afo_pk PRIMARY KEY (afo_id);

-- Table adm.arl_afo
CREATE TABLE adm.arl_afo
(
  arl_id integer NOT NULL,
  afo_id integer NOT NULL,
  arf_akcije_d character varying(1000) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.arl_afo IS 'Forme za rolu';
COMMENT ON COLUMN adm.arl_afo.arl_id IS 'ID role';
COMMENT ON COLUMN adm.arl_afo.afo_id IS 'ID forme';
COMMENT ON COLUMN adm.arl_afo.arf_akcije_d IS 'Dozvoljene akcije za formu';

-- Add keys for table adm.arl_afo
ALTER TABLE adm.arl_afo ADD CONSTRAINT arf_pk PRIMARY KEY (arl_id, afo_id);

-- Table sys.usluga
CREATE TABLE sys.usluga
(
  us_id integer NOT NULL,
  us_oznaka character varying(10) NOT NULL,
  us_naziv character varying(60) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sys.usluga IS 'Usluge';
COMMENT ON COLUMN sys.usluga.us_id IS 'ID usluge';
COMMENT ON COLUMN sys.usluga.us_oznaka IS 'Oznaka usluge';
COMMENT ON COLUMN sys.usluga.us_naziv IS 'Naziv usluge';

-- Add keys for table sys.usluga
ALTER TABLE sys.usluga ADD CONSTRAINT us_pk PRIMARY KEY (us_id);
ALTER TABLE sys.usluga ADD CONSTRAINT us_naziv_uk UNIQUE (us_naziv);
ALTER TABLE sys.usluga ADD CONSTRAINT us_oznaka_uk UNIQUE (us_oznaka);

-- Table sys.cenovnik
CREATE TABLE sys.cenovnik
(
  ck_id integer NOT NULL,
  ck_datum date DEFAULT current_date NOT NULL,
  ck_napomena character varying(100)
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sys.cenovnik IS 'Cenovnici';
COMMENT ON COLUMN sys.cenovnik.ck_id IS 'ID cenovnika';
COMMENT ON COLUMN sys.cenovnik.ck_datum IS 'Datum od kada važi cenovnik';
COMMENT ON COLUMN sys.cenovnik.ck_napomena IS 'Napomena za cenovnik';

-- Add keys for table sys.cenovnik
ALTER TABLE sys.cenovnik ADD CONSTRAINT ck_pk PRIMARY KEY (ck_id);
ALTER TABLE sys.cenovnik ADD CONSTRAINT ck_datum_uk UNIQUE (ck_datum);

-- Table sys.cena_uslov
CREATE TABLE sys.cena_uslov
(
  ck_id integer NOT NULL,
  cn_id integer NOT NULL,
  cnu_id integer NOT NULL,
  cnu_uslov_opis character varying(60),
  cnu_uslov character varying(100),
  vzv_id integer,
  vzpv_id integer,
  vzk_id integer
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sys.cena_uslov IS 'Uslovi za cenu';
COMMENT ON COLUMN sys.cena_uslov.ck_id IS 'ID cenovnika';
COMMENT ON COLUMN sys.cena_uslov.cn_id IS 'ID cene';
COMMENT ON COLUMN sys.cena_uslov.cnu_id IS 'ID uslova';
COMMENT ON COLUMN sys.cena_uslov.cnu_uslov_opis IS 'Dodatni uslov za cenu (opis)';
COMMENT ON COLUMN sys.cena_uslov.cnu_uslov IS 'Dodatni uslov za cenu';
COMMENT ON COLUMN sys.cena_uslov.vzv_id IS 'ID vrste vozila';
COMMENT ON COLUMN sys.cena_uslov.vzpv_id IS 'ID podvrste vozila';
COMMENT ON COLUMN sys.cena_uslov.vzk_id IS 'ID karoserije';

-- Create indexes for table sys.cena_uslov
CREATE INDEX cnu_vzv_fk_i ON sys.cena_uslov (vzv_id);
CREATE INDEX cnu_vzpv_fk_i ON sys.cena_uslov (vzpv_id);
CREATE INDEX cnu_vzk_fk_i ON sys.cena_uslov (vzk_id);

CREATE UNIQUE INDEX cnu_uk1_i ON sys.cena_uslov (ck_id, cn_id, vzv_id, vzpv_id, vzk_id, cnu_uslov);

-- Add keys for table sys.cena_uslov
ALTER TABLE sys.cena_uslov ADD CONSTRAINT cnu_pk PRIMARY KEY (ck_id, cn_id, cnu_id);

-- Table sys.cena
CREATE TABLE sys.cena
(
  ck_id integer NOT NULL,
  cn_id integer NOT NULL,
  cn_cena numeric(20, 2) NOT NULL,
  us_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sys.cena IS 'Cene';
COMMENT ON COLUMN sys.cena.ck_id IS 'ID cenovnika';
COMMENT ON COLUMN sys.cena.cn_id IS 'ID cene';
COMMENT ON COLUMN sys.cena.cn_cena IS 'Cena';
COMMENT ON COLUMN sys.cena.us_id IS 'ID usluge';

-- Create indexes for table sys.cena
CREATE INDEX cn_us_fk_i ON sys.cena (us_id);

-- Add keys for table sys.cena
ALTER TABLE sys.cena ADD CONSTRAINT cn_pk PRIMARY KEY (ck_id, cn_id);

-- Table hmlg.vozilo_gas
CREATE TABLE hmlg.vozilo_gas
(
  vz_id integer NOT NULL,
  vzg_id integer NOT NULL,
  vzg_tip character varying(10) DEFAULT 'TNG' CHECK (vzg_tip IN ('TNG', 'KPG')),
  vzg_aktivan character(1) DEFAULT 'D' CHECK (vzg_aktivan IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.vozilo_gas IS 'Gasni uređaj za vozilo';
COMMENT ON COLUMN hmlg.vozilo_gas.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo_gas.vzg_id IS 'ID gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gas.vzg_tip IS 'Tip gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gas.vzg_aktivan IS 'Uređaj je aktivan?';

-- Add keys for table hmlg.vozilo_gas
ALTER TABLE hmlg.vozilo_gas ADD CONSTRAINT vzg_pk PRIMARY KEY (vz_id, vzg_id);

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

-- Create indexes for table hmlg.vozilo_gas_ispitivanje
CREATE INDEX vzgi_org_fk_i ON hmlg.vozilo_gas_ispitivanje (org_id);
CREATE INDEX vzgi_kr_fk_i ON hmlg.vozilo_gas_ispitivanje (kr_id);

-- Add keys for table hmlg.vozilo_gas_ispitivanje
ALTER TABLE hmlg.vozilo_gas_ispitivanje ADD CONSTRAINT vzgi_pk PRIMARY KEY (vz_id, vzg_id, vzgi_id);

-- Table hmlg.vozilo_gu
CREATE TABLE hmlg.vozilo_gu
(
  vz_id integer NOT NULL,
  vzg_id integer NOT NULL,
  vzgu_id integer NOT NULL,
  vzgu_broj character varying(20) NOT NULL,
  agu_id integer NOT NULL,
  agp_id integer NOT NULL,
  agh_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.vozilo_gu IS 'Delovi gasnog uređaja za vozilo';
COMMENT ON COLUMN hmlg.vozilo_gu.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vozilo_gu.vzg_id IS 'ID gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gu.vzgu_id IS 'ID dela gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gu.vzgu_broj IS 'Broj dela gasnog uređaja';
COMMENT ON COLUMN hmlg.vozilo_gu.agu_id IS 'ID dela gasnog uređaja';

-- Create indexes for table hmlg.vozilo_gu
CREATE INDEX vzgu_agu_fk_i ON hmlg.vozilo_gu (agu_id);
CREATE INDEX vzgu_agph_fk_i ON hmlg.vozilo_gu (agp_id, agh_id);

-- Add keys for table hmlg.vozilo_gu
ALTER TABLE hmlg.vozilo_gu ADD CONSTRAINT vzgu_pk PRIMARY KEY (vz_id, vzg_id, vzgu_id);

-- Table sif.ag_uredjaj
CREATE TABLE sif.ag_uredjaj
(
  agu_id integer NOT NULL,
  agu_oznaka character(2) DEFAULT 'RZ' NOT NULL CHECK (agu_oznaka IN ('MV', 'RD', 'RZ')),
  agu_naziv character varying(30) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.ag_uredjaj IS 'Delovi gasnog uređaja';
COMMENT ON COLUMN sif.ag_uredjaj.agu_id IS 'ID dela gasnog uređaja';
COMMENT ON COLUMN sif.ag_uredjaj.agu_oznaka IS 'Oznaka dela gasnog uređaja';
COMMENT ON COLUMN sif.ag_uredjaj.agu_naziv IS 'Naziv dela gasnog uređaja';

-- Add keys for table sif.ag_uredjaj
ALTER TABLE sif.ag_uredjaj ADD CONSTRAINT agu_pk PRIMARY KEY (agu_id);
ALTER TABLE sif.ag_uredjaj ADD CONSTRAINT agu_oznaka_uk UNIQUE (agu_oznaka);
ALTER TABLE sif.ag_uredjaj ADD CONSTRAINT agu_naziv_uk UNIQUE (agu_naziv);

-- Table hmlg.predmet_fajl
CREATE TABLE hmlg.predmet_fajl
(
  pr_id integer NOT NULL,
  prf_id integer NOT NULL,
  prf_dir character varying(200) NOT NULL,
  prf_file character varying(60) NOT NULL,
  prf_ext character varying(10) NOT NULL,
  prd_id integer
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.predmet_fajl IS 'Fajlovi za predmet';
COMMENT ON COLUMN hmlg.predmet_fajl.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.predmet_fajl.prf_id IS 'ID fajla predmeta';
COMMENT ON COLUMN hmlg.predmet_fajl.prf_dir IS 'Direktorijum sa fajlovima';
COMMENT ON COLUMN hmlg.predmet_fajl.prf_file IS 'Naziv fajl';
COMMENT ON COLUMN hmlg.predmet_fajl.prf_ext IS 'Ekstenzija (tip) fajl';

-- Create indexes for table hmlg.predmet_fajl
CREATE INDEX prf_prd_fk_i ON hmlg.predmet_fajl (prd_id);

-- Add keys for table hmlg.predmet_fajl
ALTER TABLE hmlg.predmet_fajl ADD CONSTRAINT prf_pk PRIMARY KEY (pr_id, prf_id);

-- Table public.sys_firma
CREATE TABLE public.sys_firma
(
  fir_id integer NOT NULL,
  fir_naziv character varying(50),
  fir_naziv_s character varying(50),
  fir_opis character varying(200),
  fir_opis_s character varying(200),
  fir_mesto_sediste character varying(50),
  fir_adresa_sediste character varying(100),
  fir_mesto character varying(50),
  fir_adresa character varying(100),
  fir_tel1 character varying(20),
  fir_tel2 character varying(20),
  fir_mail character varying(50),
  fir_web character varying(50),
  fir_logo character varying(100),
  fir_pib integer,
  fir_mbr integer,
  fir_banka character varying(60),
  fir_ziro_rac character varying(20),
  sr_cir character(1) DEFAULT 'N' CHECK (sr_cir IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE public.sys_firma IS 'Sistemski parametri';
COMMENT ON COLUMN public.sys_firma.fir_id IS 'ID firme';
COMMENT ON COLUMN public.sys_firma.fir_naziv IS 'Naziv firme';
COMMENT ON COLUMN public.sys_firma.fir_naziv_s IS 'Naziv firme (kratki)';
COMMENT ON COLUMN public.sys_firma.fir_opis IS 'Delatnost firme';
COMMENT ON COLUMN public.sys_firma.fir_opis_s IS 'Delatnost firme (kratka)';
COMMENT ON COLUMN public.sys_firma.fir_mesto_sediste IS 'Mesto sedišta firme';
COMMENT ON COLUMN public.sys_firma.fir_adresa_sediste IS 'Adresa sedišta firme';
COMMENT ON COLUMN public.sys_firma.fir_mesto IS 'Mesto sedišta firme';
COMMENT ON COLUMN public.sys_firma.fir_adresa IS 'Adresa sedišta firme';
COMMENT ON COLUMN public.sys_firma.fir_tel1 IS 'Telefon firme 1';
COMMENT ON COLUMN public.sys_firma.fir_tel2 IS 'Telefon firme 1';
COMMENT ON COLUMN public.sys_firma.fir_mail IS 'E-mail firme';
COMMENT ON COLUMN public.sys_firma.fir_web IS 'Web stranica firme';
COMMENT ON COLUMN public.sys_firma.fir_logo IS 'Logo firme';
COMMENT ON COLUMN public.sys_firma.fir_pib IS 'PIB firme';
COMMENT ON COLUMN public.sys_firma.fir_mbr IS 'Matični broj firme';
COMMENT ON COLUMN public.sys_firma.fir_banka IS 'Banka firme';
COMMENT ON COLUMN public.sys_firma.fir_ziro_rac IS 'Žiro račun firme';
COMMENT ON COLUMN public.sys_firma.sr_cir IS 'Ćirilica?';

-- Add keys for table public.sys_firma
ALTER TABLE public.sys_firma ADD CONSTRAINT sysp_pk PRIMARY KEY (fir_id);

-- Table sif.vozilo_dokument
CREATE TABLE sif.vozilo_dokument
(
  vzd_id integer NOT NULL,
  vzd_oznaka character varying(10) NOT NULL,
  vzd_naziv character varying(60) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.vozilo_dokument IS 'Dokumnta za vozilo';
COMMENT ON COLUMN sif.vozilo_dokument.vzd_id IS 'ID dokumenta';
COMMENT ON COLUMN sif.vozilo_dokument.vzd_oznaka IS 'Oznaka dokumenta';
COMMENT ON COLUMN sif.vozilo_dokument.vzd_naziv IS 'Naziv dokumenta';

-- Add keys for table sif.vozilo_dokument
ALTER TABLE sif.vozilo_dokument ADD CONSTRAINT dok_pk PRIMARY KEY (vzd_id);
ALTER TABLE sif.vozilo_dokument ADD CONSTRAINT dok_oznaka_uk UNIQUE (vzd_oznaka);
ALTER TABLE sif.vozilo_dokument ADD CONSTRAINT dok_naziv_uk UNIQUE (vzd_naziv);

-- Table hmlg.pr_vzd
CREATE TABLE hmlg.pr_vzd
(
  pr_id integer NOT NULL,
  vzd_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.pr_vzd IS 'Dokumnta za vozilo za predmet';
COMMENT ON COLUMN hmlg.pr_vzd.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.pr_vzd.vzd_id IS 'ID dokumenta';

-- Add keys for table hmlg.pr_vzd
ALTER TABLE hmlg.pr_vzd ADD CONSTRAINT prd_pk PRIMARY KEY (pr_id, vzd_id);

-- Table sif.motor_tip
CREATE TABLE sif.motor_tip
(
  mtt_id integer NOT NULL,
  mtt_oznaka character(1) DEFAULT 'B' NOT NULL CHECK (mtt_oznaka IN ('B', 'D', 'E')),
  mtt_naziv character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.motor_tip IS 'Tip motora';
COMMENT ON COLUMN sif.motor_tip.mtt_id IS 'ID tipa motora';
COMMENT ON COLUMN sif.motor_tip.mtt_oznaka IS 'Oznaka tipa motora';
COMMENT ON COLUMN sif.motor_tip.mtt_naziv IS 'Naziv tipa motora';

-- Add keys for table sif.motor_tip
ALTER TABLE sif.motor_tip ADD CONSTRAINT mtt_pk PRIMARY KEY (mtt_id);
ALTER TABLE sif.motor_tip ADD CONSTRAINT mtt_oznaka_uk UNIQUE (mtt_oznaka);
ALTER TABLE sif.motor_tip ADD CONSTRAINT mtt_naziv_uk UNIQUE (mtt_naziv);

-- Table sif.predmet_dokument
CREATE TABLE sif.predmet_dokument
(
  prd_id integer NOT NULL,
  prd_oznaka character varying(10) NOT NULL,
  prd_naziv character varying(50) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.predmet_dokument IS 'Dokumenta za predmet';
COMMENT ON COLUMN sif.predmet_dokument.prd_id IS 'ID dokumenta za predmet';
COMMENT ON COLUMN sif.predmet_dokument.prd_oznaka IS 'Oznaka dokumenta za predmet';
COMMENT ON COLUMN sif.predmet_dokument.prd_naziv IS 'Naziv dokumenta za predmet';

-- Add keys for table sif.predmet_dokument
ALTER TABLE sif.predmet_dokument ADD CONSTRAINT prd_pk PRIMARY KEY (prd_id);
ALTER TABLE sif.predmet_dokument ADD CONSTRAINT prd_oznaka_uk UNIQUE (prd_oznaka);
ALTER TABLE sif.predmet_dokument ADD CONSTRAINT prd_naziv_uk UNIQUE (prd_naziv);

-- Table public.tuv_imp_sert
CREATE TABLE public.tuv_imp_sert
(
  tis_part character(1) NOT NULL,
  tis_order integer NOT NULL,
  tis_lbl_coc character varying(10),
  tis_lbl_drvlc character varying(50),
  tis_desc_sr character varying(200) NOT NULL,
  tis_desc_en character varying(200) NOT NULL,
  tis_unit character varying(10),
  tis_column character varying(50)
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE public.tuv_imp_sert IS 'TUV import sertifikat';
COMMENT ON COLUMN public.tuv_imp_sert.tis_part IS 'Pripadnost reda';
COMMENT ON COLUMN public.tuv_imp_sert.tis_order IS 'Redni broj reda';
COMMENT ON COLUMN public.tuv_imp_sert.tis_lbl_coc IS 'COC';
COMMENT ON COLUMN public.tuv_imp_sert.tis_lbl_drvlc IS 'Vozačka dozvola';
COMMENT ON COLUMN public.tuv_imp_sert.tis_desc_sr IS 'Opis srpski';
COMMENT ON COLUMN public.tuv_imp_sert.tis_desc_en IS 'Opis engleski';
COMMENT ON COLUMN public.tuv_imp_sert.tis_unit IS 'Jedinica mere';
COMMENT ON COLUMN public.tuv_imp_sert.tis_column IS 'Kolona iz predmeta';

-- Add keys for table public.tuv_imp_sert
ALTER TABLE public.tuv_imp_sert ADD CONSTRAINT tis_pk PRIMARY KEY (tis_order, tis_part);

-- Table sys.arl_us
CREATE TABLE sys.arl_us
(
  arl_id integer NOT NULL,
  us_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sys.arl_us IS 'Usluge za rolu';
COMMENT ON COLUMN sys.arl_us.arl_id IS 'ID role';
COMMENT ON COLUMN sys.arl_us.us_id IS 'ID usluge';

-- Add keys for table sys.arl_us
ALTER TABLE sys.arl_us ADD CONSTRAINT arlus_pk PRIMARY KEY (us_id, arl_id);

-- Table hmlg.predmet_usluga
CREATE TABLE hmlg.predmet_usluga
(
  pr_id integer NOT NULL,
  us_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.predmet_usluga IS 'Usluge za predmet';
COMMENT ON COLUMN hmlg.predmet_usluga.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.predmet_usluga.us_id IS 'ID usluge';

-- Add keys for table hmlg.predmet_usluga
ALTER TABLE hmlg.predmet_usluga ADD CONSTRAINT prus_pk PRIMARY KEY (pr_id, us_id);

-- Table sif.motor_oznaka
CREATE TABLE sif.motor_oznaka
(
  mto_id integer NOT NULL,
  mto_oznaka character varying(20) NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE sif.motor_oznaka IS 'Oznake motora';
COMMENT ON COLUMN sif.motor_oznaka.mto_id IS 'ID oznake motora';
COMMENT ON COLUMN sif.motor_oznaka.mto_oznaka IS 'Oznaka motora';

-- Add keys for table sif.motor_oznaka
ALTER TABLE sif.motor_oznaka ADD CONSTRAINT mto_pk PRIMARY KEY (mto_id);
ALTER TABLE sif.motor_oznaka ADD CONSTRAINT mto_oznaka_uk UNIQUE (mto_oznaka);

-- Table hmlg.vz_vzk
CREATE TABLE hmlg.vz_vzk
(
  vz_id integer NOT NULL,
  vzk_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.vz_vzk IS 'Karoserije vozila';
COMMENT ON COLUMN hmlg.vz_vzk.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vz_vzk.vzk_id IS 'ID karoserije vozila';

-- Add keys for table hmlg.vz_vzk
ALTER TABLE hmlg.vz_vzk ADD CONSTRAINT vz_vzk_pk PRIMARY KEY (vz_id, vzk_id);

-- Table hmlg.vzs_vzk
CREATE TABLE hmlg.vzs_vzk
(
  vzs_id integer NOT NULL,
  vzk_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.vzs_vzk IS 'Karoserije vozila';
COMMENT ON COLUMN hmlg.vzs_vzk.vzs_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vzs_vzk.vzk_id IS 'ID karoserije vozila';

-- Add keys for table hmlg.vzs_vzk
ALTER TABLE hmlg.vzs_vzk ADD CONSTRAINT vzs_vzk_pk PRIMARY KEY (vzs_id, vzk_id);

-- Table hmlg.vz_vzdo
CREATE TABLE hmlg.vz_vzdo
(
  vz_id integer NOT NULL,
  vzdo_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.vz_vzdo IS 'Dodatne oznake vozila';
COMMENT ON COLUMN hmlg.vz_vzdo.vz_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vz_vzdo.vzdo_id IS 'ID dodatne oznake vozila';

-- Add keys for table hmlg.vz_vzdo
ALTER TABLE hmlg.vz_vzdo ADD CONSTRAINT vz_vzdo_pk PRIMARY KEY (vz_id, vzdo_id);

-- Table hmlg.vzs_vzdo
CREATE TABLE hmlg.vzs_vzdo
(
  vzs_id integer NOT NULL,
  vzdo_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.vzs_vzdo IS 'Dodatne oznake vozila';
COMMENT ON COLUMN hmlg.vzs_vzdo.vzs_id IS 'ID vozila';
COMMENT ON COLUMN hmlg.vzs_vzdo.vzdo_id IS 'ID dodatne oznake vozila';

-- Add keys for table hmlg.vzs_vzdo
ALTER TABLE hmlg.vzs_vzdo ADD CONSTRAINT vzs_vzdo_pk PRIMARY KEY (vzs_id, vzdo_id);

-- Table hmlg.predmet_status
CREATE TABLE hmlg.predmet_status
(
  prs_id integer NOT NULL,
  prs_oznaka character varying(10) NOT NULL,
  prs_naziv character varying(50),
  prs_priprema character(1) DEFAULT 'D' CHECK (prs_priprema IN ('D', 'N')),
  prs_cekanje character(1) DEFAULT 'N' CHECK (prs_cekanje IN ('D', 'N')),
  prs_zakljucen character(1) DEFAULT 'N' CHECK (prs_zakljucen IN ('D', 'N')),
  prs_neusag character(1) DEFAULT 'N' CHECK (prs_neusag IN ('D', 'N'))
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.predmet_status IS 'Status predmeta';
COMMENT ON COLUMN hmlg.predmet_status.prs_id IS 'ID statusa predmeta';
COMMENT ON COLUMN hmlg.predmet_status.prs_oznaka IS 'Oznaka statusa predmeta';
COMMENT ON COLUMN hmlg.predmet_status.prs_naziv IS 'Naziv statusa predmeta';
COMMENT ON COLUMN hmlg.predmet_status.prs_priprema IS 'Predmet je u pripremi?';
COMMENT ON COLUMN hmlg.predmet_status.prs_cekanje IS 'Predmet je na čekanju?';
COMMENT ON COLUMN hmlg.predmet_status.prs_zakljucen IS 'Predmet je zaključen?';
COMMENT ON COLUMN hmlg.predmet_status.prs_neusag IS 'Neusaglašenost?';

-- Add keys for table hmlg.predmet_status
ALTER TABLE hmlg.predmet_status ADD CONSTRAINT prs_pk PRIMARY KEY (prs_id);
ALTER TABLE hmlg.predmet_status ADD CONSTRAINT prs_oznaka_uk UNIQUE (prs_oznaka);

-- Table adm.adm_log
CREATE TABLE adm.adm_log
(
  alg_id character varying(50) NOT NULL,
  alg_ip character varying(20) NOT NULL,
  alg_login timestamp DEFAULT current_timestamp NOT NULL,
  alg_logout timestamp DEFAULT current_timestamp,
  alg_token character varying(4000) NOT NULL,
  kr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.adm_log IS 'Logovanje korisnika na aplikaciju';
COMMENT ON COLUMN adm.adm_log.alg_id IS 'ID sesije';
COMMENT ON COLUMN adm.adm_log.alg_ip IS 'IP adresa';
COMMENT ON COLUMN adm.adm_log.alg_login IS 'Vreme prijave';
COMMENT ON COLUMN adm.adm_log.alg_logout IS 'Vreme odjave';
COMMENT ON COLUMN adm.adm_log.alg_token IS 'Token';
COMMENT ON COLUMN adm.adm_log.kr_id IS 'ID korisnika';

-- Create indexes for table adm.adm_log
CREATE INDEX alg_kr_fk_i ON adm.adm_log (kr_id);

-- Add keys for table adm.adm_log
ALTER TABLE adm.adm_log ADD CONSTRAINT alg_pk PRIMARY KEY (alg_id);

-- Table adm.adm_akcija
CREATE TABLE adm.adm_akcija
(
  aac_id integer NOT NULL,
  aac_oznaka character varying(10) NOT NULL,
  aac_naziv character varying(50),
  aac_tip character(1) CHECK (aac_tip IN ('V', 'I', 'U', 'D', 'C', 'O'))
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.adm_akcija IS 'Akcije forme';
COMMENT ON COLUMN adm.adm_akcija.aac_id IS 'ID akcije';
COMMENT ON COLUMN adm.adm_akcija.aac_oznaka IS 'Oznaka akcije';
COMMENT ON COLUMN adm.adm_akcija.aac_naziv IS 'Naziv akcije';
COMMENT ON COLUMN adm.adm_akcija.aac_tip IS 'Tip akcije';

-- Add keys for table adm.adm_akcija
ALTER TABLE adm.adm_akcija ADD CONSTRAINT aac_pk PRIMARY KEY (aac_id);
ALTER TABLE adm.adm_akcija ADD CONSTRAINT aac_oznaka_uk UNIQUE (aac_oznaka);

-- Table adm.adm_forma_akcija
CREATE TABLE adm.adm_forma_akcija
(
  afo_id integer NOT NULL,
  aac_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.adm_forma_akcija IS 'Akcije za formu';

-- Add keys for table adm.adm_forma_akcija
ALTER TABLE adm.adm_forma_akcija ADD CONSTRAINT afa_pk PRIMARY KEY (afo_id, aac_id);

-- Table adm.adm_izvestaji
CREATE TABLE adm.adm_izvestaji
(
  aiz_id integer NOT NULL,
  aiz_naziv character varying(50) NOT NULL,
  aiz_report character varying(50) NOT NULL,
  aiz_parametri character varying(100)
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.adm_izvestaji IS 'Izveštaji';
COMMENT ON COLUMN adm.adm_izvestaji.aiz_id IS 'ID izveštaja';
COMMENT ON COLUMN adm.adm_izvestaji.aiz_naziv IS 'Naziv  izveštaja';
COMMENT ON COLUMN adm.adm_izvestaji.aiz_report IS '.jasper fajl izveštaja';
COMMENT ON COLUMN adm.adm_izvestaji.aiz_parametri IS 'Parametri izveštaja';

-- Add keys for table adm.adm_izvestaji
ALTER TABLE adm.adm_izvestaji ADD CONSTRAINT aiz_pk PRIMARY KEY (aiz_id);

-- Table adm.adm_forma_izvestaj
CREATE TABLE adm.adm_forma_izvestaj
(
  afo_id integer NOT NULL,
  aiz_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.adm_forma_izvestaj IS 'Izveštaji za formu';

-- Add keys for table adm.adm_forma_izvestaj
ALTER TABLE adm.adm_forma_izvestaj ADD CONSTRAINT afi_pk PRIMARY KEY (afo_id, aiz_id);

-- Table adm.arf_afac
CREATE TABLE adm.arf_afac
(
  arl_id integer NOT NULL,
  afo_id integer NOT NULL,
  aac_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.arf_afac IS 'Akcije za rolu';

-- Add keys for table adm.arf_afac
ALTER TABLE adm.arf_afac ADD CONSTRAINT arf_afac_pk PRIMARY KEY (arl_id, afo_id, aac_id);

-- Table adm.arf_afiz
CREATE TABLE adm.arf_afiz
(
  arl_id integer NOT NULL,
  afo_id integer NOT NULL,
  aiz_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.arf_afiz IS 'Izveštaji za rolu';

-- Add keys for table adm.arf_afiz
ALTER TABLE adm.arf_afiz ADD CONSTRAINT arf_afiz_pk PRIMARY KEY (arl_id, afo_id, aiz_id);

-- Table hmlg.potvrda
CREATE TABLE hmlg.potvrda
(
  pot_id integer NOT NULL,
  pot_broj character varying(10) NOT NULL,
  pot_datum date DEFAULT current_date NOT NULL,
  pot_vreme timestamp DEFAULT current_timestamp NOT NULL,
  pr_id integer NOT NULL,
  lk_id integer,
  kr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE hmlg.potvrda IS 'Potvrde o tehničkim karakteristikama vozila';
COMMENT ON COLUMN hmlg.potvrda.pot_id IS 'ID potvrde';
COMMENT ON COLUMN hmlg.potvrda.pot_broj IS 'Broj potvrde';
COMMENT ON COLUMN hmlg.potvrda.pot_datum IS 'Datum potvrde';
COMMENT ON COLUMN hmlg.potvrda.pot_vreme IS 'Vreme kreiranja potvrde';
COMMENT ON COLUMN hmlg.potvrda.pr_id IS 'ID predmeta';
COMMENT ON COLUMN hmlg.potvrda.lk_id IS 'ID lokacije';
COMMENT ON COLUMN hmlg.potvrda.kr_id IS 'ID korisnika';

-- Create indexes for table hmlg.potvrda

CREATE UNIQUE INDEX pot_pr_fk_i ON hmlg.potvrda (pr_id);
CREATE INDEX pot_lk_fk_i ON hmlg.potvrda (lk_id);
CREATE INDEX pot_kr_fk_i ON hmlg.potvrda (kr_id);

-- Add keys for table hmlg.potvrda
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_pk PRIMARY KEY (pot_id);
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_uk2 UNIQUE (pr_id);
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_uk1 UNIQUE (pot_broj);

-- Table adm.adm_log_akcija
CREATE TABLE adm.adm_log_akcija
(
  ala_vreme timestamp DEFAULT current_timestamp NOT NULL,
  ala_tabela character varying(50) NOT NULL,
  ala_akcija character varying(10) NOT NULL,
  ala_red_old text,
  ala_red_new text,
  kr_id integer NOT NULL
) WITH (autovacuum_enabled=true);

COMMENT ON TABLE adm.adm_log_akcija IS 'Log akcija';
COMMENT ON COLUMN adm.adm_log_akcija.ala_vreme IS 'Vreme akcija';
COMMENT ON COLUMN adm.adm_log_akcija.ala_tabela IS 'Tabela akcije';
COMMENT ON COLUMN adm.adm_log_akcija.ala_akcija IS 'Akcija';
COMMENT ON COLUMN adm.adm_log_akcija.ala_red_old IS 'Stari red tabele';
COMMENT ON COLUMN adm.adm_log_akcija.ala_red_new IS 'Novi red tabele';
COMMENT ON COLUMN adm.adm_log_akcija.kr_id IS 'ID korisnika';

-- Create indexes for table adm.adm_log_akcija
CREATE INDEX ala_kr_fk_i ON adm.adm_log_akcija (kr_id);

-- Add keys for table adm.adm_log_akcija
ALTER TABLE adm.adm_log_akcija ADD CONSTRAINT ala_pk PRIMARY KEY (ala_vreme, ala_tabela, ala_akcija);

-- Create foreign keys (relationships) section ------------------------------------------------- 
ALTER TABLE sys.korisnik ADD CONSTRAINT kr_arl_fk FOREIGN KEY (arl_id) REFERENCES adm.adm_rola (arl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.model ADD CONSTRAINT md_mr_fk FOREIGN KEY (mr_id) REFERENCES sif.marka (mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.raspored ADD CONSTRAINT rs_kn_fk FOREIGN KEY (kn_datum) REFERENCES sys.kalendar (kn_datum) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sys.raspored ADD CONSTRAINT rs_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.raspored ADD CONSTRAINT rs_lk_fk FOREIGN KEY (lk_id) REFERENCES sys.lokacija (lk_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.vozilo_podvrsta ADD CONSTRAINT vzpv_vzv_fk FOREIGN KEY (vzv_id) REFERENCES sif.vozilo_vrsta (vzv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.vzk_vzpv ADD CONSTRAINT vzkpv_vzk_fk FOREIGN KEY (vzk_id) REFERENCES sif.vozilo_karoserija (vzk_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sif.vzk_vzpv ADD CONSTRAINT vzkpv_vzpv_fk FOREIGN KEY (vzpv_id) REFERENCES sif.vozilo_podvrsta (vzpv_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sif.vzkl_vzpv ADD CONSTRAINT vzklpv_vzkl_fk FOREIGN KEY (vzkl_id) REFERENCES sif.vozilo_klasa (vzkl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.vzkl_vzpv ADD CONSTRAINT vzklpv_vzpv_fk FOREIGN KEY (vzpv_id) REFERENCES sif.vozilo_podvrsta (vzpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.vzdo_vzv ADD CONSTRAINT vzdov_vzdo_fk FOREIGN KEY (vzdo_id) REFERENCES sif.vozilo_dod_oznaka (vzdo_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sif.vzdo_vzv ADD CONSTRAINT vzdov_vzv_fk FOREIGN KEY (vzv_id) REFERENCES sif.vozilo_vrsta (vzv_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sif.agp_agh ADD CONSTRAINT agph_agp_fk FOREIGN KEY (agp_id) REFERENCES sif.ag_proizvodjac (agp_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sif.agp_agh ADD CONSTRAINT agph_agh FOREIGN KEY (agh_id) REFERENCES sif.ag_homologacija (agh_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_kl_fk FOREIGN KEY (kl_id) REFERENCES hmlg.klijent (kl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_osovina ADD CONSTRAINT vzo_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_em_fk FOREIGN KEY (em_id) REFERENCES sif.emisija (em_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.adm_forma ADD CONSTRAINT afo_aap_fk FOREIGN KEY (aap_id) REFERENCES adm.adm_aplikacija (aap_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.arl_afo ADD CONSTRAINT arf_arl_fk FOREIGN KEY (arl_id) REFERENCES adm.adm_rola (arl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.arl_afo ADD CONSTRAINT arf_afo_fk FOREIGN KEY (afo_id) REFERENCES adm.adm_forma (afo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.cena_uslov ADD CONSTRAINT cnu_vzv_fk FOREIGN KEY (vzv_id) REFERENCES sif.vozilo_vrsta (vzv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.cena_uslov ADD CONSTRAINT cnu_vzpv_fk FOREIGN KEY (vzpv_id) REFERENCES sif.vozilo_podvrsta (vzpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.cena_uslov ADD CONSTRAINT cnu_vzk_fk FOREIGN KEY (vzk_id) REFERENCES sif.vozilo_karoserija (vzk_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.cena ADD CONSTRAINT cn_ck_fk FOREIGN KEY (ck_id) REFERENCES sys.cenovnik (ck_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.cena_uslov ADD CONSTRAINT cnu_cn_fk FOREIGN KEY (ck_id, cn_id) REFERENCES sys.cena (ck_id, cn_id) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE sys.cena ADD CONSTRAINT cn_us_fk FOREIGN KEY (us_id) REFERENCES sys.usluga (us_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_mr_fk FOREIGN KEY (mr_id) REFERENCES sif.marka (mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_md_fk FOREIGN KEY (md_id, mr_id) REFERENCES sif.model (md_id, mr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_mdt_fk FOREIGN KEY (mdt_id) REFERENCES sif.model_tip (mdt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_mdvr_fk FOREIGN KEY (mdvr_id) REFERENCES sif.model_varijanta (mdvr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_mdvz_fk FOREIGN KEY (mdvz_id) REFERENCES sif.model_verzija (mdvz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gas ADD CONSTRAINT vzg_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gu ADD CONSTRAINT vzgu_vzg_fk FOREIGN KEY (vz_id, vzg_id) REFERENCES hmlg.vozilo_gas (vz_id, vzg_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.ag_homologacija ADD CONSTRAINT agh_agu_fk FOREIGN KEY (agu_id) REFERENCES sif.ag_uredjaj (agu_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gu ADD CONSTRAINT vzgu_agu_fk FOREIGN KEY (agu_id) REFERENCES sif.ag_uredjaj (agu_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gu ADD CONSTRAINT vzgu_agp_agh_fk FOREIGN KEY (agp_id, agh_id) REFERENCES sif.agp_agh (agp_id, agh_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.pr_vzd ADD CONSTRAINT prd_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.pr_vzd ADD CONSTRAINT prd_dok_fk FOREIGN KEY (vzd_id) REFERENCES sif.vozilo_dokument (vzd_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.motor ADD CONSTRAINT mt_mtt_fk FOREIGN KEY (mtt_id) REFERENCES sif.motor_tip (mtt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_mt_fk FOREIGN KEY (mt_id) REFERENCES sif.motor (mt_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_gr_fk FOREIGN KEY (gr_id) REFERENCES sif.gorivo (gr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_vzkl_fk FOREIGN KEY (vzkl_id) REFERENCES sif.vozilo_klasa (vzkl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet_fajl ADD CONSTRAINT prf_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet_fajl ADD CONSTRAINT prs_prd_fk FOREIGN KEY (prd_id) REFERENCES sif.predmet_dokument (prd_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.arl_us ADD CONSTRAINT kr_us_us_fk FOREIGN KEY (us_id) REFERENCES sys.usluga (us_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sys.arl_us ADD CONSTRAINT arlus_arl_fk FOREIGN KEY (arl_id) REFERENCES adm.adm_rola (arl_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gas_ispitivanje ADD CONSTRAINT vzgi_vzg_fk FOREIGN KEY (vz_id, vzg_id) REFERENCES hmlg.vozilo_gas (vz_id, vzg_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gas_ispitivanje ADD CONSTRAINT vzgi_org_fk FOREIGN KEY (org_id) REFERENCES sif.organizacija (org_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo_gas_ispitivanje ADD CONSTRAINT vzgi_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_vzpv_fk FOREIGN KEY (vzpv_id) REFERENCES sif.vozilo_podvrsta (vzpv_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet_usluga ADD CONSTRAINT prus_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet_usluga ADD CONSTRAINT prus_us_fk FOREIGN KEY (us_id) REFERENCES sys.usluga (us_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE sif.motor ADD CONSTRAINT mt_mto_fk FOREIGN KEY (mto_id) REFERENCES sif.motor_oznaka (mto_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vz_vzk ADD CONSTRAINT vzvzk_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vz_vzk ADD CONSTRAINT vzvzk_vzk_fk FOREIGN KEY (vzk_id) REFERENCES sif.vozilo_karoserija (vzk_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vz_vzdo ADD CONSTRAINT vzvzdo_vz_fk FOREIGN KEY (vz_id) REFERENCES hmlg.vozilo (vz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vz_vzdo ADD CONSTRAINT vzvzdo_vzdo_fk FOREIGN KEY (vzdo_id) REFERENCES sif.vozilo_dod_oznaka (vzdo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.predmet ADD CONSTRAINT pr_prs_fk FOREIGN KEY (prs_id) REFERENCES hmlg.predmet_status (prs_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.adm_log ADD CONSTRAINT alg_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.adm_forma_akcija ADD CONSTRAINT afa_afo_fk FOREIGN KEY (afo_id) REFERENCES adm.adm_forma (afo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.adm_forma_akcija ADD CONSTRAINT afa_aac_fk FOREIGN KEY (aac_id) REFERENCES adm.adm_akcija (aac_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.adm_forma_izvestaj ADD CONSTRAINT afi_afo FOREIGN KEY (afo_id) REFERENCES adm.adm_forma (afo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.adm_forma_izvestaj ADD CONSTRAINT afi_aiz FOREIGN KEY (aiz_id) REFERENCES adm.adm_izvestaji (aiz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.arf_afac ADD CONSTRAINT arfac_arf FOREIGN KEY (arl_id, afo_id) REFERENCES adm.arl_afo (arl_id, afo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.arf_afac ADD CONSTRAINT arfac_afac FOREIGN KEY (afo_id, aac_id) REFERENCES adm.adm_forma_akcija (afo_id, aac_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.arf_afiz ADD CONSTRAINT arfiz_arf FOREIGN KEY (arl_id, afo_id) REFERENCES adm.arl_afo (arl_id, afo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.arf_afiz ADD CONSTRAINT arfiz_aiz FOREIGN KEY (afo_id, aiz_id) REFERENCES adm.adm_forma_izvestaj (afo_id, aiz_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
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
ALTER TABLE hmlg.vozilo_s_osovina ADD CONSTRAINT vzos_vzs_fk FOREIGN KEY (vzs_id) REFERENCES hmlg.vozilo_sert (vzs_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vzs_vzk ADD CONSTRAINT vzsvzk_vzk_fk FOREIGN KEY (vzk_id) REFERENCES sif.vozilo_karoserija (vzk_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vzs_vzdo ADD CONSTRAINT vzsvzdo_vzdo_fk FOREIGN KEY (vzdo_id) REFERENCES sif.vozilo_dod_oznaka (vzdo_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vzs_vzk ADD CONSTRAINT vzsvzk_vzs_fk FOREIGN KEY (vzs_id) REFERENCES hmlg.vozilo_sert (vzs_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vzs_vzdo ADD CONSTRAINT vzsvzk_vzs_fk FOREIGN KEY (vzs_id) REFERENCES hmlg.vozilo_sert (vzs_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.vozilo ADD CONSTRAINT vz_vzs_fk FOREIGN KEY (vzs_id) REFERENCES hmlg.vozilo_sert (vzs_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_pr_fk FOREIGN KEY (pr_id) REFERENCES hmlg.predmet (pr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_lk_fk FOREIGN KEY (lk_id) REFERENCES sys.lokacija (lk_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE adm.adm_log_akcija ADD CONSTRAINT ala_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE hmlg.potvrda ADD CONSTRAINT pot_kr_fk FOREIGN KEY (kr_id) REFERENCES sys.korisnik (kr_id) ON DELETE NO ACTION ON UPDATE NO ACTION;
