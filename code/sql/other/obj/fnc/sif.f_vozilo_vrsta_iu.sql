DROP FUNCTION IF EXISTS sif.f_vozilo_vrsta_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_vozilo_vrsta_iu(
                               pc_rec character varying
                              )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.vozilo_vrsta;
  r_old sif.vozilo_vrsta;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.vozilo_vrsta, j_rec) j;

  vb_ins := r_new.vzv_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.vzv_id), 0)+1
      INTO vi_id
      FROM sif.vozilo_vrsta t;

    r_new.vzv_id := vi_id;

    INSERT INTO sif.vozilo_vrsta (vzv_id, vzv_oznaka, vzv_naziv)
      VALUES (r_new.vzv_id, r_new.vzv_oznaka, r_new.vzv_naziv);
  ELSE
    SELECT t.vzv_id,
           t.vzv_oznaka,
           t.vzv_naziv
      INTO r_old
      FROM sif.vozilo_vrsta t
      WHERE t.vzv_id=r_new.vzv_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.vozilo_vrsta t
        SET vzv_oznaka=r_new.vzv_oznaka,
            vzv_naziv=r_new.vzv_naziv
        WHERE t.vzv_id=r_new.vzv_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vzv_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID vrste vozila već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzv_oznaka', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Vrsta vozila sa tom oznakom već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzv_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Vrsta vozila sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_vozilo_vrsta_iu(character varying) OWNER TO postgres;
