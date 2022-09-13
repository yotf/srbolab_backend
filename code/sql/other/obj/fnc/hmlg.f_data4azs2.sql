DROP FUNCTION IF EXISTS hmlg.f_data4azs2(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_data4azs2(
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
         coalesce(p.mr_naziv, '')||'#'||
         coalesce(p.mdt_oznaka, '')||'/'||coalesce(p.mdvr_oznaka, '')||'/'||coalesce(p.mdvz_oznaka, '')||'#'||
         coalesce(p.md_naziv_k, '')||'#'||
         p.vz_sasija||'#'||
         coalesce(p.vz_masa_max, 0)||'#'||
         coalesce(p.vz_masa, 0)||'#'||
         trim(to_char(coalesce(p.mt_cm3, 0), 'FM999999D999'), ',')||'#'||
         trim(to_char(coalesce(p.mt_kw, 0), 'FM999999D999'), ',')||'#'||
         coalesce(p.gr_naziv, '')||'#'||
         coalesce(p.vz_mesta_sedenje, 0)||'#'||
         coalesce(p.vz_mesta_stajanje, 0)||'#'||
         coalesce(p.vz_motor, '')||'#'||
         coalesce(p.mto_oznaka, '')||'#'||
         coalesce(p.vz_os_broj, 0)||'#'||
         coalesce(p.vzk_oznaka, '')||CASE coalesce(p.vzdo_oznaka, '~') WHEN '~' THEN '' ELSE '/'||p.vzdo_oznaka END||'#'||
         coalesce(p.vz_max_brzina, 0)||'#'||
         regexp_replace(coalesce(p.vz_os_pneumatici, ''), '([-][ ]+|[ ]+[-])', '', 'g')||'#'||
         coalesce(p.pr_zakljucak, '')||'#'||
         trim(coalesce(k.kr_prezime, '')||' '||coalesce(k.kr_ime, '')) AS s4as
    INTO vc_res
    FROM hmlg.v_predmet p
      LEFT JOIN sys.korisnik k ON (k.kr_id=p.kr_id_p) 
    WHERE p.pr_id=json_extract_path_text(pc_rec::json, 'pr_id')::integer;

  RETURN vc_res;

EXCEPTION

  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_data4azs2(character varying) OWNER TO postgres;
