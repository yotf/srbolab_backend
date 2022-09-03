DROP FUNCTION IF EXISTS hmlg.f_v_vz_vzdo_d(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_vz_vzdo_d(
                            pc_rec character varying DEFAULT NULL::character varying
                           )
  RETURNS integer AS
$$
DECLARE

  vn_res_rc INTEGER := 0;
  j_rec json := coalesce(pc_rec, '{}')::json;

BEGIN

  DELETE
    FROM hmlg.vz_vzdo t
    WHERE t.vz_id=json_extract_path_text(j_rec, 'vz_id')::integer
      AND t.vzdo_id=json_extract_path_text(j_rec, 'vzdo_id')::integer;
  GET DIAGNOSTICS vn_res_rc=ROW_COUNT;
  IF vn_res_rc>0 THEN
    RAISE INFO '%', 'Red je uspešno izbrisan.';
  END IF;

  RETURN vn_res_rc;

EXCEPTION
  WHEN foreign_key_violation THEN
    RAISE foreign_key_violation USING MESSAGE = 'Ta dodatna oznaka i vrsta vozila se koriste, ne mogu se izbrisati!';
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_vz_vzdo_d(character varying) OWNER TO postgres;
