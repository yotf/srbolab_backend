DROP FUNCTION IF EXISTS hmlg.f_predmet_status_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_predmet_status_g(
                                 pc_rec character varying DEFAULT NULL::character varying
                                )
  RETURNS SETOF hmlg.predmet_status AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM hmlg.predmet_status t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::hmlg.predmet_status, j_rec) r) j
                 WHERE t.prs_id=coalesce(j.prs_id, t.prs_id)
                 ORDER BY t.prs_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_predmet_status_g(character varying) OWNER TO postgres;
