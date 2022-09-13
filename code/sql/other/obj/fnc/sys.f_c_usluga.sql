DROP FUNCTION IF EXISTS sys.f_c_usluga(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_c_usluga(
                        pc_rec character varying
                       )
  RETURNS SETOF sys.usluga AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vc_text character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'fromstart')::boolean, false)::boolean THEN '^' ELSE '' END||coalesce(json_extract_path_text(j_rec, 'text'), '.+');
  vc_re_opt character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'casesens')::boolean, false) THEN '' ELSE 'i' END;

BEGIN

  FOR r_rec IN SELECT us.us_id,
                      us.us_oznaka,
                      us.us_naziv
                 FROM sys.korisnik kr
                   JOIN sys.arl_us arlus ON (arlus.arl_id=kr.arl_id)
                   JOIN sys.usluga us ON (us.us_id=arlus.us_id)
                 WHERE kr.kr_id=json_extract_path_text(j_rec, 'kr_id')::integer
                   AND regexp_match(us.us_oznaka, vc_text, vc_re_opt) IS NOT NULL
                   AND regexp_match(us.us_naziv, vc_text, vc_re_opt) IS NOT NULL
                 ORDER BY us.us_naziv LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_c_usluga(character varying) OWNER TO postgres;
