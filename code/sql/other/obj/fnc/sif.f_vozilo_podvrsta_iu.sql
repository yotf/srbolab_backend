DROP FUNCTION IF EXISTS sif.f_vozilo_podvrsta_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_vozilo_podvrsta_iu(
                                  pc_rec character varying
                                 )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.vozilo_podvrsta;
  r_old sif.vozilo_podvrsta;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.vozilo_podvrsta, j_rec) j;

  vb_ins := r_new.vzpv_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.vzpv_id), 0)+1
      INTO vi_id
      FROM sif.vozilo_podvrsta t;

    r_new.vzpv_id := vi_id;

    INSERT INTO sif.vozilo_podvrsta (vzpv_id, vzpv_oznaka, vzpv_naziv, vzv_id)
      VALUES (r_new.vzpv_id, r_new.vzpv_oznaka, r_new.vzpv_naziv, r_new.vzv_id);
  ELSE
    SELECT t.vzpv_id,
           t.vzpv_oznaka,
           t.vzpv_naziv,
           t.vzv_id
      INTO r_old
      FROM sif.vozilo_podvrsta t
      WHERE t.vzpv_id=r_new.vzpv_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.vozilo_podvrsta t
        SET vzpv_oznaka=r_new.vzpv_oznaka,
            vzpv_naziv=r_new.vzpv_naziv
        WHERE t.vzpv_id=r_new.vzpv_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vzpv_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID podvrste vozila već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzpv_oznaka', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Podvrsta vozila sa tom oznakom već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzpv_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Podvrsta vozila sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_vozilo_podvrsta_iu(character varying) OWNER TO postgres;
