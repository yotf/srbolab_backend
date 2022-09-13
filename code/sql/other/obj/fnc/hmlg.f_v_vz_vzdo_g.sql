DROP FUNCTION IF EXISTS hmlg.f_v_vz_vzdo_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_vz_vzdo_g(
                            pc_rec character varying DEFAULT NULL::character varying
                           )
  RETURNS SETOF hmlg.v_vz_vzdo AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM hmlg.v_vz_vzdo v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.v_vz_vzdo, j_rec) r) j
                 WHERE v.vz_id=j.vz_id
                   AND v.vzdo_id=j.vzdo_id
                   AND v.vzv_oznaka ~* coalesce(j.vzdo_oznaka, '.+')
                   AND v.vzv_naziv ~* coalesce(j.vzdo_naziv, '.+')
                 ORDER BY v.vzdo_oznaka
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_vz_vzdo_g(character varying) OWNER TO postgres;
