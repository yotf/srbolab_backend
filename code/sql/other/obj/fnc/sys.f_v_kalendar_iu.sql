DROP FUNCTION IF EXISTS sys.f_v_kalendar_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_v_kalendar_iu(
                             pc_rec character varying
                            )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sys.kalendar;
  r_old sys.kalendar;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  IF public.f_json_keys_check('kn_datum_to', j_rec) IS NOT NULL THEN
    SELECT j.kn_datum::date,
           j.kn_napomena
      INTO r_new
      FROM json_populate_record(null::sys.kalendar, j_rec) j;

    SELECT COUNT(*)=0
      INTO vb_ins
      FROM sys.kalendar t
      WHERE t.kn_datum=r_new.kn_datum;

    IF vb_ins THEN
      INSERT INTO sys.kalendar (kn_datum, kn_napomena)
        VALUES (r_new.kn_datum, r_new.kn_napomena);
      vi_id := 1;
    ELSE
      SELECT t.kn_datum,
             t.kn_napomena
        INTO r_old
        FROM sys.kalendar t
        WHERE t.kn_datum=r_new.kn_datum::date;

      SELECT COUNT(*)=2 AS ok2updt
        INTO vb_ok2updt
        FROM (
              SELECT r_old AS r
                UNION
              SELECT r_new AS r
             ) t;

      IF vb_ok2updt THEN
        UPDATE sys.kalendar t
          SET kn_napomena=r_new.kn_napomena
          WHERE t.kn_datum=r_new.kn_datum::date;
        GET DIAGNOSTICS vi_id=ROW_COUNT;
      END IF;
    END IF;
  ELSE
    SELECT t.kn_datum,
           t.kn_napomena
      INTO r_old
      FROM json_to_record(j_rec) AS t (kn_datum date, kn_napomena character varying, kn_datum_to date);

    SELECT t.kn_datum_to,
           t.kn_napomena
      INTO r_new
      FROM json_to_record(j_rec) AS t (kn_datum date, kn_napomena character varying, kn_datum_to date);

    IF NOT EXISTS
        (
         SELECT 1
           FROM sys.kalendar k
           WHERE k.kn_datum=r_new.kn_datum
        ) THEN
      INSERT INTO sys.kalendar (kn_datum, kn_napomena)
        VALUES (r_new.kn_datum, r_new.kn_napomena);
    END IF;
    GET DIAGNOSTICS vi_id=ROW_COUNT;

    INSERT INTO sys.raspored (kn_datum, kr_id, lk_id, rs_napomena)
      SELECT r_new.kn_datum AS kn_datum,
             t.kr_id,
             t.lk_id,
             t.rs_napomena
        FROM sys.raspored t
        WHERE t.kn_datum=r_old.kn_datum
          AND NOT EXISTS
               (
                SELECT 1
                  FROM sys.raspored r
                  WHERE r.kn_datum=r_new.kn_datum
                    AND r.kr_id=t.kr_id
               );
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'kn_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav datum već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_v_kalendar_iu(character varying) OWNER TO postgres;
