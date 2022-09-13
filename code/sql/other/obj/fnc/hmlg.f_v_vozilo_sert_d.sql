DROP FUNCTION IF EXISTS hmlg.f_v_vozilo_sert_d(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_vozilo_sert_d(
                                pc_rec character varying DEFAULT NULL::character varying
                               )
  RETURNS integer AS
$$
DECLARE

  vn_res_rc INTEGER := 0;
  j_rec json := coalesce(pc_rec, '{}')::json;

BEGIN

  DELETE
    FROM hmlg.vozilo_sert t
    WHERE t.vz_id=json_extract_path_text(j_rec, 'vzs_id')::integer;
  GET DIAGNOSTICS vn_res_rc=ROW_COUNT;
  IF vn_res_rc>0 THEN
    RAISE INFO '%', 'Red je uspešno izbrisan.';
  END IF;

  RETURN vn_res_rc;

EXCEPTION
  WHEN foreign_key_violation THEN
    RAISE foreign_key_violation USING MESSAGE = 'Taj sertifikat vozila se koristi, ne može se izbrisati!';
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_vozilo_sert_d(character varying) OWNER TO postgres;
