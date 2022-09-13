DROP FUNCTION IF EXISTS hmlg.f_vozilo_s_osovina_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_vozilo_s_osovina_iu(
                                    pc_rec character varying
                                   )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new hmlg.vozilo_s_osovina;
  r_old hmlg.vozilo_s_osovina;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::hmlg.vozilo_s_osovina, j_rec) j;

  vb_ins := r_new.vzos_rb IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.vzos_rb), 0)+1
      INTO vi_id
      FROM hmlg.vozilo_s_osovina t
      WHERE t.vzs_id=r_new.vzs_id;

    r_new.vzos_rb := vi_id;

    INSERT INTO hmlg.vozilo_s_osovina (vzs_id, vzos_rb, vzos_nosivost, vzos_tockova, vzos_pneumatik)
      VALUES (r_new.vzs_id, r_new.vzos_rb, r_new.vzos_nosivost, r_new.vzos_tockova, upper(r_new.vzos_pneumatik));
  ELSE
    SELECT t.vzs_id,
           t.vzos_rb,
           t.vzos_nosivost,
           t.vzos_tockova,
           t.vzos_pneumatik
      INTO r_old
      FROM hmlg.vozilo_s_osovina t
      WHERE t.vzs_id=r_new.vzs_id
        AND t.vzos_rb=r_new.vzos_rb;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;
    IF vb_ok2updt THEN
      UPDATE hmlg.vozilo_s_osovina t
        SET vzos_nosivost=r_new.vzos_nosivost,
            vzos_tockova=r_new.vzos_tockova,
            vzos_pneumatik=r_new.vzos_pneumatik
        WHERE t.vzs_id=r_new.vzs_id
          AND t.vzos_rb=r_new.vzos_rb;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vzos_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takva osovina već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_vozilo_s_osovina_iu(character varying) OWNER TO postgres;
