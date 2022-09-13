DROP FUNCTION IF EXISTS sif.f_emisija_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_emisija_iu(
                          pc_rec character varying
                         )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.emisija;
  r_old sif.emisija;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.emisija, j_rec) j;

  vb_ins := r_new.em_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.em_id), 0)+1
      INTO vi_id
      FROM sif.emisija t;

    r_new.em_id := vi_id;

    INSERT INTO sif.emisija (em_id, em_naziv)
      VALUES (r_new.em_id, r_new.em_naziv);
  ELSE
    SELECT t.em_id,
           t.em_naziv
      INTO r_old
      FROM sif.emisija t
      WHERE t.em_id=r_new.em_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.emisija t
        SET em_naziv=r_new.em_naziv
        WHERE t.em_id=r_new.em_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'em_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID emisije već postoji!';
    ELSEIF regexp_match(sqlerrm, 'em_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Emisija sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_emisija_iu(character varying) OWNER TO postgres;
