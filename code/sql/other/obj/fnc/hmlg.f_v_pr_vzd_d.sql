DROP FUNCTION IF EXISTS hmlg.f_v_pr_vzd_d(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_pr_vzd_d(
                           pc_rec character varying DEFAULT NULL::character varying
                          )
  RETURNS integer AS
$$
DECLARE

  vn_res_rc INTEGER;
  j_rec json := coalesce(pc_rec, '{}')::json;

BEGIN

  DELETE
    FROM hmlg.pr_vzd t
    WHERE t.pr_id=json_extract_path_text(j_rec, 'pr_id')::integer
      AND t.vzd_id=json_extract_path_text(j_rec, 'vzd_id')::integer;
  GET DIAGNOSTICS vn_res_rc=ROW_COUNT;
  IF vn_res_rc>0 THEN
    RAISE INFO '%', 'Red je uspešno izbrisan.';
  END IF;

  RETURN vn_res_rc;

EXCEPTION
  WHEN foreign_key_violation THEN
    RAISE foreign_key_violation USING MESSAGE = 'Taj dokument se koristi, ne može se izbrisati!';
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_pr_vzd_d(character varying) OWNER TO postgres;
