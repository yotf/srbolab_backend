DROP FUNCTION IF EXISTS sif.f_v_agp_agh_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_agp_agh_g(
                           pc_rec character varying DEFAULT NULL::character varying
                          )
  RETURNS SETOF sif.v_agp_agh AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM sif.v_agp_agh v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.v_agp_agh, j_rec) r) j
                 WHERE v.agh_id=j.agp_id
                   AND v.agu_oznaka ~* coalesce(j.agu_oznaka, '.+')
                   AND v.agu_naziv ~* coalesce(j.agu_naziv, '.+')
                   AND v.agh_oznaka ~* coalesce(j.agh_oznaka, '.+')
                 ORDER BY v.agu_oznaka, v.agh_oznaka
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_agp_agh_g(character varying) OWNER TO postgres;
