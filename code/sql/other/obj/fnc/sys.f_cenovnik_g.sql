DROP FUNCTION IF EXISTS sys.f_cenovnik_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_cenovnik_g(
                          pc_rec character varying DEFAULT NULL::character varying
                         )
  RETURNS SETOF sys.cenovnik AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sys.cenovnik t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sys.cenovnik, j_rec) r) j
                 WHERE t.ck_id=coalesce(j.ck_id, t.ck_id)
                   AND to_char(t.ck_datum, 'YYYY-MM-DD') ~* coalesce(to_char(j.ck_datum::date, 'YYYY-MM-DD'), '20[0-9]{2}-(0[1-9]|1[0-2])-(0[1-9]|2[1-8]|3[01])')
                   AND coalesce(t.ck_napomena, '#') ~* coalesce(j.ck_napomena, '.*')
                 ORDER BY t.ck_datum DESC
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_cenovnik_g(character varying) OWNER TO postgres;
