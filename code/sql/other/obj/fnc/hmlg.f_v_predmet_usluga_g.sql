DROP FUNCTION IF EXISTS hmlg.f_v_predmet_usluga_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_predmet_usluga_g(
                                   pc_rec character varying DEFAULT NULL::character varying
                                  )
  RETURNS SETOF hmlg.v_predmet_usluga AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM hmlg.v_predmet_usluga t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::hmlg.v_predmet_usluga, j_rec) r) j
                 WHERE t.pr_id=j.pr_id::integer
                   AND t.us_oznaka ~* coalesce(j.us_oznaka, '.+')
                   AND t.us_naziv ~* coalesce(j.us_naziv, '.+')
                 ORDER BY t.arl_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_predmet_usluga_g(character varying) OWNER TO postgres;
