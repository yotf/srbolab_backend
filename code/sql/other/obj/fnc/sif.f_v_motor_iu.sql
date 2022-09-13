DROP FUNCTION IF EXISTS sif.f_v_motor_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_motor_iu(
                          pc_rec character varying
                         )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.v_motor;
  r_old sif.v_motor;

  vi_id integer := 0;
  vi_row_count integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;
  vc_rec varchar;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.v_motor, j_rec) j;

  SELECT row_to_json(t)::character varying
    INTO vc_rec
    FROM (
          SELECT r_new.mto_id,
                 coalesce(r_new.mto_oznaka, '-') AS mto_oznaka
         ) t;
  r_new.mto_id := sif.f_motor_oznaka_iu(vc_rec);

  vb_ins := r_new.mt_id IS NULL;

  IF vb_ins THEN
    IF coalesce(r_new.mt_cm3, 0)*coalesce(r_new.mt_kw, 0)>0 THEN
      SELECT COALESCE(MAX(t.mt_id), 0)+1
        INTO vi_id
        FROM sif.motor t;

      r_new.mt_id := vi_id;
      INSERT INTO sif.motor (mt_id, mt_cm3, mt_kw, mto_id, mtt_id)
        VALUES (r_new.mt_id, r_new.mt_cm3, r_new.mt_kw, r_new.mto_id, r_new.mtt_id);
    END IF;
  ELSE
    SELECT t.*
      INTO r_old
      FROM sif.v_motor t
      WHERE t.mt_id=r_new.mt_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.motor t
        SET mto_id=r_new.mto_id,
            mt_cm3=r_new.mt_cm3,
            mt_kw=r_new.mt_kw,
            mtt_id=r_new.mtt_id
        WHERE t.mt_id=r_new.mt_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'mt_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID motora već postoji!';
    ELSEIF regexp_match(sqlerrm, 'mt_uk1', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Motor sa tom oznakom, zapreminom i snagom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_motor_iu(character varying) OWNER TO postgres;
