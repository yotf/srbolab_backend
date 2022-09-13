DROP FUNCTION IF EXISTS sif.f_vozilo_karoserija_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_vozilo_karoserija_g(
                                   pc_rec character varying DEFAULT NULL::character varying
                                  )
  RETURNS SETOF sif.vozilo_karoserija AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.vozilo_karoserija t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.vozilo_karoserija, j_rec) r) j
                 WHERE t.vzk_id=coalesce(j.vzk_id, t.vzk_id)
                   AND t.vzk_oznaka ~* coalesce(j.vzk_oznaka, '.+')
                   AND t.vzk_naziv ~* coalesce(j.vzk_naziv, '.+')
                 ORDER BY t.vzk_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_vozilo_karoserija_g(character varying) OWNER TO postgres;
