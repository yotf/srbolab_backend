DROP FUNCTION IF EXISTS hmlg.f_predmet_status_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_predmet_status_iu(
                                  pc_rec character varying
                                 )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new hmlg.predmet_status;
  r_old hmlg.predmet_status;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::hmlg.predmet_status, j_rec) j;

  vb_ins := r_new.vzos_rb IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.vzos_rb), 0)+1
      INTO vi_id
      FROM hmlg.predmet_status t
      WHERE t.prs_id=r_new.prs_id;

    r_new.vzos_rb := vi_id;
    INSERT INTO hmlg.predmet_status (prs_id, prs_oznaka, prs_naziv, prs_priprema, prs_cekanje, prs_zakljucen, prs_neusag)
      VALUES (r_new.prs_id, r_new.prs_oznaka, r_new.prs_naziv, r_new.prs_priprema, r_new.prs_cekanje, r_new.prs_zakljucen, r_new.prs_neusag);
  ELSE
    SELECT t.prs_id,
           t.prs_oznaka,
           t.prs_naziv,
           t.prs_priprema,
           t.prs_cekanje,
           t.prs_zakljucen,
           t.prs_neusag
      FROM hmlg.predmet_status t
      WHERE t.prs_id=r_new.prs_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r
              UNION
            SELECT r_new AS r
           ) t;
    IF vb_ok2updt THEN
      UPDATE hmlg.predmet_status t
        SET prs_oznaka=r_new.prs_oznaka,
            prs_naziv=r_new.prs_naziv,
            prs_priprema=r_new.prs_priprema,
            prs_cekanje=r_new.prs_cekanje,
            prs_zakljucen=r_new.prs_zakljucen,
            prs_neusag=r_new.prs_neusag
        WHERE t.prs_id=r_new.prs_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'prs_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav status predmeta već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_predmet_status_iu(character varying) OWNER TO postgres;
