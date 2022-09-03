DROP FUNCTION IF EXISTS hmlg.f_vozilo_s_osovina_d(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_vozilo_s_osovina_d(
                                   pc_rec character varying DEFAULT NULL::character varying
                                  )
  RETURNS integer AS
$$
DECLARE

  vn_res_rc INTEGER;
  j_rec json := coalesce(pc_rec, '{}')::json;

BEGIN

  DELETE
    FROM hmlg.vozilo_s_osovina t
    WHERE t.vzs_id=json_extract_path_text(j_rec, 'vzs_id')::integer
      AND t.vzos_rb=json_extract_path_text(j_rec, 'vzos_rb')::integer;
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
ALTER FUNCTION hmlg.f_vozilo_s_osovina_d(character varying) OWNER TO postgres;
