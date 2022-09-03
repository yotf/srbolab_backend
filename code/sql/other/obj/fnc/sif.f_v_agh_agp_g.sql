DROP FUNCTION IF EXISTS sif.f_v_agh_agp_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_agh_agp_g(
                           pc_rec character varying DEFAULT NULL::character varying
                          )
  RETURNS SETOF sif.v_agh_agp AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM sif.v_agh_agp v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.v_agh_agp, j_rec) r) j
                 WHERE v.agh_id=j.agh_id
                   AND v.agp_naziv ~* coalesce(j.agp_naziv, '.+')
                   AND coalesce(v.agp_napomena, '#') ~* coalesce(j.agp_napomena, '.*')
                 ORDER BY v.agp_naziv
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_agh_agp_g(character varying) OWNER TO postgres;
