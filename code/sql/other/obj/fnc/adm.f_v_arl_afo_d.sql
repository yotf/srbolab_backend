DROP FUNCTION IF EXISTS adm.f_v_arl_afo_d(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_v_arl_afo_d(
                           pc_rec character varying DEFAULT NULL::character varying
                          )
  RETURNS integer AS
$$
DECLARE

  vn_res_rc INTEGER := 0;
  j_rec json := coalesce(pc_rec, '{}')::json;

BEGIN

  DELETE
    FROM adm.arl_afo t
    WHERE t.arl_id=json_extract_path_text(j_rec, 'arl_id')::integer
      AND t.afo_id=json_extract_path_text(j_rec, 'afo_id')::integer;
  GET DIAGNOSTICS vn_res_rc=ROW_COUNT;
  IF vn_res_rc>0 THEN
    RAISE INFO '%', 'Red je uspešno izbrisan.';
  END IF;

  RETURN vn_res_rc;

EXCEPTION
  WHEN foreign_key_violation THEN
    RAISE foreign_key_violation USING MESSAGE = 'Ta rola i forma se koriste, ne mogu se izbrisati!';
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_v_arl_afo_d(character varying) OWNER TO postgres;
