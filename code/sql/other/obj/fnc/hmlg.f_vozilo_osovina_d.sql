DROP FUNCTION IF EXISTS hmlg.f_vozilo_osovina_d(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_vozilo_osovina_d(
                                 pc_rec character varying DEFAULT NULL::character varying
                                )
  RETURNS integer AS
$$
DECLARE

  vn_res_rc INTEGER;
  j_rec json := coalesce(pc_rec, '{}')::json;

BEGIN

  DELETE
    FROM hmlg.vozilo_osovina t
    WHERE t.vz_id=json_extract_path_text(j_rec, 'vz_id')::integer
      AND t.vzo_rb=json_extract_path_text(j_rec, 'vzo_rb')::integer;
  GET DIAGNOSTICS vn_res_rc=ROW_COUNT;
  IF vn_res_rc>0 THEN
    RAISE INFO '%', 'Red je uspešno izbrisan.';
  END IF;

  RETURN vn_res_rc;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_vozilo_osovina_d(character varying) OWNER TO postgres;
