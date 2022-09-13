DROP FUNCTION IF EXISTS sif.f_vozilo_dokument_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_vozilo_dokument_g(
                                 pc_rec character varying DEFAULT NULL::character varying
                                )
  RETURNS SETOF sif.vozilo_dokument AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.vozilo_dokument t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.vozilo_dokument, j_rec) r) j
                 WHERE t.vzd_id=coalesce(j.vzd_id, t.vzd_id)
                   AND t.vzd_oznaka ~* coalesce(j.vzd_oznaka, '.+')
                   AND t.vzd_naziv ~* coalesce(j.vzd_naziv, '.+')
                 ORDER BY t.vzd_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_vozilo_dokument_g(character varying) OWNER TO postgres;
