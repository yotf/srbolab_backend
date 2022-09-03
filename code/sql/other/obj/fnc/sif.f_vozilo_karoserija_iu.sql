DROP FUNCTION IF EXISTS sif.f_vozilo_karoserija_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_vozilo_karoserija_iu(
                                    pc_rec character varying
                                   )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.vozilo_karoserija;
  r_old sif.vozilo_karoserija;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.vozilo_karoserija, j_rec) j;

  vb_ins := r_new.vzk_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.vzk_id), 0)+1
      INTO vi_id
      FROM sif.vozilo_karoserija t;

    r_new.vzk_id := vi_id;

    INSERT INTO sif.vozilo_karoserija (vzk_id, vzk_oznaka, vzk_naziv)
      VALUES (r_new.vzk_id, r_new.vzk_oznaka, r_new.vzk_naziv);
  ELSE
    SELECT t.vzk_id,
           t.vzk_oznaka,
           t.vzk_naziv
      INTO r_old
      FROM sif.vozilo_karoserija t
      WHERE t.vzk_id=r_new.vzk_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.vozilo_karoserija t
        SET vzk_oznaka=r_new.vzk_oznaka,
            vzk_naziv=r_new.vzk_naziv
        WHERE t.vzk_id=r_new.vzk_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vzk_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID karoserija vozila već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzk_oznaka', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Karoserija vozila sa tom oznakom već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzk_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Karoserija vozila sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_vozilo_karoserija_iu(character varying) OWNER TO postgres;
