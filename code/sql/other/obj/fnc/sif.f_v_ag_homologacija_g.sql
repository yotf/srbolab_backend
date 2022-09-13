DROP FUNCTION IF EXISTS sif.f_v_ag_homologacija_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_ag_homologacija_g(
                                   pc_rec character varying DEFAULT NULL::character varying
                                  )
  RETURNS SETOF sif.v_ag_homologacija AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.v_ag_homologacija t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.v_ag_homologacija, j_rec) r) j
                 WHERE t.agh_id=coalesce(j.agh_id, t.agh_id)
                   AND t.agh_oznaka ~* coalesce(j.agh_oznaka, '.+')
                   AND t.agu_oznaka ~* coalesce(j.agu_oznaka, '.+')
                   AND t.agu_naziv ~* coalesce(j.agu_naziv, '.+')
                 ORDER BY t.agu_oznaka, t.agh_oznaka
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_ag_homologacija_g(character varying) OWNER TO postgres;
