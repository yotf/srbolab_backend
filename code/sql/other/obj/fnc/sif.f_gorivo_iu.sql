DROP FUNCTION IF EXISTS sif.f_gorivo_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_gorivo_iu(
                         pc_rec character varying
                        )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.gorivo;
  r_old sif.gorivo;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.gorivo, j_rec) j;

  vb_ins := r_new.gr_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.gr_id), 0)+1
      INTO vi_id
      FROM sif.gorivo t;

    r_new.gr_id := vi_id;

    INSERT INTO sif.gorivo (gr_id, gr_naziv)
      VALUES (r_new.gr_id, r_new.gr_naziv);
  ELSE
    SELECT t.gr_id,
           t.gr_naziv
      INTO r_old
      FROM sif.gorivo t
      WHERE t.gr_id=r_new.gr_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.gorivo t
        SET gr_naziv=r_new.gr_naziv
        WHERE t.gr_id=r_new.gr_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'gr_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID emisije već postoji!';
    ELSEIF regexp_match(sqlerrm, 'gr_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Emisija sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_gorivo_iu(character varying) OWNER TO postgres;
