DROP FUNCTION IF EXISTS adm.f_v_arl_afo_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_v_arl_afo_g(
                           pc_rec character varying DEFAULT NULL::character varying
                          )
  RETURNS SETOF adm.v_arl_afo AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM adm.v_arl_afo v
                   CROSS JOIN (SELECT r.* from json_populate_record(null::adm.v_arl_afo, j_rec) r) j
                 WHERE v.arl_id=j.arl_id
                   AND v.afo_id=coalesce(j.afo_id, v.afo_id)
                   AND v.afo_naziv ~* coalesce(j.afo_naziv, '.+')
                   AND v.aap_naziv ~* coalesce(j.aap_naziv, '.+')
                 ORDER BY v.afo_naziv
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_v_arl_afo_g(character varying) OWNER TO postgres;
