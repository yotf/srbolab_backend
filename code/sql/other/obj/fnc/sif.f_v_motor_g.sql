DROP FUNCTION IF EXISTS sif.f_v_motor_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_motor_g(
                         pc_rec character varying DEFAULT NULL::character varying
                        )
  RETURNS SETOF sif.v_motor AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.v_motor t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.v_motor, j_rec) r) j
                 WHERE t.mt_id=coalesce(j.mt_id, t.mt_id)
                   AND t.mto_oznaka ~* coalesce(j.mto_oznaka, '.+')
                   AND coalesce(t.mt_cm3, 0)::character varying ~* coalesce(j.mt_cm3::character varying, '.+')
                   AND coalesce(t.mt_kw, 0)::character varying ~* coalesce(j.mt_kw::character varying, '.+')
--                   AND t.mtt_oznaka ~* coalesce(j.mtt_oznaka, '.+')
--                   AND t.mtt_naziv ~* coalesce(j.mtt_naziv, '.+')
                 ORDER BY t.mto_oznaka, t.mt_cm3, t.mt_kw
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_motor_g(character varying) OWNER TO postgres;
