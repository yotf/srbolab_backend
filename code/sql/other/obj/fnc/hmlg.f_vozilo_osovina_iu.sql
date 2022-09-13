DROP FUNCTION IF EXISTS hmlg.f_vozilo_osovina_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_vozilo_osovina_iu(
                                  pc_rec character varying
                                 )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new hmlg.vozilo_osovina;
  r_old hmlg.vozilo_osovina;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::hmlg.vozilo_osovina, j_rec) j;

  vb_ins := r_new.vzo_rb IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.vzo_rb), 0)+1
      INTO vi_id
      FROM hmlg.vozilo_osovina t
      WHERE t.vz_id=r_new.vz_id;

    r_new.vzo_rb := vi_id;

    INSERT INTO hmlg.vozilo_osovina (vz_id, vzo_rb, vzo_nosivost, vzo_tockova, vzo_pneumatik)
      VALUES (r_new.vz_id, r_new.vzo_rb, r_new.vzo_nosivost, r_new.vzo_tockova, upper(r_new.vzo_pneumatik));
  ELSE
    SELECT t.vz_id,
           t.vzo_rb,
           t.vzo_nosivost,
           t.vzo_tockova,
           t.vzo_pneumatik
      INTO r_old
      FROM hmlg.vozilo_osovina t
      WHERE t.vz_id=r_new.vz_id
        AND t.vzo_rb=r_new.vzo_rb;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;
    IF vb_ok2updt THEN
      UPDATE hmlg.vozilo_osovina t
        SET vzo_nosivost=r_new.vzo_nosivost,
            vzo_tockova=r_new.vzo_tockova,
            vzo_pneumatik=r_new.vzo_pneumatik
        WHERE t.vz_id=r_new.vz_id
          AND t.vzo_rb=r_new.vzo_rb;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vzo_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takva osovina već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_vozilo_osovina_iu(character varying) OWNER TO postgres;
