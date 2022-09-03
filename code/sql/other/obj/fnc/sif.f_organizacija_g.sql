DROP FUNCTION IF EXISTS sif.f_organizacija_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_organizacija_g(
                              pc_rec character varying DEFAULT NULL::character varying
                             )
  RETURNS SETOF sif.organizacija AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.organizacija t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.organizacija, j_rec) r) j
                 WHERE t.org_id=coalesce(j.org_id, t.org_id)
                   AND t.org_naziv ~* coalesce(j.org_naziv, '.+')
                   AND coalesce(t.org_napomena, '#') ~* coalesce(j.org_napomena, '.*')
                 ORDER BY t.org_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_organizacija_g(character varying) OWNER TO postgres;
