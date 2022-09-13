DROP FUNCTION IF EXISTS sif.f_model_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_model_g(
                       pc_rec character varying DEFAULT NULL::character varying
                      )
  RETURNS SETOF sif.model AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.model t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.model, j_rec) r) j
                 WHERE t.mr_id=coalesce(j.mr_id, t.mr_id)
                   AND t.md_id=coalesce(j.md_id, t.md_id)
                   AND t.md_naziv_k ~* coalesce(j.md_naziv_k, '.+')
                 ORDER BY t.md_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_model_g(character varying) OWNER TO postgres;
