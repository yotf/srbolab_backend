/* Table _t.vozilo_imp */
DROP TABLE IF EXISTS _t.vozilo_imp CASCADE;
-- Table _t.vozilo_imp
CREATE TABLE _t.vozilo_imp
(
  vzi_br int4 NOT NULL,
  vzi_rn int4 NOT NULL,
  pr_broj varchar(10) NULL,
  kl_naziv varchar(100) NULL,
  kl_adresa varchar(100) NULL,
  kl_telefon varchar(30) NULL,
  vz_sasija varchar(30) NULL,
  vzpv_naziv varchar(50) NULL,
  vzk_naziv varchar(50) NULL,
  mr_naziv varchar(50) NULL,
  mdt_oznaka varchar(30) NULL,
  mdvr_oznaka varchar(40) NULL,
  mdvz_oznaka varchar(50) NULL,
  md_naziv_k varchar(50) NULL,
  vz_masa_max int4 NULL,
  vzo_nosivost1 int4 NULL,
  vzo_nosivost2 int4 NULL,
  vzo_nosivost3 int4 NULL,
  vzo_nosivost4 int4 NULL,
  vz_masa int4 NULL,
  vz_nosivost int4 NULL,
  vz_br_osovina int4 NULL,
  vz_br_tockova int4 NULL,
  vz_motor varchar(50) NULL,
  mt_oznaka varchar(20) NULL,
  mt_cm3 numeric(10,2) NULL,
  mt_kw numeric(10,2) NULL,
  gr_naziv varchar(20) NULL,
  gr_gas bpchar(1) NULL,
  vz_kw_kg numeric(10,2) NULL,
  vz_elektro bpchar(1) NULL,
  vz_mesta_sedenje int4 NULL,
  vz_mesta_stajanje int4 NULL,
  vz_kmh int4 NULL,
  vz_godina int4 NULL,
  vzo_pneumatik1 varchar(20) NULL,
  vzo_pneumatik2 varchar(20) NULL,
  vzo_pneumatik3 varchar(20) NULL,
  vzo_pneumatik4 varchar(20) NULL,
  vz_duzina int4 NULL,
  vz_sirina int4 NULL,
  vz_visina int4 NULL,
  vz_km int4 NULL,
  vz_kuka bpchar(1) NULL,
  em_naziv varchar(20) NULL,
  vz_co2 int4 NULL,
  vz_napomena varchar(4000) NULL,
  vz_primedbe varchar(4000) NULL,
  pr_datum date NULL,
  kr_ime varchar(50) NULL,
  vz_saobracajna bpchar(1) NULL,
  vz_odg_dok bpchar(1) NULL,
  vz_coc bpchar(1) NULL,
  vz_potvrda_pr bpchar(1) NULL,
  org_naziv varchar(200) NULL,
  org_adresa varchar(200) NULL,
  org_id int4 NULL,
  vz_tip_var_ver varchar(100) NULL,
  vz_pneumatici varchar(50) NULL,
  vi_naziv varchar(50) NULL,
  vz_zakljucak varchar(4000) NULL,
  vz_prebaceno1 bpchar(1) NULL,
  vz_prebaceno2 bpchar(1) NULL,
  vz_br_oso_toc varchar(20) NULL,
  vz_karakter10 bpchar(1) NULL
);

-- Primary key on table _t.vozilo_imp
ALTER TABLE _t.vozilo_imp ADD CONSTRAINT vzi_pk PRIMARY KEY (vzi_br, vzi_rn);

-- Indexes on _t.vozilo_imp
CREATE INDEX vzi_pr_broj_i ON _t.vozilo_imp (pr_broj);
CREATE INDEX vzi_kl_naziv_i ON _t.vozilo_imp (kl_naziv);
CREATE INDEX vzi_kl_adresa_i ON _t.vozilo_imp (kl_adresa);
CREATE INDEX vzi_kl_telefon_i ON _t.vozilo_imp (kl_telefon);
CREATE INDEX vzi_vz_sasija_i ON _t.vozilo_imp (vz_sasija);
CREATE INDEX vzi_vzpv_naziv_i ON _t.vozilo_imp (vzpv_naziv);
CREATE INDEX vzi_vzk_naziv_i ON _t.vozilo_imp (vzk_naziv);
CREATE INDEX vzi_mr_naziv_i ON _t.vozilo_imp (mr_naziv);
CREATE INDEX vzi_mdt_oznaka_i ON _t.vozilo_imp (mdt_oznaka);
CREATE INDEX vzi_mdvr_oznaka_i ON _t.vozilo_imp (mdvr_oznaka);
CREATE INDEX vzi_mdvz_oznaka_i ON _t.vozilo_imp (mdvz_oznaka);
CREATE INDEX vzi_md_naziv_k_i ON _t.vozilo_imp (md_naziv_k);
CREATE INDEX vzi_vz_motor_i ON _t.vozilo_imp (vz_motor);
CREATE INDEX vzi_mt_oznaka_i ON _t.vozilo_imp (mt_oznaka);
CREATE INDEX vzi_gr_naziv_i ON _t.vozilo_imp (gr_naziv);
CREATE INDEX vzi_vzo_pneumatik1_i ON _t.vozilo_imp (vzo_pneumatik1);
CREATE INDEX vzi_vzo_pneumatik2_i ON _t.vozilo_imp (vzo_pneumatik2);
CREATE INDEX vzi_vzo_pneumatik3_i ON _t.vozilo_imp (vzo_pneumatik3);
CREATE INDEX vzi_vzo_pneumatik4_i ON _t.vozilo_imp (vzo_pneumatik4);
CREATE INDEX vzi_em_naziv_i ON _t.vozilo_imp (em_naziv);
CREATE INDEX vzi_pr_datum_i ON _t.vozilo_imp (pr_datum);
CREATE INDEX vzi_vz_karakter10_i ON _t.vozilo_imp (vz_karakter10);
CREATE INDEX vzi_gr_gas_i ON _t.vozilo_imp (gr_gas);
