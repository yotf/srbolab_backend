DROP FUNCTION IF EXISTS hmlg.f_v_vzs_vzk_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_vzs_vzk_iu(
                             pc_rec character varying
                            )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new hmlg.v_vzs_vzk;

  vb_ins boolean;
  vi_row_count integer := 0;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::hmlg.v_vzs_vzk, j_rec) j;

  SELECT COUNT(*)=0
    INTO vb_ins
    FROM hmlg.vzs_vzk t
    WHERE t.vzs_id=r_new.vzs_id
      AND t.vzk_id=r_new.vzk_id;

  IF vb_ins THEN
    INSERT INTO hmlg.vzs_vzk (vzs_id, vzk_id)
      VALUES (r_new.vzs_id, r_new.vzk_id);
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
ALTER FUNCTION hmlg.f_v_vzs_vzk_iu(character varying) OWNER TO postgres;
