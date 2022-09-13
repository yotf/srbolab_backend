/* Table _t.vozilo_imp_gu */
DROP TABLE IF EXISTS _t.vozilo_imp_gu CASCADE;
-- Table _t.vozilo_imp_gu
CREATE TABLE _t.vozilo_imp_gu
(
  vzgu_br int4 NOT NULL,
  vzgu_rn int4 NOT NULL,
  agu_id int4 NULL,
  agu_oznaka bpchar(2) NULL,
  agp_naziv varchar(60) NULL,
  agh_oznaka varchar(60) NULL
);

-- Primary key on table _t.vozilo_imp_gu
ALTER TABLE _t.vozilo_imp_gu ADD CONSTRAINT vzgu_pk PRIMARY KEY (vzgu_br, agu_id, vzgu_rn);

-- Indexes on _t.vozilo_imp_gu
CREATE INDEX vzg_vzgu_br_i ON _t.vozilo_imp_gu (vzgu_br);
CREATE INDEX vzg_agu_id_i ON _t.vozilo_imp_gu (agu_id);
CREATE INDEX vzg_agu_oznaka_i ON _t.vozilo_imp_gu (agu_oznaka);
CREATE INDEX vzg_agp_naziv_i ON _t.vozilo_imp_gu (agp_naziv);
CREATE INDEX vzg_agh_oznaka_i ON _t.vozilo_imp_gu (agh_oznaka);
