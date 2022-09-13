DROP FUNCTION IF EXISTS adm.f_v_adm_log_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_v_adm_log_g(
                           pc_rec character varying DEFAULT NULL::character varying
                          )
  RETURNS SETOF adm.v_adm_log AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM adm.v_adm_log t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::adm.v_adm_log, j_rec) r) j
                 WHERE t.alg_login ~* coalesce(j.alg_login, '.+')
                   AND t.kr_username ~* coalesce(j.kr_username, '.+')
                   AND t.kr_prezime ~* coalesce(j.kr_prezime, '.+')
                   AND t.kr_ime ~* coalesce(j.kr_ime, '.+')
                   AND t.alg_ip ~* coalesce(j.alg_ip, '.+')
                   AND t.lk_naziv ~* coalesce(j.lk_naziv, '.+')
                 ORDER BY t.alg_id DESC
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_v_adm_log_g(character varying) OWNER TO postgres;
