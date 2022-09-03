DROP FUNCTION IF EXISTS sif.f_vozilo_dokument_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_vozilo_dokument_iu(
                                  pc_rec character varying
                                 )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.vozilo_dokument;
  r_old sif.vozilo_dokument;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.vozilo_dokument, j_rec) j;

  vb_ins := r_new.vzd_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.vzd_id), 0)+1
      INTO vi_id
      FROM sif.vozilo_dokument t;

    r_new.vzd_id := vi_id;

    INSERT INTO sif.vozilo_dokument (vzd_id, vzd_oznaka, vzd_naziv)
      VALUES (r_new.vzd_id, r_new.vzd_oznaka, r_new.vzd_naziv);
  ELSE
    SELECT t.vzd_id,
           t.vzd_oznaka,
           t.vzd_naziv
      INTO r_old
      FROM sif.vozilo_dokument t
      WHERE t.vzd_id=r_new.vzd_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.vozilo_dokument t
        SET vzd_oznaka=r_new.vzd_oznaka,
            vzd_naziv=r_new.vzd_naziv
        WHERE t.vzd_id=r_new.vzd_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vzd_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID dokumenta za vozilo već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzd_oznaka', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Dokument sa tom oznakom već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzd_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Dokument sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_vozilo_dokument_iu(character varying) OWNER TO postgres;
