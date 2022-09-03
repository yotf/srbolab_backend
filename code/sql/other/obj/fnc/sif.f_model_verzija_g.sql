DROP FUNCTION IF EXISTS sif.f_model_verzija_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_model_verzija_g(
                               pc_rec character varying DEFAULT NULL::character varying
                              )
  RETURNS SETOF sif.model_verzija AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.model_verzija t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.model_verzija, j_rec) r) j
                 WHERE t.mdvz_id=coalesce(j.mdvz_id, t.mdvz_id)
                   AND t.mdvz_oznaka ~* coalesce(public.f_str4re(j.mdvz_oznaka), '.+')
                 ORDER BY t.mdvz_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_model_verzija_g(character varying) OWNER TO postgres;
