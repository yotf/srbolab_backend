DROP FUNCTION IF EXISTS hmlg.f_v_predmet_g(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_predmet_g(
                            pc_rec varchar DEFAULT NULL::varchar
                           )
  RETURNS SETOF hmlg.v_predmet AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM hmlg.v_predmet v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::hmlg.v_predmet, j_rec) r) j
                   CROSS JOIN (SELECT r1.* FROM json_to_record(j_rec) AS r1 (pr_datum_to varchar, pr_datum_zak_to varchar)) j1
                 WHERE v.pr_id=coalesce(j.pr_id::integer, v.pr_id)
                   AND public.f_compc(v.vzs_oznaka, j.vzs_oznaka)
                   AND public.f_compc(v.pr_broj, j.pr_broj)
                   AND public.f_compd(v.pr_datum, j.pr_datum)
                   AND public.f_compd(v.pr_datum_zak, j.pr_datum_zak)
                   AND public.f_compc(v.pus_oznaka, j.pus_oznaka)
                   AND public.f_compc(v.pvd_oznaka, j.pvd_oznaka)
                   AND public.f_compc(v.prs_oznaka, j.prs_oznaka)
                   AND public.f_compc(v.prs_naziv, j.prs_naziv)
                   AND public.f_compc(v.kl_naziv, j.kl_naziv)
                   AND public.f_compc(v.kl_adresa, j.kl_adresa)
                   AND coalesce(v.kl_firma, '*') ILIKE coalesce(j.kl_firma, v.kl_firma)
                   AND public.f_compc(v.pr_napomena, j.pr_napomena)
                   AND public.f_compc(v.pr_primedbe, j.pr_primedbe)
                   AND public.f_compc(v.pr_zakljucak, j.pr_zakljucak)
                   AND public.f_compc(v.vz_reg, j.vz_reg)
                   AND public.f_compc(v.vz_sasija, j.vz_sasija)
                   AND public.f_compc(v.vz_sasija_10, j.vz_sasija_10)
                   AND public.f_compc(v.vz_motor, j.vz_motor)
                   AND public.f_compc(v.mr_naziv, j.mr_naziv)
                   AND public.f_compc(v.md_naziv_k, j.md_naziv_k)
                   AND public.f_compc(v.vzpv_oznaka, j.vzpv_oznaka)
                   AND public.f_compc(v.vzpv_naziv, j.vzpv_naziv)
                   AND public.f_compc(v.vzk_oznaka, j.vzk_oznaka)
                   AND public.f_compc(v.vzdo_oznaka, j.vzdo_oznaka)
                   AND public.f_compc(v.vzkl_oznaka, j.vzkl_oznaka)
                   AND public.f_compc(v.vzkl_naziv, j.vzkl_naziv)
                   AND public.f_compc(v.mdt_oznaka, j.mdt_oznaka)
                   AND public.f_compc(v.mdvr_oznaka, j.mdvr_oznaka)
                   AND public.f_compc(v.mdvz_oznaka, j.mdvz_oznaka)
                   AND public.f_compc(v.mto_oznaka, j.mto_oznaka)
                   AND public.f_compn(v.mt_cm3::numeric, j.mt_cm3::numeric)
                   AND public.f_compn(v.mt_kw::numeric, j.mt_kw::numeric)
                   AND public.f_compc(v.gr_naziv, j.gr_naziv)
                   AND public.f_compc(v.em_naziv, j.em_naziv)
                   AND public.f_compn(v.vz_os_broj::numeric, j.vz_os_broj::numeric)
                   AND public.f_compn(v.vz_os_tockova::numeric, j.vz_os_tockova::numeric)
                   AND public.f_compc(v.vz_os_nosivost, j.vz_os_nosivost)
                   AND public.f_compc(v.vz_os_pneumatici, j.vz_os_pneumatici)
                   AND public.f_compn(v.vz_mesta_sedenje::numeric, j.vz_mesta_sedenje::numeric)
                   AND public.f_compn(v.vz_mesta_stajanje::numeric, j.vz_mesta_stajanje::numeric)
                   AND public.f_compn(v.vz_masa::numeric, j.vz_masa::numeric)
                   AND public.f_compn(v.vz_nosivost::numeric, j.vz_nosivost::numeric)
                   AND public.f_compn(v.vz_masa_max::numeric, j.vz_masa_max::numeric)
                   AND public.f_compn(v.vz_duzina::numeric, j.vz_duzina::numeric)
                   AND public.f_compn(v.vz_sirina::numeric, j.vz_sirina::numeric)
                   AND public.f_compn(v.vz_visina::numeric, j.vz_visina::numeric)
                   AND public.f_compn(v.vz_co2::numeric, j.vz_co2::numeric)
                   AND coalesce(v.vz_elektro, '*') ILIKE coalesce(j.vz_elektro, v.vz_elektro)
                   AND coalesce(v.vz_kuka, '*') ILIKE coalesce(j.vz_kuka, v.vz_kuka)
                 ORDER BY v.pr_datum::date DESC, v.pr_broj DESC
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_predmet_g(varchar) OWNER TO postgres;
