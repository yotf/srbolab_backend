DROP FUNCTION IF EXISTS sif.f_marka_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_marka_iu(
                        pc_rec character varying
                       )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.marka;
  r_old sif.marka;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.marka, j_rec) j;

  vb_ins := r_new.mr_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.mr_id), 0)+1
      INTO vi_id
      FROM sif.marka t;

    r_new.mr_id := vi_id;

    INSERT INTO sif.marka (mr_id, mr_naziv)
      VALUES (r_new.mr_id, upper(r_new.mr_naziv));
  ELSE
    SELECT t.mr_id,
           t.mr_naziv
      INTO r_old
      FROM sif.marka t
      WHERE t.mr_id=r_new.mr_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.marka t
        SET mr_naziv=r_new.mr_naziv
        WHERE t.mr_id=r_new.mr_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'mr_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID marke već postoji!';
    ELSEIF regexp_match(sqlerrm, 'mr_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Marka sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_marka_iu(character varying) OWNER TO postgres;
