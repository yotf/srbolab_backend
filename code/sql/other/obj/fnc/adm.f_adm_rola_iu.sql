DROP FUNCTION IF EXISTS adm.f_adm_rola_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_adm_rola_iu(
                           pc_rec character varying
                          )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new adm.adm_rola;
  r_old adm.adm_rola;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::adm.adm_rola, j_rec) j;

  vb_ins := r_new.arl_id IS NULL;

  IF public.f_json_keys_check('arl_id_to', j_rec) IS NOT NULL THEN
    IF vb_ins THEN
      SELECT COALESCE(MAX(t.arl_id), 0)+1
        INTO vi_id
        FROM adm.adm_rola t;

      r_new.arl_id := vi_id;

      INSERT INTO adm.adm_rola (arl_id, arl_naziv)
        VALUES (r_new.arl_id, r_new.arl_naziv);
    ELSE
      SELECT t.*
        INTO r_old
        FROM adm.adm_rola t
        WHERE t.arl_id=r_new.arl_id;

      SELECT COUNT(*)=2 AS ok2updt
        INTO vb_ok2updt
        FROM (
              SELECT r_old AS r
                UNION
              SELECT r_new AS r
             ) t;

      IF vb_ok2updt THEN
        UPDATE adm.adm_rola t
          SET arl_naziv=r_new.arl_naziv
          WHERE t.arl_id=r_new.arl_id;
        GET DIAGNOSTICS vi_id=ROW_COUNT;
      END IF;
    END IF;
  ELSE
    SELECT t.arl_id::integer,
           null::varchar AS arl_naziv
      INTO r_old
      FROM json_to_record(j_rec) AS t (arl_id integer, arl_id_to integer);
    vi_id := r_old.arl_id;

    SELECT t.arl_id_to::integer AS arl_id,
           null::varchar AS arl_naziv
      INTO r_new
      FROM json_to_record(j_rec) AS t (arl_id integer, arl_id_to integer);

    INSERT INTO adm.arl_afo (arl_id, afo_id, arf_akcije_d)
      SELECT r_new.arl_id AS arl_id,
             t.afo_id,
             t.arf_akcije_d
        FROM adm.arl_afo t
        WHERE t.arl_id=r_old.arl_id
          AND NOT EXISTS
               (
                SELECT 1
                  FROM adm.arl_afo r
                  WHERE r.arl_id=r_new.arl_id
                    AND r.afo_id=t.afo_id
               );
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'arl_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID role već postoji!';
    ELSEIF regexp_match(sqlerrm, 'arl_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Rola sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_adm_rola_iu(character varying) OWNER TO postgres;
