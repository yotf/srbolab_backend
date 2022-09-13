DROP FUNCTION IF EXISTS sif.f_model_verzija_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_model_verzija_iu(
                                pc_rec character varying
                               )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.model_verzija;
  r_old sif.model_verzija;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.model_verzija, j_rec) j;

  vb_ins := r_new.mdvz_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.mdvz_id), 0)+1
      INTO vi_id
      FROM sif.model_verzija t;

    r_new.mdvz_id := vi_id;

    INSERT INTO sif.model_verzija (mdvz_id, mdvz_oznaka)
      VALUES (r_new.mdvz_id, upper(r_new.mdvz_oznaka));
  ELSE
    SELECT t.mdvz_id,
           t.mdvz_oznaka
      INTO r_old
      FROM sif.model_verzija t
      WHERE t.mdvz_id=r_new.mdvz_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.model_verzija t
        SET mdvz_oznaka=r_new.mdvz_oznaka
        WHERE t.mdvz_id=r_new.mdvz_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'mdvz_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID verzije vozila već postoji!';
    ELSEIF regexp_match(sqlerrm, 'mdvz_oznaka', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Verzija vozila sa tom oznakom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_model_verzija_iu(character varying) OWNER TO postgres;
