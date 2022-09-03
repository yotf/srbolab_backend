DROP FUNCTION IF EXISTS adm.f_adm_forma_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_adm_forma_iu(
                            pc_rec character varying
                           )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new adm.adm_forma;
  r_old adm.adm_forma;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::adm.adm_forma, j_rec) j;

  vb_ins := r_new.afo_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.afo_id), 0)+1
      INTO vi_id
      FROM adm.adm_forma t;

    r_new.afo_id := vi_id;

    INSERT INTO adm.adm_forma (afo_id, afo_naziv)
      VALUES (r_new.afo_id, r_new.afo_naziv);
  ELSE
    SELECT t.*
      INTO r_old
      FROM adm.adm_forma t
      WHERE t.afo_id=r_new.afo_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE adm.adm_forma t
        SET afo_naziv=r_new.afo_naziv
        WHERE t.afo_id=r_new.afo_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'afo_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID role već postoji!';
    ELSEIF regexp_match(sqlerrm, 'afo_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Rola sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_adm_forma_iu(character varying) OWNER TO postgres;
