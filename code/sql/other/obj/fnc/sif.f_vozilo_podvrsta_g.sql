DROP FUNCTION IF EXISTS sif.f_vozilo_podvrsta_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_vozilo_podvrsta_g(
                                 pc_rec character varying DEFAULT NULL::character varying
                                )
  RETURNS SETOF sif.vozilo_podvrsta AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.vozilo_podvrsta t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.vozilo_podvrsta, j_rec) r) j
                 WHERE t.vzpv_id=coalesce(j.vzpv_id, t.vzpv_id)
                   AND t.vzv_id=coalesce(j.vzv_id, t.vzv_id)
                   AND t.vzpv_oznaka ~* coalesce(j.vzpv_oznaka, '.+')
                   AND t.vzpv_naziv ~* coalesce(j.vzpv_naziv, '.+')
                 ORDER BY t.vzpv_oznaka
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_vozilo_podvrsta_g(character varying) OWNER TO postgres;
