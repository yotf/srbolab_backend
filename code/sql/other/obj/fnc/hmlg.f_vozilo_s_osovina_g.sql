DROP FUNCTION IF EXISTS hmlg.f_vozilo_s_osovina_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_vozilo_s_osovina_g(
                                   pc_rec character varying DEFAULT NULL::character varying
                                 )
  RETURNS SETOF hmlg.vozilo_s_osovina AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM hmlg.vozilo_s_osovina t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::hmlg.vozilo_s_osovina, j_rec) r) j
                 WHERE t.vzs_id=j.vzs_id
                 ORDER BY t.vzs_id, t.vzos_rb
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_vozilo_s_osovina_g(character varying) OWNER TO postgres;
