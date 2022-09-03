DROP FUNCTION IF EXISTS hmlg.f_potvrda_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_potvrda_iu(
                           pc_rec character varying
                          )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new hmlg.potvrda;
  r_old hmlg.potvrda;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::hmlg.potvrda, j_rec) j;

  vb_ins := r_new.vzos_rb IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.vzos_rb), 0)+1
      INTO vi_id
      FROM hmlg.potvrda t
      WHERE t.pot_id=r_new.pot_id;

    r_new.vzos_rb := vi_id;
    INSERT INTO hmlg.potvrda (pot_id, pot_broj, pot_datum, pot_vreme, pr_id, lk_id, kr_id)
      VALUES (pot_id, pot_broj, CURRENT_DATE, CURRENT_TIMESTAMP, pr_id, lk_id, kr_id);
  ELSE
    SELECT t.pot_id,
           t.pot_broj,
           t.pot_datum,
           t.pot_vreme,
           t.pr_id,
           t.lk_id,
           t.kr_id
      FROM hmlg.potvrda t
      WHERE t.pot_id=r_new.pot_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;
    IF vb_ok2updt THEN
      UPDATE hmlg.potvrda t
        SET pot_broj=r_new.pot_broj, 
            pot_datum=CURRENT_DATE, 
            pot_vreme=CURRENT_TIMESTAMP, 
            lk_id=r_new.lk_id, 
            kr_id=r_new.kr_id
        WHERE t.pot_id=r_new.pot_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'pot_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takva potvrda već postoji!';
    ELSEIF regexp_match(sqlerrm, 'pot_uk1', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takva potvrda već postoji!';
    ELSEIF regexp_match(sqlerrm, 'pot_uk2', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takva potvrda već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_potvrda_iu(character varying) OWNER TO postgres;
