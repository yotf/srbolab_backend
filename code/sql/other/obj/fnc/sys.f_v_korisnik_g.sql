DROP FUNCTION IF EXISTS sys.f_v_korisnik_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_v_korisnik_g(
                            pc_rec character varying DEFAULT NULL::character varying
                           )
  RETURNS SETOF sys.v_korisnik AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM sys.v_korisnik v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sys.v_korisnik, j_rec) r) j
                 WHERE v.kr_id=coalesce(j.kr_id, v.kr_id)
                   AND v.kr_prezime ~* coalesce(j.kr_prezime, '.+')
                   AND v.kr_ime ~* coalesce(j.kr_ime, '.+')
                   AND v.kr_username ~* coalesce(j.kr_username, '.+')
                   AND v.kr_aktivan ~* coalesce(j.kr_aktivan, '[DN]')
                   AND v.arl_naziv ~* coalesce(j.arl_naziv, '.+')
                 ORDER BY v.kr_prezime, v.kr_ime
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_v_korisnik_g(character varying) OWNER TO postgres;
