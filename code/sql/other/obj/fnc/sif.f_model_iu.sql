DROP FUNCTION IF EXISTS sif.f_model_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_model_iu(
                        pc_rec character varying
                       )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.model;
  r_old sif.model;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.model, j_rec) j;

  vb_ins := r_new.md_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.md_id), 0)+1
      INTO vi_id
      FROM sif.model t
      WHERE t.mr_id=r_new.mr_id;

    r_new.md_id := vi_id;

    INSERT INTO sif.model (mr_id, md_id, md_naziv_k)
      VALUES (r_new.mr_id, r_new.md_id, upper(r_new.md_naziv_k));
  ELSE
    SELECT t.mr_id,
           t.md_id,
           t.md_naziv_k
      INTO r_old
      FROM sif.model t
      WHERE t.mr_id=r_new.mr_id
        AND t.md_id=r_new.md_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.model t
        SET md_naziv_k=r_new.md_naziv_k
        WHERE t.mr_id=r_new.mr_id
          AND t.md_id=r_new.md_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'md_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID modela već postoji!';
    ELSEIF regexp_match(sqlerrm, 'md_naziv_k', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Model sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_model_iu(character varying) OWNER TO postgres;
