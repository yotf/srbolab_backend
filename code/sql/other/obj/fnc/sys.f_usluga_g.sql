DROP FUNCTION IF EXISTS sys.f_usluga_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_usluga_g(
                        pc_rec character varying DEFAULT NULL::character varying
                       )
  RETURNS SETOF sys.usluga AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sys.usluga t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sys.usluga, j_rec) r) j
                 WHERE t.us_id=coalesce(j.us_id, t.us_id)
                   AND t.us_oznaka ~* coalesce(j.us_oznaka, '.+')
                   AND t.us_naziv ~* coalesce(j.us_naziv, '.+')
                 ORDER BY t.us_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_usluga_g(character varying) OWNER TO postgres;
