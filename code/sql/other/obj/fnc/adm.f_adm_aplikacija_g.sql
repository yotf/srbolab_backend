DROP FUNCTION IF EXISTS adm.f_adm_aplikacija_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_adm_aplikacija_g(
                           pc_rec character varying DEFAULT NULL::character varying
                          )
  RETURNS SETOF adm.adm_aplikacija AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM adm.adm_aplikacija t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::adm.adm_aplikacija, j_rec) r) j
                 WHERE t.aap_id=coalesce(j.aap_id, t.aap_id)
                   AND t.aap_naziv ~* coalesce(j.aap_naziv, '.+')
                 ORDER BY t.aap_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_adm_aplikacija_g(character varying) OWNER TO postgres;
