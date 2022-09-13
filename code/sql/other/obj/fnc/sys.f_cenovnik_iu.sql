DROP FUNCTION IF EXISTS sys.f_cenovnik_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_cenovnik_iu(
                           pc_rec character varying
                          )
  RETURNS date AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sys.cenovnik;
  r_old sys.cenovnik;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.cenovnik, j_rec) j;

  vb_ins := r_new.cn_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.ck_id), 0)+1
      INTO vi_id
      FROM sys.cenovnik t;

    r_new.cn_id := vi_id;

    INSERT INTO sys.cenovnik (ck_id, ck_datum, ck_napomena)
      VALUES (r_new.ck_id, r_new.ck_datum, r_new.ck_napomena);
  ELSE
    SELECT t.ck_id,
           t.ck_datum,
           t.ck_napomena
      INTO r_old
      FROM sys.cenovnik t
      WHERE t.ck_id=r_new.ck_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sys.cenovnik t
        SET ck_datum=r_new.ck_datum,
            ck_napomena=r_new.ck_napomena
        WHERE t.ck_id=r_new.ck_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'ck_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID cenovnika već postoji!';
    ELSEIF regexp_match(sqlerrm, 'ck_datum', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Cenovnika sa tim datumom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_cenovnik_iu(character varying) OWNER TO postgres;
