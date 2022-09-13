DROP FUNCTION IF EXISTS sif.f_v_vzpv_vzkl_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_vzpv_vzkl_g(
                             pc_rec character varying DEFAULT NULL::character varying
                            )
  RETURNS SETOF sif.v_vzpv_vzkl AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM sif.v_vzpv_vzkl v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.v_vzpv_vzkl, j_rec) r) j
                 WHERE v.vzpv_id=j.vzpv_id
                   AND v.vzkl_oznaka ~* coalesce(j.vzkl_oznaka, '.+')
                   AND v.vzkl_naziv ~* coalesce(j.vzkl_naziv, '.+')
                 ORDER BY v.vzkl_oznaka
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_vzpv_vzkl_g(character varying) OWNER TO postgres;
