/* Table _t.vozilo_imp_gas */
DROP TABLE IF EXISTS _t.vozilo_imp_gas CASCADE;
-- Table _t.vozilo_imp_gas
CREATE TABLE _t.vozilo_imp_gas
(
  vzg_br int4 NOT NULL,
  vzg_rn int4 NOT NULL,
  vzgi_broj varchar(15) NULL,
  vzpv_oznaka_bt varchar(50) NULL,
  vzpv_oznaka varchar(50) NULL,
  mr_naziv_bt varchar(50) NULL,
  mr_naziv varchar(50) NULL,
  vvt_bt varchar(50) NULL,
  vvt varchar(50) NULL,
  md_naziv_k_bt varchar(50) NULL,
  md_naziv_k varchar(50) NULL,
  vz_sasija_bt varchar(50) NULL,
  vz_sasija varchar(50) NULL,
  vz_masa_max_bt int4 NULL,
  vz_masa_max int4 NULL,
  vz_masa_bt int4 NULL,
  vz_masa int4 NULL,
  mt_cm3_bt numeric(10, 3) NULL,
  mt_cm3 numeric(10, 3) NULL,
  mt_kw_bt numeric(10, 3) NULL,
  mt_kw numeric(10, 3) NULL,
  gr_naziv_bt varchar(50) NULL,
  gr_naziv varchar(50) NULL,
  vz_mesta_sedenje_bt int4 NULL,
  vz_mesta_sedenje int4 NULL,
  vz_mesta_stajanje_bt int4 NULL,
  vz_mesta_stajanje int4 NULL,
  vz_motor_bt varchar(50) NULL,
  vz_motor varchar(50) NULL,
  mt_oznaka_bt varchar(50) NULL,
  mt_oznaka varchar(50) NULL,
  vz_br_osovina_bt int4 NULL,
  vz_br_osovina int4 NULL,
  vzk_oznaka_bt varchar(50) NULL,
  vzk_oznaka varchar(50) NULL,
  vz_max_brzina_bt int4 NULL,
  vz_max_brzina int4 NULL,
  vzo_pneumatik_bt varchar(50) NULL,
  vzo_pneumatik varchar(50) NULL,
  kl_naziv varchar(50) NULL,
  kl_iadresa varchar(50) NULL,
  agp_naziv_rz varchar(50) NULL,
  agh_oznaka_rz varchar(50) NULL,
  vzgu_broj_rz varchar(50) NULL,
  agp_naziv_rd varchar(50) NULL,
  agh_oznaka_rd varchar(50) NULL,
  vzgu_broj_rd varchar(50) NULL,
  agp_naziv_mv varchar(50) NULL,
  agh_oznaka_mv varchar(50) NULL,
  vzgu_broj_mv varchar(50) NULL,
  vzgi_su_broj varchar(50) NULL,
  vzgi_su_datum date NULL,
  vzgi_su_rok date NULL,
  org_naziv varchar(200) NULL,
  vzgi_potvrda_rok date NULL,
  kr_ime varchar(50) NULL,
  vzgi_potvrda_datum date NULL,
  vzgi_potvrda_broj varchar(50) NULL,
  vzgi_zakljucak varchar(4000) NULL,
  lk_naziv_l varchar(50) NULL,
  vz_reg varchar(50) NULL
);

-- Primary key on table _t.vozilo_imp_gas
ALTER TABLE _t.vozilo_imp_gas ADD CONSTRAINT vzg_pk PRIMARY KEY (vzg_br, vzg_rn);

-- Indexes on _t.vozilo_imp_gas
CREATE INDEX vzg_vzg_br_i ON _t.vozilo_imp_gas (vzg_br);
CREATE INDEX vzg_vzgi_broj_i ON _t.vozilo_imp_gas (vzgi_broj);
CREATE INDEX vzg_vzpv_oznaka_i ON _t.vozilo_imp_gas (vzpv_oznaka);
CREATE INDEX vzg_mr_naziv_i ON _t.vozilo_imp_gas (mr_naziv);
CREATE INDEX vzg_md_naziv_k_i ON _t.vozilo_imp_gas (md_naziv_k);
CREATE INDEX vzg_vz_sasija_i ON _t.vozilo_imp_gas (vz_sasija);
CREATE INDEX vzg_vz_motor_i ON _t.vozilo_imp_gas (vz_motor);
CREATE INDEX vzg_mt_oznaka_i ON _t.vozilo_imp_gas (mt_oznaka);
