DROP FUNCTION IF EXISTS sif.f_motor_tip_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_motor_tip_g(
                                 pc_rec character varying DEFAULT NULL::character varying
                                )
  RETURNS SETOF sif.motor_tip AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.motor_tip t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.motor_tip, j_rec) r) j
                 WHERE t.mtt_id=coalesce(j.mtt_id, t.mtt_id)
                   AND t.mtt_oznaka ~* coalesce(j.mtt_oznaka, '.+')
                   AND t.mtt_naziv ~* coalesce(j.mtt_naziv, '.+')
                 ORDER BY t.mtt_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_motor_tip_g(character varying) OWNER TO postgres;
