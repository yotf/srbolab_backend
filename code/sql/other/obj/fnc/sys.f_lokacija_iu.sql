DROP FUNCTION IF EXISTS sys.f_lokacija_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_lokacija_iu(
                           pc_rec character varying
                          )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sys.lokacija;
  r_old sys.lokacija;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sys.lokacija, j_rec) j;

  vb_ins := r_new.lk_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.lk_id), 0)+1
      INTO vi_id
      FROM sys.lokacija t;

    r_new.lk_id := vi_id;

    INSERT INTO sys.lokacija (lk_id, lk_naziv, lk_naziv_l, lk_ip, lk_aktivna)
      VALUES (r_new.lk_id, r_new.lk_naziv, r_new.lk_naziv_l, r_new.lk_ip, r_new.lk_aktivna);
  ELSE
    SELECT t.lk_id,
           t.lk_naziv,
           t.lk_naziv_l,
           t.lk_ip,
           t.lk_aktivna
      INTO r_old
      FROM sys.lokacija t
      WHERE t.lk_id=r_new.lk_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sys.lokacija t
        SET lk_naziv=r_new.lk_naziv,
            lk_naziv_l=r_new.lk_naziv_l,
            lk_ip=r_new.lk_ip,
            lk_aktivna=r_new.lk_aktivna
        WHERE t.lk_id=r_new.lk_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'lk_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID lokacije već postoji!';
    ELSEIF regexp_match(sqlerrm, 'lk_ip', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takva IP adresa već postoji!';
    ELSEIF regexp_match(sqlerrm, 'lk_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Lokacija sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN check_violation THEN
    RAISE check_violation USING MESSAGE = 'Pogrešan status lokacije!';
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_lokacija_iu(character varying) OWNER TO postgres;
