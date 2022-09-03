DROP FUNCTION IF EXISTS adm.f_adm_login(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_adm_login(
                         pc_rec character varying DEFAULT NULL::character varying
                        )
  RETURNS integer AS
$$
DECLARE

  vi_res INTEGER;
  j_rec json := coalesce(pc_rec, '{}')::json;

BEGIN

  SELECT CASE coalesce(max(kr.kr_aktivan), 'X')
           WHEN 'X' THEN -100 -- invalid username or password
           WHEN 'N' THEN -200 -- user is not active
           WHEN 'D' THEN max(kr.kr_id) -- ok
           ELSE -900 -- unknown error
         END AS kr_id
    INTO vi_res
    FROM sys.korisnik kr
    WHERE kr.kr_username=json_extract_path_text(j_rec, 'kr_username')
      AND kr.kr_password=`public.f_str_encode(json_extract_path_text(j_rec, 'kr_username')||json_extract_path_text(j_rec, 'kr_password'));

  IF vi_res>0 THEN
    INSERT INTO adm.adm_log (alg_id, alg_ip, alg_login, alg_logout, alg_token, kr_id)
      SELECT now()::varchar AS alg_id,
             coalesce(json_extract_path_text(j_rec, 'alg_ip'), '127.0.0.1') AS alg_ip,
             now() AS alg_login,
             null AS alg_logout,
             coalesce(json_extract_path_text(j_rec, 'alg_token'), encode(sha256((now()::text)::bytea), 'hex')) AS alg_token,
             vi_res AS kr_id;
  END IF;

  RETURN vi_res;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_adm_login(character varying) OWNER TO postgres;
