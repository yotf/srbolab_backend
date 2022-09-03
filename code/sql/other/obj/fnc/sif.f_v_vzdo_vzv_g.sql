DROP FUNCTION IF EXISTS sif.f_v_vzdo_vzv_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_vzdo_vzv_g(
                            pc_rec character varying DEFAULT NULL::character varying
                           )
  RETURNS SETOF sif.v_vzdo_vzv AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM sif.v_vzdo_vzv v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.v_vzdo_vzv, j_rec) r) j
                 WHERE v.vzdo_id=j.vzdo_id
                   AND v.vzv_oznaka ~* coalesce(j.vzv_oznaka, '.+')
                   AND v.vzv_naziv ~* coalesce(j.vzv_naziv, '.+')
                 ORDER BY v.vzv_oznaka
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_vzdo_vzv_g(character varying) OWNER TO postgres;
