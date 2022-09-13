DROP FUNCTION IF EXISTS adm.f_adm_forma_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_adm_forma_g(
                           pc_rec character varying DEFAULT NULL::character varying
                          )
  RETURNS SETOF adm.adm_forma AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM adm.adm_forma t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::adm.adm_forma, j_rec) r) j
                 WHERE t.aap_id=coalesce(j.aap_id, t.aap_id)
                   AND t.afo_id=coalesce(j.afo_id, t.afo_id)
                   AND t.afo_naziv ~* coalesce(j.afo_naziv, '.+')
                 ORDER BY t.aap_id, t.afo_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_adm_forma_g(character varying) OWNER TO postgres;
