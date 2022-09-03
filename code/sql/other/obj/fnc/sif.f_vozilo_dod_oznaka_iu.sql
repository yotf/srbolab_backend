DROP FUNCTION IF EXISTS sif.f_vozilo_dod_oznaka_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_vozilo_dod_oznaka_iu(
                                    pc_rec character varying
                                   )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.vozilo_dod_oznaka;
  r_old sif.vozilo_dod_oznaka;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.vozilo_dod_oznaka, j_rec) j;

  vb_ins := r_new.vzdo_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.vzdo_id), 0)+1
      INTO vi_id
      FROM sif.vozilo_dod_oznaka t;

    r_new.vzdo_id := vi_id;

    INSERT INTO sif.vozilo_dod_oznaka (vzdo_id, vzdo_oznaka, vzdo_naziv)
      VALUES (r_new.vzdo_id, r_new.vzdo_oznaka, r_new.vzdo_naziv);
  ELSE
    SELECT t.vzdo_id,
           t.vzdo_oznaka,
           t.vzdo_naziv
      INTO r_old
      FROM sif.vozilo_dod_oznaka t
      WHERE t.vzdo_id=r_new.vzdo_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.vozilo_dod_oznaka t
        SET vzdo_oznaka=r_new.vzdo_oznaka,
            vzdo_naziv=r_new.vzdo_naziv
        WHERE t.vzdo_id=r_new.vzdo_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vzdo_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID dodatne oznake već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzdo_oznaka', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Dodatna oznaka sa tom oznakom već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzdo_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Dodatna oznaka sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_vozilo_dod_oznaka_iu(character varying) OWNER TO postgres;
