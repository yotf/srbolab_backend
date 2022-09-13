DROP FUNCTION IF EXISTS sif.f_model_tip_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_model_tip_g(
                           pc_rec character varying DEFAULT NULL::character varying
                          )
  RETURNS SETOF sif.model_tip AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.model_tip t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.model_tip, j_rec) r) j
                 WHERE t.mdt_id=coalesce(j.mdt_id, t.mdt_id)
                   AND t.mdt_oznaka ~* coalesce(public.f_str4re(j.mdt_oznaka), '.+')
                 ORDER BY t.mdt_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_model_tip_g(character varying) OWNER TO postgres;
