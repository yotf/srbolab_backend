CREATE OR REPLACE
FUNCTION hmlg.f_v_predmet_iu(
                             pc_rec varchar
                            )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_t hmlg.v_predmet;
--   r_new hmlg.predmet;
--   r_old hmlg.predmet;

  vi_id integer := 1;
  vc_rec varchar;

  r_c record;
  vb_ins boolean;
  vi_row_count integer := 0;
  vi_row_count1 integer := 0;
  vb_ok2updt boolean;

BEGIN

  SELECT j.*
    INTO r_t
    FROM json_populate_record(null::hmlg.v_predmet, j_rec) j;

-- hmlg.klijent
  IF r_t.kl_naziv IS NOT NULL THEN
    SELECT row_to_json(t)::varchar
      INTO vc_rec
      FROM (
            SELECT j.*
              FROM json_populate_record(null::hmlg.klijent, j_rec) j
           ) t;
    IF r_t.kl_id IS NULL THEN
      r_t.kl_id := hmlg.f_klijent_iu(vc_rec);
      j_rec := jsonb_set(j_rec::jsonb, '{kl_id}', (r_t.kl_id::varchar)::jsonb)::json;
    ELSE
      vi_row_count := hmlg.f_klijent_iu(vc_rec);
    END IF;
  END IF;

-- hmlg.vozilo
  SELECT row_to_json(t)::varchar
    INTO vc_rec
    FROM (
          SELECT j.*
            FROM json_populate_record(null::hmlg.v_vozilo, j_rec) j
         ) t;
  IF r_t.vz_id IS NULL THEN
    r_t.vz_id := hmlg.f_v_vozilo_iu(vc_rec);
    j_rec := jsonb_set(j_rec::jsonb, '{vz_id}', (r_t.vz_id::varchar)::jsonb)::json;
  ELSE
    vi_row_count := hmlg.f_v_vozilo_iu(vc_rec);
  END IF;

  vb_ins := r_t.pr_id IS NULL;

  IF vb_ins THEN
    SELECT COALESCE(MAX(t.pr_id), 0)+1
      INTO r_t.pr_id
      FROM hmlg.predmet t;

--    r_t.pr_id := vi_id;
    r_t.pr_broj := to_char(r_t.pr_id, 'fm000000');
    j_rec := jsonb_set(j_rec::jsonb, '{pr_id}', (r_t.pr_id::varchar)::jsonb)::json;
    j_rec := jsonb_set(j_rec::jsonb, '{pr_broj}', ('"'||r_t.pr_broj::varchar||'"')::jsonb)::json;
    INSERT INTO hmlg.predmet (pr_id, pr_broj, pr_datum, pr_datum_zak, pr_napomena, pr_primedbe, pr_zakljucak, prs_id, kl_id, vz_id, kr_id)
      VALUES (r_t.pr_id, to_char(r_t.pr_id, 'fm000000'), coalesce(r_t.pr_datum::date, current_date), r_t.pr_datum_zak::date, r_t.pr_napomena, r_t.pr_primedbe, r_t.pr_zakljucak, coalesce(r_t.prs_id, 10), r_t.kl_id, r_t.vz_id, r_t.kr_id);
  ELSE

--     SELECT j.*
--       INTO r_new
--       FROM json_populate_record(null::hmlg.predmet, j_rec) j;

--     SELECT t.*
--       INTO r_old
--       FROM hmlg.predmet t
--       WHERE t.pr_id=r_new.pr_id;

    SELECT COUNT(*)=2 AS ok2updt
      INTO vb_ok2updt
      FROM (
            SELECT t.*
              FROM hmlg.predmet t
              WHERE t.pr_id=r_t.pr_id
            UNION
            SELECT j.*
              FROM json_populate_record(null::hmlg.predmet, j_rec) j
           ) t;

    IF vb_ok2updt THEN
      UPDATE hmlg.predmet t
        SET pr_broj=r_t.pr_broj,
             pr_datum=r_t.pr_datum::date,
             pr_datum_zak=r_t.pr_datum_zak::date,
             pr_napomena=r_t.pr_napomena,
             pr_primedbe=r_t.pr_primedbe,
             pr_zakljucak=r_t.pr_zakljucak,
             prs_id=r_t.prs_id,
             kl_id=r_t.kl_id,
             vz_id=r_t.vz_id,
             kr_id=r_t.kr_id
        WHERE t.pr_id=r_t.pr_id;
      GET DIAGNOSTICS vi_id=ROW_COUNT;
    END IF;
  END IF;

  -- hmlg.predmet_usluga
  FOR r_c IN WITH
               s1 AS
                (
                 SELECT r_t.pr_id,
                        us.us_id
                   FROM regexp_split_to_table(r_t.pus_oznaka, '/', 'i') AS s
                     JOIN sys.usluga us ON (us.us_oznaka=s.s)
                ),
               s2 AS
                (
                 SELECT s.pr_id,
                        s.us_id
                   FROM hmlg.predmet_usluga s
                   WHERE s.pr_id=r_t.pr_id
                )
             SELECT s1.pr_id,
                    s1.us_id,
                    s2.pr_id AS pr_id1,
                    s2.us_id AS us_id1
              FROM s1
                FULL JOIN s2 ON (s2.pr_id=s1.pr_id AND s2.us_id=s1.us_id) LOOP
    IF r_c.pr_id1 IS NULL THEN
      SELECT row_to_json(t)::varchar
        INTO vc_rec
        FROM (
              SELECT r_c.pr_id,
                     r_c.us_id
             ) t;
      vi_row_count1 := hmlg.f_v_predmet_usluga_iu(vc_rec);
    ELSE
      IF r_c.pr_id IS NULL THEN
        SELECT row_to_json(t)::varchar
          INTO vc_rec
          FROM (
                SELECT r_c.pr_id1 AS pr_id,
                       r_c.us_id1 AS us_id
               ) t;
        vi_row_count1 := hmlg.f_v_predmet_usluga_d(vc_rec);
      END IF;
    END IF;
  END LOOP;

  -- hmlg.pr_vzd
  FOR r_c IN WITH
               s1 AS
                (
                 SELECT r_t.pr_id,
                        vzd.vzd_id
                   FROM regexp_split_to_table(r_t.pvd_oznaka, '/', 'i') AS s
                     JOIN sif.vozilo_dokument vzd ON (vzd.vzd_oznaka=s.s)
                ),
               s2 AS
                (
                 SELECT s.pr_id,
                        s.vzd_id
                   FROM hmlg.pr_vzd s
                   WHERE s.pr_id=r_t.pr_id
                )
             SELECT s1.pr_id,
                    s1.vzd_id,
                    s2.pr_id AS pr_id1,
                    s2.vzd_id AS vzd_id1
              FROM s1
                FULL JOIN s2 ON (s2.pr_id=s1.pr_id AND s2.vzd_id=s1.vzd_id) LOOP
    IF r_c.pr_id1 IS NULL THEN
      SELECT row_to_json(t)::varchar
        INTO vc_rec
        FROM (
              SELECT r_c.pr_id,
                     r_c.vzd_id
             ) t;
      vi_row_count1 := hmlg.f_v_pr_vzd_iu(vc_rec);
    ELSE
      IF r_c.pr_id IS NULL THEN
        SELECT row_to_json(t)::varchar
          INTO vc_rec
          FROM (
                SELECT r_c.pr_id1 AS pr_id,
                       r_c.vzd_id1 AS vzd_id
               ) t;
        vi_row_count1 := hmlg.f_v_pr_vzd_d(vc_rec);
      END IF;
    END IF;
  END LOOP;

  IF vi_id>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;
  RETURN vi_id;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'pr_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID predmeta već postoji!';
    ELSEIF regexp_match(sqlerrm, 'pr_broj', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav broj predmeta već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN not_null_violation THEN
    IF regexp_match(sqlerrm, 'pr_id', 'i') IS NOT NULL THEN
      RAISE not_null_violation USING MESSAGE = 'ID predmeta ne može bit prazan!';
    ELSEIF regexp_match(sqlerrm, 'pr_broj', 'i') IS NOT NULL THEN
      RAISE not_null_violation USING MESSAGE = 'Broj predmeta ne može bit prazan!';
    ELSEIF regexp_match(sqlerrm, 'prs_id', 'i') IS NOT NULL THEN
      RAISE not_null_violation USING MESSAGE = 'Status predmeta ne može bit prazan!';
    ELSEIF regexp_match(sqlerrm, 'kl_id', 'i') IS NOT NULL THEN
      RAISE not_null_violation USING MESSAGE = 'ID klijenta ne može bit prazan!';
    ELSEIF regexp_match(sqlerrm, 'vz_id', 'i') IS NOT NULL THEN
      RAISE not_null_violation USING MESSAGE = 'ID vozila ne može bit prazan!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_predmet_iu(varchar) OWNER TO postgres;
