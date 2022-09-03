DROP FUNCTION IF EXISTS sif.f_v_vzk_vzpv_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_vzk_vzpv_g(
                            pc_rec character varying DEFAULT NULL::character varying
                           )
  RETURNS SETOF sif.v_vzk_vzpv AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM sif.v_vzk_vzpv v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.v_vzk_vzpv, j_rec) r) j
                 WHERE v.vzk_id=j.vzk_id
                   AND v.vzpv_oznaka ~* coalesce(j.vzpv_oznaka, '.+')
                   AND v.vzpv_naziv ~* coalesce(j.vzpv_naziv, '.+')
                 ORDER BY v.vzpv_oznaka
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_vzk_vzpv_g(character varying) OWNER TO postgres;
