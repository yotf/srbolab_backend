DROP FUNCTION IF EXISTS adm.f_c_adm_rola(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_c_adm_rola(
                          pc_rec character varying
                         )
  RETURNS SETOF adm.adm_rola AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vc_text character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'fromstart')::boolean, false)::boolean THEN '^' ELSE '' END||coalesce(json_extract_path_text(j_rec, 'text'), '.+');
  vc_re_opt character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'casesens')::boolean, false) THEN '' ELSE 'i' END;

BEGIN

  FOR r_rec IN SELECT t.arl_id,
                      t.arl_naziv
                 FROM adm.adm_rola t
                 WHERE regexp_match(t.arl_naziv, vc_text, vc_re_opt) IS NOT NULL
                 ORDER BY t.arl_naziv LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_c_adm_rola(character varying) OWNER TO postgres;
