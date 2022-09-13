DROP FUNCTION IF EXISTS sif.f_organizacija_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_organizacija_iu(
                               pc_rec character varying
                              )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.organizacija;
  r_old sif.organizacija;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.organizacija, j_rec) j;

  vb_ins := r_new.org_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.org_id), 0)+1
      INTO vi_id
      FROM sif.organizacija t;

    r_new.org_id := vi_id;

    INSERT INTO sif.organizacija (org_id, org_naziv, org_napomena)
      VALUES (r_new.org_id, r_new.org_naziv, nullif(r_new.org_napomena, ''));
  ELSE
    SELECT t.org_id,
           t.org_naziv,
           t.org_napomena
      INTO r_old
      FROM sif.organizacija t
      WHERE t.org_id=r_new.org_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE sif.organizacija t
        SET org_naziv=r_new.org_naziv,
            org_napomena=r_new.org_napomena
        WHERE t.org_id=r_new.org_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'org_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID organizacije već postoji!';
    ELSEIF regexp_match(sqlerrm, 'org_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Organizacija sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_organizacija_iu(character varying) OWNER TO postgres;
