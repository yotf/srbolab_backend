DROP FUNCTION IF EXISTS adm.f_adm_aplikacija_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_adm_aplikacija_iu(
                            pc_rec character varying
                           )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new adm.adm_aplikacija;
  r_old adm.adm_aplikacija;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::adm.adm_aplikacija, j_rec) j;

  vb_ins := r_new.aap_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.aap_id), 0)+1
      INTO vi_id
      FROM adm.adm_aplikacija t;

    r_new.aap_id := vi_id;

    INSERT INTO adm.adm_aplikacija (aap_id, aap_naziv)
      VALUES (r_new.aap_id, r_new.aap_naziv);
  ELSE
    SELECT t.*
      INTO r_old
      FROM adm.adm_aplikacija t
      WHERE t.aap_id=r_new.aap_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE adm.adm_aplikacija t
        SET aap_naziv=r_new.aap_naziv
        WHERE t.aap_id=r_new.aap_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'aap_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID aplikacije već postoji!';
    ELSEIF regexp_match(sqlerrm, 'aap_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Aplikacija sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_adm_aplikacija_iu(character varying) OWNER TO postgres;
