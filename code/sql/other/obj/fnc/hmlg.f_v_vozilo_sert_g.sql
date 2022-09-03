DROP FUNCTION IF EXISTS hmlg.f_v_vozilo_sert_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_vozilo_sert_g(
                                pc_rec character varying DEFAULT NULL::character varying
                               )
  RETURNS SETOF hmlg.v_vozilo_sert AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM hmlg.v_vozilo_sert v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::hmlg.v_vozilo_sert, j_rec) r) j
                 WHERE v.vzs_id=coalesce(j.vzs_id, v.vzs_id)
                   AND public.f_compc(v.vzs_oznaka, j.vzs_oznaka)
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
                   AND public.f_compn(v.vzs_os_broj::numeric, j.vzs_os_broj::numeric)
                   AND public.f_compn(v.vzs_os_tockova::numeric, j.vzs_os_tockova::numeric)
                   AND public.f_compc(v.vzs_os_nosivost, j.vzs_os_nosivost)
                   AND public.f_compc(v.vzs_os_pneumatici, j.vzs_os_pneumatici)
                   AND public.f_compn(v.vzs_mesta_sedenje::numeric, j.vzs_mesta_sedenje::numeric)
                   AND public.f_compn(v.vzs_mesta_stajanje::numeric, j.vzs_mesta_stajanje::numeric)
                   AND public.f_compn(v.vzs_masa::numeric, j.vzs_masa::numeric)
                   AND public.f_compn(v.vzs_nosivost::numeric, j.vzs_nosivost::numeric)
                   AND public.f_compn(v.vzs_masa_max::numeric, j.vzs_masa_max::numeric)
                   AND public.f_compn(v.vzs_duzina::numeric, j.vzs_duzina::numeric)
                   AND public.f_compn(v.vzs_sirina::numeric, j.vzs_sirina::numeric)
                   AND public.f_compn(v.vzs_visina::numeric, j.vzs_visina::numeric)
                   AND public.f_compn(v.vzs_co2::numeric, j.vzs_co2::numeric)
                 ORDER BY v.vzs_id DESC, v.vzs_oznaka DESC, v.mr_naziv, v.md_naziv_k
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_vozilo_sert_g(character varying) OWNER TO postgres;
