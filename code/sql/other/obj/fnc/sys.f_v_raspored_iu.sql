DROP FUNCTION IF EXISTS sys.f_v_raspored_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_v_raspored_iu(
                             pc_rec character varying
                            )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sys.v_raspored;
  r_old sys.v_raspored;

  vi_row_count integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sys.v_raspored, j_rec) j;

  SELECT COUNT(*)=0
    INTO vb_ins
    FROM sys.raspored t
    WHERE t.kn_datum=r_new.kn_datum::date
      AND t.kr_id=r_new.kr_id;

  IF vb_ins THEN
    INSERT INTO sys.raspored (kn_datum, kr_id, lk_id, rs_napomena)
      VALUES (r_new.kn_datum::date, r_new.kr_id, r_new.lk_id, r_new.rs_napomena);
  ELSE
    SELECT t.kn_datum,
           t.lk_id,
           t.lk_naziv,
           t.kr_id,
           t.kr_prezime,
           t.kr_ime,
           t.rs_napomena
      INTO r_old
      FROM sys.v_raspored t
      WHERE t.kn_datum::date=r_new.kn_datum::date
        AND t.kr_id=r_new.kr_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sys.raspored t
        SET lk_id=r_new.lk_id,
            rs_napomena=r_new.rs_napomena
        WHERE t.kn_datum=r_new.kn_datum::date
          AND t.kr_id=r_new.kr_id;
      GET DIAGNOSTICS vi_row_count=ROW_COUNT;
    END IF;
  END IF;

  IF vi_row_count>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_row_count;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'rs_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Taj korisnik je već raspoređen!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_v_raspored_iu(character varying) OWNER TO postgres;
