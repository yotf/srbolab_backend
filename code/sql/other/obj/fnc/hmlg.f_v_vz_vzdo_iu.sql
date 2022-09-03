DROP FUNCTION IF EXISTS hmlg.f_v_vz_vzdo_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_vz_vzdo_iu(
                             pc_rec character varying
                            )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new hmlg.v_vz_vzdo;
  r_old hmlg.v_vz_vzdo;

  vb_ins boolean;
  vi_row_count integer := 0;
  vb_ok2updt boolean;

  vc_rec character varying;
  vi_id integer := 0;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::hmlg.v_vz_vzdo, j_rec) j;

  SELECT COUNT(*)=0
    INTO vb_ins
    FROM hmlg.vz_vzdo t
    WHERE t.vz_id=r_new.vz_id
      AND t.vzdo_id=r_new.vzdo_id;

  IF vb_ins THEN
    INSERT INTO hmlg.vz_vzdo (vz_id, vzdo_id)
      VALUES (r_new.vz_id, r_new.vzdo_id);
    GET DIAGNOSTICS vi_row_count=ROW_COUNT;
  END IF;

  IF vi_row_count>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_row_count;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vzdov_pk', 'i') IS NOT null THEN
      RAISE unique_violation USING MESSAGE = 'Takva veza vozila i dodatne oznake već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_vz_vzdo_iu(character varying) OWNER TO postgres;
