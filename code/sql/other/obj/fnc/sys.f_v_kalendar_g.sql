DROP FUNCTION IF EXISTS sys.f_kalendar_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_v_kalendar_g(
                            pc_rec character varying DEFAULT NULL::character varying
                           )
  RETURNS SETOF sys.v_kalendar AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sys.v_kalendar t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sys.v_kalendar, j_rec) r) j
                 WHERE t.kn_datum=coalesce(j.kn_datum, t.kn_datum)
                   AND t.kn_dan ~* coalesce(j.kn_dan, '.+')
                   AND coalesce(t.kn_napomena, '#') ~* coalesce(j.kn_napomena, '.*')
                 ORDER BY t.kn_datum::date DESC
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_v_kalendar_g(character varying) OWNER TO postgres;
