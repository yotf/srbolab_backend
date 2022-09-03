DROP FUNCTION IF EXISTS sif.f_motor_oznaka_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_motor_oznaka_g(
                              pc_rec character varying DEFAULT NULL::character varying
                             )
  RETURNS SETOF sif.motor_oznaka AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.motor_oznaka t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.motor_oznaka, j_rec) r) j
                 WHERE t.mto_id=coalesce(j.mto_id, t.mto_id)
                   AND t.mto_oznaka ~* coalesce(j.mto_oznaka, '.+')
                 ORDER BY t.mto_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_motor_oznaka_g(character varying) OWNER TO postgres;
