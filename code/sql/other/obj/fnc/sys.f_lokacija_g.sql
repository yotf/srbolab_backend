DROP FUNCTION IF EXISTS sys.f_lokacija_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_lokacija_g(
                          pc_rec character varying DEFAULT NULL::character varying
                         )
  RETURNS SETOF sys.lokacija AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sys.lokacija t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sys.lokacija, j_rec) r) j
                 WHERE t.lk_id=coalesce(j.lk_id, t.lk_id)
                   AND t.lk_naziv ~* coalesce(j.lk_naziv, '.+')
                   AND t.lk_naziv_l ~* coalesce(j.lk_naziv_l, '.+')
                   AND t.lk_ip ~* coalesce(j.lk_ip, '.+')
                   AND t.lk_aktivna ~* coalesce(j.lk_aktivna, '[DN]')
                 ORDER BY t.lk_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_lokacija_g(character varying) OWNER TO postgres;
