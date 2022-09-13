DROP FUNCTION IF EXISTS hmlg.f_klijent_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_klijent_iu(
                           pc_rec character varying
                          )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new hmlg.klijent;
  r_old hmlg.klijent;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::hmlg.klijent, j_rec) j;

  vb_ins := r_new.kl_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.kl_id), 0)+1
      INTO vi_id
      FROM hmlg.klijent t;

    r_new.kl_id := vi_id;

    INSERT INTO hmlg.klijent (kl_id, kl_naziv, kl_adresa, kl_telefon, kl_firma)
      VALUES (r_new.kl_id, r_new.kl_naziv, r_new.kl_adresa, r_new.kl_telefon, r_new.kl_firma);
  ELSE
    SELECT t.kl_id,
           t.kl_naziv,
           t.kl_adresa,
           t.kl_telefon,
           t.kl_firma
      INTO r_old
      FROM hmlg.klijent t
      WHERE t.kl_id=r_new.kl_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;

    IF vb_ok2updt THEN
      UPDATE hmlg.klijent t
        SET kl_naziv=r_new.kl_naziv,
            kl_adresa=r_new.kl_adresa,
            kl_telefon=r_new.kl_telefon,
            kl_firma=r_new.kl_firma
        WHERE t.kl_id=r_new.kl_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'kl_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID klijenta već postoji!';
    ELSEIF regexp_match(sqlerrm, 'kl_naziv', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Klijent sa tim nazivom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_klijent_iu(character varying) OWNER TO postgres;
