DROP FUNCTION IF EXISTS sif.f_v_ag_homologacija_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_ag_homologacija_iu(
                                    pc_rec character varying
                                   )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.v_ag_homologacija;
  r_old sif.v_ag_homologacija;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.model_varijanta, j_rec) j;

  vb_ins := r_new.agh_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.agh_id), 0)+1
      INTO vi_id
      FROM sif.v_ag_homologacija t;

    r_new.agh_id := vi_id;

    INSERT INTO sif.ag_homologacija (agh_id, agh_oznaka, agh_uredjaj)
      VALUES (r_new.agh_id, r_new.agh_oznaka, r_new.agu_id);
  ELSE
    SELECT t.agh_id,
           t.agh_oznaka,
           t.agu_id
      INTO r_old
      FROM sif.ag_homologacija t
      WHERE t.agh_id=r_new.agh_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.ag_homologacija t
        SET agh_oznaka=r_new.agh_oznaka,
            agu_id=r_new.agu_id
        WHERE t.agh_id=r_new.agh_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'agh_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID homologacije već postoji!';
    ELSEIF regexp_match(sqlerrm, 'agh_oznaka', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Homologacija sa tom oznakom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN check_violation THEN
    RAISE check_violation USING MESSAGE = 'Pogrešan tip uređaja!';
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_ag_homologacija_iu(character varying) OWNER TO postgres;
