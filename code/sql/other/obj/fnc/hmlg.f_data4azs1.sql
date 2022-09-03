DROP FUNCTION IF EXISTS hmlg.f_data4azs1(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_data4azs1(
                          pc_rec character varying DEFAULT NULL::character varying
                         )
  RETURNS character varying AS
$$
DECLARE

  vc_res character varying;

BEGIN

  SELECT '*'||'#'||
         p.kl_naziv||'#'||
         p.kl_adresa||'#'||
         coalesce(p.kl_telefon, '')||'#'||
         p.vz_sasija||'#'||
         coalesce(p.vzpv_oznaka||' - '||p.vzpv_naziv, '')||'#'||
         coalesce(p.vzk_oznaka, '')||CASE coalesce(p.vzdo_oznaka, '~') WHEN '~' THEN '' ELSE '/'||p.vzdo_oznaka END||'#'||
         coalesce(p.mr_naziv, '')||'#'||
         coalesce(p.mdt_oznaka, '')||'#'||
         coalesce(p.mdvr_oznaka, '')||'#'||
         coalesce(p.mdvz_oznaka, '')||'#'||
         coalesce(p.md_naziv_k, '')||'#'||
         coalesce(p.vz_masa_max, 0)||'#'||
         regexp_replace(coalesce(p.vz_os_nosivost, ''), '[ ]*/[ ]*', '#', 'g')||repeat('#0', 4-coalesce(p.vz_os_broj, 0))||'#'||
         coalesce(p.vz_masa, 0)||'#'||
         coalesce(p.vz_nosivost, 0)||'#'||
         coalesce(p.vz_os_broj, 0)||'#'||
         coalesce(p.vz_os_tockova, 0)||'#'||
         coalesce(p.vz_motor, '')||'#'||
         coalesce(p.mto_oznaka, '')||'#'||
         trim(to_char(coalesce(p.mt_cm3, 0), 'FM999999D999'), ',')||'#'||
         trim(to_char(coalesce(p.mt_kw, 0), 'FM999999D999'), ',')||'#'||
         coalesce(p.gr_naziv, '')||'#'||
         coalesce(p.vz_kw_kg, 0)||'#'||
         coalesce(p.vz_duzina, 0)||'#'||
         CASE coalesce(p.vz_elektro, 'N') WHEN 'D' THEN 'ДА' ELSE 'НЕ' END||'#'||
         coalesce(p.vz_mesta_sedenje, 0)||'#'||
         coalesce(p.vz_mesta_stajanje, 0)||'#'||
         coalesce(p.vz_max_brzina, 0)||'#'||
         coalesce(p.vz_godina, 0)||'#'||
         regexp_replace(coalesce(p.vz_os_pneumatici, ''), '[ ]{1,}/[ ]{1,}', '#', 'g')||repeat('#/', 4-coalesce(p.vz_os_broj, 0))||'#'||
         coalesce(p.vz_sirina, 0)||'#'||
         coalesce(p.vz_visina, 0)||'#'||
         coalesce(p.vz_km, 0)||'#'||
         CASE coalesce(p.vz_kuka, 'N') WHEN 'D' THEN 'ДА' ELSE 'НЕ' END||'#'||
         coalesce(p.em_naziv, '')||'#'||
         trim(to_char(coalesce(p.vz_co2, 0), 'FM999999D999'), ',')||'#'||
         coalesce(p.pr_napomena, '')||'#'||
         '*'||'#' AS s4as
    INTO vc_res
    FROM hmlg.v_predmet p
    WHERE p.pr_id=json_extract_path_text(pc_rec::json, 'pr_id')::integer;

  RETURN vc_res;

EXCEPTION

  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_data4azs1(character varying) OWNER TO postgres;
