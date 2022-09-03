DROP FUNCTION IF EXISTS sif.f_model_varijanta_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_model_varijanta_iu(
                                  pc_rec character varying
                                 )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.model_varijanta;
  r_old sif.model_varijanta;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.model_varijanta, j_rec) j;

  vb_ins := r_new.mdvr_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.mdvr_id), 0)+1
      INTO vi_id
      FROM sif.model_varijanta t;

    r_new.mdvr_id := vi_id;

    INSERT INTO sif.model_varijanta (mdvr_id, mdvr_oznaka)
      VALUES (r_new.mdvr_id, upper(r_new.mdvr_oznaka));
  ELSE
    SELECT t.mdvr_id,
           t.mdvr_oznaka
      INTO r_old
      FROM sif.model_varijanta t
      WHERE t.mdvr_id=r_new.mdvr_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.model_varijanta t
        SET mdvr_oznaka=r_new.mdvr_oznaka
        WHERE t.mdvr_id=r_new.mdvr_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'mdvr_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID varijante vozila već postoji!';
    ELSEIF regexp_match(sqlerrm, 'mdvr_oznaka', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Varijana vozila sa tom oznakom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_model_varijanta_iu(character varying) OWNER TO postgres;
