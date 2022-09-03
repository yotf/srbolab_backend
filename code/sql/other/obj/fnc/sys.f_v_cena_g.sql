DROP FUNCTION IF EXISTS sys.f_v_cena_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_v_cena_g(
                        pc_rec character varying DEFAULT NULL::character varying
                       )
  RETURNS SETOF sys.v_cena AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sys.v_cena t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sys.v_cena, j_rec) r) j
                 WHERE t.ck_id=j.ck_id
                   AND t.us_naziv ~* coalesce(j.us_naziv, '.+')
                 ORDER BY t.us_id, t.cn_cena
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_v_cena_g(character varying) OWNER TO postgres;
