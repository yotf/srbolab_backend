DROP FUNCTION IF EXISTS hmlg.f_v_potvrda_g(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_potvrda_g(
                            pc_rec varchar DEFAULT NULL::varchar
                           )
  RETURNS SETOF hmlg.v_potvrda AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM hmlg.v_potvrda v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::hmlg.v_potvrda, j_rec) r) j
                 WHERE v.pot_id=coalesce(j.pot_id::integer, v.pot_id)
                   AND public.f_compc(v.pot_broj, j.pot_broj)
                   AND public.f_compd(v.pot_datum, j.pot_datum)
                   AND public.f_compc(v.pr_broj, j.pr_broj)
                 ORDER BY v.pot_broj DESC, v.pot_datum DESC
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_potvrda_g(varchar) OWNER TO postgres;
