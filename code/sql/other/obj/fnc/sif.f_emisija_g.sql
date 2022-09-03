DROP FUNCTION IF EXISTS sif.f_emisija_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_emisija_g(
                         pc_rec character varying DEFAULT NULL::character varying
                        )
  RETURNS SETOF sif.emisija AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.emisija t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.emisija, j_rec) r) j
                 WHERE t.em_id=COALESCE(j.em_id, t.em_id)
                   AND t.em_naziv ~* COALESCE(j.em_naziv, '.+')
                 ORDER BY t.em_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_emisija_g(character varying) OWNER TO postgres;
