DROP FUNCTION IF EXISTS adm.f_c_adm_forma(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_c_adm_forma(
                           pc_rec character varying
                          )
  RETURNS SETOF adm.v_adm_forma AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vc_text character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'fromstart')::boolean, false)::boolean THEN '^' ELSE '' END||coalesce(json_extract_path_text(j_rec, 'text'), '.+');
  vc_re_opt character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'casesens')::boolean, false) THEN '' ELSE 'i' END;

BEGIN

  FOR r_rec IN SELECT v.afo_id,
                      v.afo_naziv,
                      v.aap_id,
                      v.aap_naziv
                 FROM adm.v_adm_forma v
                 WHERE NOT EXISTS
                        (
                         SELECT 1
                           FROM adm.arl_afo r
                           WHERE r.arl_id=json_extract_path_text(j_rec, 'arl_id')::integer
                             AND r.afo_id=v.afo_id
                        )
                   AND (
                        regexp_match(v.afo_naziv, vc_text, vc_re_opt) IS NOT NULL
                     OR regexp_match(v.aap_naziv, vc_text, vc_re_opt) IS NOT NULL
                       )
                 ORDER BY v.aap_id LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_c_adm_forma(character varying) OWNER TO postgres;
