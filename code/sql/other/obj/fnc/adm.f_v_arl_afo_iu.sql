DROP FUNCTION IF EXISTS adm.f_v_arl_afo_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_v_arl_afo_iu(
                            pc_rec character varying
                           )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new adm.arl_afo;
  r_old adm.arl_afo;

  vb_ins boolean;
  vi_row_count integer := 0;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::adm.arl_afo, j_rec) j;

  SELECT COUNT(*)=0
    INTO vb_ins
    FROM adm.arl_afo t
    WHERE t.arl_id=r_new.arl_id
      AND t.afo_id=r_new.afo_id;

  IF vb_ins THEN
    INSERT INTO adm.arl_afo (arl_id, afo_id, arf_akcije_d)
      VALUES (r_new.arl_id, r_new.afo_id, r_new.arf_akcije_d);
    GET DIAGNOSTICS vi_row_count=row_count;
  ELSE

    SELECT t.arl_id,
           t.afo_id,
           t.arf_akcije_d
      INTO r_old
      FROM adm.arl_afo t
      WHERE t.arl_id=r_new.arl_id
        AND t.afo_id=r_new.afo_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE adm.arl_afo t
        SET arf_akcije_d=r_new.arf_akcije_d
        WHERE t.arl_id=r_new.arl_id
          AND t.afo_id=r_new.afo_id;
      GET DIAGNOSTICS vi_row_count=ROW_COUNT;
    END IF;
  END IF;

  IF vi_row_count>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_row_count;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'arf_pk', 'i') IS NOT null THEN
      RAISE unique_violation USING MESSAGE = 'Takva veza role i forme već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_v_arl_afo_iu(character varying) OWNER TO postgres;
