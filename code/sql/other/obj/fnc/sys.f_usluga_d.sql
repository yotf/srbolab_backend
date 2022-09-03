DROP FUNCTION IF EXISTS sys.f_usluga_d(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_usluga_d(
                        pc_rec character varying DEFAULT NULL::character varying
                       )
  RETURNS integer AS
$$
DECLARE

  vn_res_rc INTEGER;
  j_rec json := coalesce(pc_rec, '{}')::json;

BEGIN

  DELETE
    FROM sys.usluga t
    WHERE t.us_id=json_extract_path_text(j_rec, 'us_id')::integer;
  GET DIAGNOSTICS vn_res_rc=ROW_COUNT;
  IF vn_res_rc>0 THEN
    RAISE INFO '%', 'Red je uspešno izbrisan.';
  END IF;

  RETURN vn_res_rc;

EXCEPTION
  WHEN foreign_key_violation THEN
    RAISE foreign_key_violation USING MESSAGE = 'Ta usluga se koristi, ne može se izbrisati!';
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_usluga_d(character varying) OWNER TO postgres;
