DROP FUNCTION IF EXISTS sys.f_c_korisnik(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_c_korisnik(
                          pc_rec character varying
                         )
  RETURNS SETOF sys.v_korisnik AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vc_text character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'fromstart')::boolean, false)::boolean THEN '^' ELSE '' END||coalesce(json_extract_path_text(j_rec, 'text'), '.+');
  vc_re_opt character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'casesens')::boolean, false) THEN '' ELSE 'i' END;

BEGIN

  FOR r_rec IN SELECT v.kr_id,
                      v.kr_prezime,
                      v.kr_ime,
                      v.kr_username,
                      v.kr_password,
                      v.kr_aktivan,
                      v.arl_id,
                      v.arl_naziv
                 FROM sys.v_korisnik v
                 WHERE v.kr_aktivan='D'
                   AND NOT EXISTS
                        (
                         SELECT 1
                           FROM sys.raspored r
                           WHERE r.kn_datum=json_extract_path_text(j_rec, 'kn_datum')::date
                             AND r.kr_id=v.kr_id
                        )
                   AND (
                        regexp_match(v.kr_prezime, vc_text, vc_re_opt) IS NOT NULL
                     OR regexp_match(v.kr_ime, vc_text, vc_re_opt) IS NOT NULL
                     OR regexp_match(v.kr_username, vc_text, vc_re_opt) IS NOT NULL
                       )
                 ORDER BY v.kr_prezime LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_c_korisnik(character varying) OWNER TO postgres;
