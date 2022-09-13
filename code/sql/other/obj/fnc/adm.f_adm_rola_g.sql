DROP FUNCTION IF EXISTS adm.f_adm_rola_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_adm_rola_g(
                          pc_rec character varying DEFAULT NULL::character varying
                         )
  RETURNS SETOF adm.adm_rola AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM adm.adm_rola t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::adm.adm_rola, j_rec) r) j
                 WHERE t.arl_id=coalesce(j.arl_id, t.arl_id)
                   AND t.arl_naziv ~* coalesce(j.arl_naziv, '.+')
                 ORDER BY t.arl_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_adm_rola_g(character varying) OWNER TO postgres;
