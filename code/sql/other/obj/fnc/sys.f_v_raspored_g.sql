DROP FUNCTION IF EXISTS sys.f_v_raspored_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_v_raspored_g(
                            pc_rec character varying DEFAULT NULL::character varying
                           )
  RETURNS SETOF sys.v_raspored AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM sys.v_raspored v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sys.v_raspored, j_rec) r) j
                 WHERE v.kn_datum::date=coalesce(j.kn_datum::date, v.kn_datum::date)
                   AND v.lk_naziv ~* coalesce(j.lk_naziv, '.+')
                   AND v.kr_prezime ~* coalesce(j.kr_prezime, '.+')
                   AND v.kr_ime ~* coalesce(j.kr_ime, '.+')
                   AND coalesce(v.rs_napomena, '#') ~* coalesce(j.rs_napomena, '.+')
                 ORDER BY v.lk_naziv, v.kr_prezime, v.kr_ime
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_v_raspored_g(character varying) OWNER TO postgres;
