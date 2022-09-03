DROP FUNCTION IF EXISTS sif.f_motor_tip_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_motor_tip_iu(
                            pc_rec character varying
                           )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.motor_tip;
  r_old sif.motor_tip;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.motor_tip, j_rec) j;

  vb_ins := r_new.mtt_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.mtt_id), 0)+1
      INTO vi_id
      FROM sif.motor_tip t;

    r_new.mtt_id := vi_id;

    INSERT INTO sif.motor_tip (mtt_id, mtt_oznaka, mtt_naziv)
      VALUES (r_new.mtt_id, r_new.mtt_oznaka, r_new.mtt_naziv);
  ELSE
    SELECT t.mtt_id,
           t.mtt_oznaka,
           t.mtt_naziv
      INTO r_old
      FROM sif.motor_tip t
      WHERE t.mtt_id=r_new.mtt_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.motor_tip t
        SET mtt_oznaka=r_new.mtt_oznaka,
            mtt_naziv=r_new.mtt_naziv
        WHERE t.mtt_id=r_new.mtt_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'mtt_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID tipa motora već postoji!';
    ELSEIF regexp_match(sqlerrm, 'mtt_oznaka', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Tip motora sa tom oznakom već postoji!';
    ELSEIF regexp_match(sqlerrm, 'mtt_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Tip motora sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_motor_tip_iu(character varying) OWNER TO postgres;
