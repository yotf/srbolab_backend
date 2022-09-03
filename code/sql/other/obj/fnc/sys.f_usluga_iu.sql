DROP FUNCTION IF EXISTS sys.f_usluga_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_usluga_iu(
                         pc_rec character varying
                        )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sys.usluga;
  r_old sys.usluga;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sys.usluga, j_rec) j;

  vb_ins := r_new.us_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.us_id), 0)+1
      INTO vi_id
      FROM sys.usluga t;

    r_new.us_id := vi_id;

    INSERT INTO sys.usluga (us_id, us_oznaka, us_naziv)
      VALUES (r_new.us_id, r_new.us_oznaka, r_new.us_naziv);
  ELSE
    SELECT t.us_id,
           t.us_oznaka,
           t.us_naziv
      INTO r_old
      FROM sys.usluga t
      WHERE t.us_id=r_new.us_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sys.usluga t
        SET us_oznaka=r_new.us_oznaka,
            us_naziv=r_new.us_naziv
        WHERE t.us_id=r_new.us_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'us_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID usluge već postoji!';
    ELSEIF regexp_match(sqlerrm, 'us_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Usluga sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_usluga_iu(character varying) OWNER TO postgres;
