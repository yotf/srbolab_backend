DROP FUNCTION IF EXISTS sif.f_motor_oznaka_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_motor_oznaka_iu(
                               pc_rec character varying
                              )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.motor_oznaka;
  r_old sif.motor_oznaka;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.mto_id,
         upper(coalesce(j.mto_oznaka, '-')) AS mto_oznaka
    INTO r_new
    FROM json_populate_record(null::sif.motor_oznaka, j_rec) j;

  SELECT max(t.mto_id)
    INTO r_new.mto_id
    FROM sif.motor_oznaka t
    WHERE t.mto_oznaka=r_new.mto_oznaka;

  vb_ins := r_new.mto_id IS NULL;

  IF vb_ins THEN
    SELECT coalesce(max(t.mto_id), 0)+1
      INTO vi_id
      FROM sif.motor_oznaka t;

    r_new.mto_id := vi_id;

    INSERT INTO sif.motor_oznaka (mto_id, mto_oznaka)
      VALUES (r_new.mto_id, upper(r_new.mto_oznaka));
  ELSE
    SELECT t.mto_id,
           t.mto_oznaka
      INTO r_old
      FROM sif.motor_oznaka t
      WHERE t.mto_id=r_new.mto_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.motor_oznaka t
        SET mto_oznaka=r_new.mto_oznaka
        WHERE t.mto_id=r_new.mto_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;
  vi_id := r_new.mto_id;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'mto_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID oznake motora već postoji!';
    ELSEIF regexp_match(sqlerrm, 'mto_oznaka', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takva oznaka motora već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_motor_oznaka_iu(character varying) OWNER TO postgres;
