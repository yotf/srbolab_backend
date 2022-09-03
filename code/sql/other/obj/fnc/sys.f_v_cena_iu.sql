DROP FUNCTION IF EXISTS sys.f_v_cena_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_v_cena_iu(
                         pc_rec character varying
                        )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sys.v_cena;
  r_old sys.v_cena;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.emisija, j_rec) j;

  vb_ins := r_new.cn_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.cn_id), 0)+1
      INTO vi_id
      FROM sys.cena t
      WHERE t.ck_id=r_new.ck_id;

    INSERT INTO sys.v_cena (ck_id, cn_id, cn_cena, us_id)
      VALUES (r_new.ck_id, r_new.cn_id, r_new.cn_cena, r_new.us_id);
  ELSE
    SELECT t.ck_id,
           t.cn_id,
           t.cn_cena,
           t.us_id
      INTO r_old
      FROM sys.v_cena t
      WHERE t.ck_id=r_new.ck_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sys.v_cena t
        SET cn_cena=r_new.cn_cena,
            us_id=r_new.us_id
        WHERE t.ck_id=r_new.ck_id
          AND t.cn_id=r_new.cn_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'cn_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID cene već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_v_cena_iu(character varying) OWNER TO postgres;
