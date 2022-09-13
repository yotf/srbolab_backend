DROP FUNCTION IF EXISTS sys.f_v_korisnik_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_v_korisnik_iu(
                             pc_rec character varying
                            )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sys.v_korisnik;
  r_old sys.v_korisnik;

  vi_id integer := 0;
  vb_ins boolean;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sys.v_korisnik, j_rec) j;

  vb_ins := r_new.kr_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.kr_id), 0)+1
      INTO vi_id
      FROM sys.korisnik t;

    r_new.kr_id := vi_id;

    INSERT INTO sys.korisnik (kr_id, kr_prezime, kr_ime, kr_username, kr_password, kr_aktivan, arl_id)
      VALUES (r_new.kr_id, r_new.kr_prezime, r_new.kr_ime, r_new.kr_username, public.f_str_encode(r_new.kr_username||r_new.kr_password), r_new.kr_aktivan, r_new.arl_id);
  ELSE
    SELECT t.kr_id,
           t.kr_prezime,
           t.kr_ime,
           t.kr_username,
           t.kr_password,
           t.kr_aktivan,
           t.arl_id,
           t.arl_naziv
      INTO r_old
      FROM sys.v_korisnik t
      WHERE t.kr_id=r_new.kr_id;

    IF r_new.kr_password IS NULL THEN
      r_new.kr_password := r_old.kr_password;
    ELSIF length(r_new.kr_password)<>64 THEN
      r_new.kr_password := public.f_str_encode(r_new.kr_username||r_new.kr_password);
    END IF;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT r_old AS r_new
              UNION
            SELECT r_new AS r_new
           ) t;

    IF vb_ok2updt THEN
      UPDATE sys.korisnik t
        SET kr_prezime=r_new.kr_prezime,
            kr_ime=r_new.kr_ime,
            kr_username=r_new.kr_username,
            kr_password=r_new.kr_password,
            kr_aktivan=r_new.kr_aktivan,
            arl_id=r_new.arl_id
        WHERE t.kr_id=r_new.kr_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'kr_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Taj ID korisnika već postoji!';
    ELSEIF regexp_match(sqlerrm, 'kr_username', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Korisnik sa takvim korisničkim imenom već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_v_korisnik_iu(character varying) OWNER TO postgres;
