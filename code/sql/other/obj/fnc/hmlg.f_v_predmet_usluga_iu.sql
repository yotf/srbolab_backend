DROP FUNCTION IF EXISTS hmlg.f_v_predmet_usluga_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_predmet_usluga_iu(
                                    pc_rec character varying
                                   )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new hmlg.v_predmet_usluga;

  vb_ins boolean;
  vi_row_count integer := 0;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::hmlg.v_predmet_usluga, j_rec) j;

  SELECT COUNT(*)=0
    INTO vb_ins
    FROM hmlg.v_predmet_usluga t
    WHERE t.pr_id=r_new.pr_id
      AND t.us_id=r_new.us_id;

  IF vb_ins THEN
    INSERT INTO hmlg.predmet_usluga (pr_id, us_id)
      VALUES (r_new.pr_id, r_new.us_id);
    GET DIAGNOSTICS vi_row_count=ROW_COUNT;
  END IF;

  IF vi_row_count>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_row_count;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'prus_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID usluge već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_predmet_usluga_iu(character varying) OWNER TO postgres;
