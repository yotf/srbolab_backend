/* Table _t.vozilo_imp_srt0 */
DROP TABLE IF EXISTS _t.vozilo_imp_srt0 CASCADE;
-- Table _t.vozilo_imp_srt0
CREATE TABLE _t.vozilo_imp_srt0
(
  vzs_id int4 NOT NULL,
  vzs_oznaka varchar(10) NOT NULL,
  vz_cnt int4 NOT NULL,
  vz_sasije varchar[] NOT NULL,
  vzpv_naziv varchar(50) NULL,
  vzk_naziv varchar(50) NULL,
  mr_naziv varchar(50) NULL,
  md_naziv_k varchar(50) NULL,
  mdt_oznaka varchar(30) NULL,
  mdvr_oznaka varchar(40) NULL,
  mdvz_oznaka varchar(50) NULL,
  vz_duzina int4 NULL,
  vz_sirina int4 NULL,
  vz_visina int4 NULL,
  vz_masa int4 NULL,
  vz_masa_max int4 NULL,
  vz_nosivost int4 NULL,
  vzo_nosivost1 int4 NULL,
  vzo_nosivost2 int4 NULL,
  vzo_nosivost3 int4 NULL,
  vzo_nosivost4 int4 NULL,
  vzo_pneumatik1 varchar(20) NULL,
  vzo_pneumatik2 varchar(20) NULL,
  vzo_pneumatik3 varchar(20) NULL,
  vzo_pneumatik4 varchar(20) NULL,
  vz_br_osovina int4 NULL,
  vz_br_tockova int4 NULL,
  mt_oznaka varchar(20) NULL,
  mt_cm3 numeric(10,2) NULL,
  mt_kw numeric(10,2) NULL,
  gr_naziv varchar(20) NULL,
  gr_gas bpchar(1) NULL,
  vz_kw_kg numeric(10,2) NULL,
  vz_mesta_sedenje int4 NULL,
  vz_mesta_stajanje int4 NULL,
  vz_kmh int4 NULL,
  vz_godina int4 NULL,
  em_naziv varchar(20) NULL,
  vz_co2 int4 NULL
);

-- Primary key on table _t.vozilo_imp_srt0
ALTER TABLE _t.vozilo_imp_srt0 ADD CONSTRAINT vzs0_pk PRIMARY KEY (vzs_id);

-- Indexes on _t.vozilo_imp_srt0
CREATE INDEX vzs0_vzpv_naziv_i ON _t.vozilo_imp_srt0 (vzpv_naziv);
CREATE INDEX vzs0_vzk_naziv_i ON _t.vozilo_imp_srt0 (vzk_naziv);
CREATE INDEX vzs0_mr_naziv_i ON _t.vozilo_imp_srt0 (mr_naziv);
CREATE INDEX vzs0_md_naziv_k_i ON _t.vozilo_imp_srt0 (md_naziv_k);
CREATE INDEX vzs0_mdt_oznaka_i ON _t.vozilo_imp_srt0 (mdt_oznaka);
CREATE INDEX vzs0_mdvr_oznaka_i ON _t.vozilo_imp_srt0 (mdvr_oznaka);
CREATE INDEX vzs0_mdvz_oznaka_i ON _t.vozilo_imp_srt0 (mdvz_oznaka);
CREATE INDEX vzs0_mt_oznaka_i ON _t.vozilo_imp_srt0 (mt_oznaka);
CREATE INDEX vzs0_gr_naziv_i ON _t.vozilo_imp_srt0 (gr_naziv);
CREATE INDEX vzs0_vzo_pneumatik1_i ON _t.vozilo_imp_srt0 (vzo_pneumatik1);
CREATE INDEX vzs0_vzo_pneumatik2_i ON _t.vozilo_imp_srt0 (vzo_pneumatik2);
CREATE INDEX vzs0_vzo_pneumatik3_i ON _t.vozilo_imp_srt0 (vzo_pneumatik3);
CREATE INDEX vzs0_vzo_pneumatik4_i ON _t.vozilo_imp_srt0 (vzo_pneumatik4);
CREATE INDEX vzs0_em_naziv_i ON _t.vozilo_imp_srt0 (em_naziv);
CREATE INDEX vzs0_gr_gas_i ON _t.vozilo_imp_srt0 (gr_gas);
