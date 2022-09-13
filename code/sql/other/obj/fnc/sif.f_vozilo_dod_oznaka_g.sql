DROP FUNCTION IF EXISTS sif.f_vozilo_dod_oznaka_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_vozilo_dod_oznaka_g(
                                   pc_rec character varying DEFAULT NULL::character varying
                                  )
  RETURNS SETOF sif.vozilo_dod_oznaka AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.vozilo_dod_oznaka t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.vozilo_dod_oznaka, j_rec) r) j
                 WHERE t.vzdo_id=coalesce(j.vzdo_id, t.vzdo_id)
                   AND t.vzdo_oznaka ~* coalesce(j.vzdo_oznaka, '.+')
                   AND t.vzdo_naziv ~* coalesce(j.vzdo_naziv, '.+')
                 ORDER BY t.vzdo_oznaka
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_vozilo_dod_oznaka_g(character varying) OWNER TO postgres;
