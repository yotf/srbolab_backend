DROP FUNCTION IF EXISTS hmlg.f_v_vozilo_sert_iu(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_vozilo_sert_iu(
                                 pc_rec varchar
                                )
  RETURNS integer AS
$$
DECLARE

  r_t hmlg.v_vozilo_sert;
  r_new hmlg.v_vozilo_sert;
  r_old hmlg.v_vozilo_sert;

  vi_vzs_id integer;
  vi_md_id integer;
  vi_mr_id integer;
  vi_mdt_id integer;
  vi_mdvr_id integer;
  vi_mdvz_id integer;
  vi_mt_id integer;
  vi_row_count integer := 0;
  vi_row_count1 integer := 0;
  vc_rec varchar;

  r_c record;
  vt_cts timestamp;

  vb_ins boolean;
  vb_ok2updt boolean;

  j_rec json := pc_rec::json;

BEGIN

  SELECT j.*
    INTO r_t
    FROM json_populate_record(null::hmlg.v_vozilo_sert, j_rec) j;

-- sif.marka
  IF r_t.mr_naziv IS NOT NULL THEN
    SELECT row_to_json(t)::varchar
      INTO vc_rec
      FROM (
            SELECT r_t.mr_id,
                   r_t.mr_naziv
           ) t;
    IF r_t.mr_id IS NULL THEN
      vi_mr_id := sif.f_marka_iu(vc_rec);
      r_t.mr_id := vi_mr_id;
    ELSE
      vi_row_count := sif.f_marka_iu(vc_rec);
    END IF;
  END IF;

-- sif.model
  IF r_t.md_naziv_k IS NOT NULL THEN
    SELECT row_to_json(t)::varchar
      INTO vc_rec
      FROM (
            SELECT r_t.mr_id,
                   r_t.md_id,
                   r_t.md_naziv_k
           ) t;
    IF r_t.md_id IS NULL THEN
      vi_md_id := sif.f_model_iu(vc_rec);
      r_t.md_id := vi_md_id;
    ELSE
      vi_row_count := sif.f_model_iu(vc_rec);
    END IF;
  END IF;

-- sif.model_tip
  IF r_t.mdt_oznaka IS NOT NULL THEN
    SELECT row_to_json(t)::varchar
      INTO vc_rec
      FROM (
            SELECT r_t.mdt_id,
                   r_t.mdt_oznaka
           ) t;
    IF r_t.mdt_id IS NULL THEN
      vi_mdt_id := sif.f_model_tip_iu(vc_rec);
      r_t.mdt_id := vi_mdt_id;
    ELSE
      vi_row_count := sif.f_model_tip_iu(vc_rec);
    END IF;
  END IF;

-- sif.model_varijanta
  IF r_t.mdvr_oznaka IS NOT NULL THEN
    SELECT row_to_json(t)::varchar
      INTO vc_rec
      FROM (
            SELECT r_t.mdvr_id,
                   r_t.mdvr_oznaka
           ) t;
    IF r_t.mdvr_id IS NULL THEN
      vi_mdvr_id := sif.f_model_varijanta_iu(vc_rec);
      r_t.mdvr_id := vi_mdvr_id;
    ELSE
      vi_row_count := sif.f_model_varijanta_iu(vc_rec);
    END IF;
  END IF;

-- sif.model_verzija
  IF r_t.mdvz_oznaka IS NOT NULL THEN
    SELECT row_to_json(t)::varchar
      INTO vc_rec
      FROM (
            SELECT r_t.mdvz_id,
                   r_t.mdvz_oznaka
           ) t;
    IF r_t.mdvz_id IS NULL THEN
      vi_mdvz_id := sif.f_model_verzija_iu(vc_rec);
      r_t.mdvz_id := vi_mdvz_id;
    ELSE
      vi_row_count := sif.f_model_verzija_iu(vc_rec);
    END IF;
  END IF;

-- sif.motor
  IF upper(substring(r_t.vzpv_oznaka, 1, 1))<>'O' THEN
    SELECT row_to_json(t)::varchar
      INTO vc_rec
      FROM (
            SELECT j.*
              FROM json_populate_record(null::sif.v_motor, j_rec) j
           ) t;
    IF r_t.mt_id IS NULL THEN
      vi_mt_id := sif.f_v_motor_iu(vc_rec);
      r_t.mt_id := vi_mt_id;
    ELSE
      vi_row_count := sif.f_v_motor_iu(vc_rec);
    END IF;
  END IF;

-- hmlg.vozilo_sert
  vb_ins := r_t.vzs_id IS NULL;

  vt_cts := current_timestamp;
  IF 1=1 THEN
    IF vb_ins THEN
      SELECT COALESCE(MAX(t.vzs_id), 0)+1
        INTO vi_vzs_id
        FROM hmlg.vozilo_sert t;

      r_t.vzs_id := vi_vzs_id;
      r_t.vzs_oznaka := to_char(vi_vzs_id, 'fm000000');
      INSERT INTO hmlg.vozilo_sert (vzs_id, vzs_oznaka, vzs_godina, vzs_mesta_sedenje, vzs_mesta_stajanje, vzs_masa, vzs_nosivost, vzs_masa_max, vzs_duzina, vzs_sirina, vzs_visina, vzs_kuka_sert, vzs_max_brzina, vzs_kw_kg, vzs_co2, vzs_sert_hmlg_tip, vzs_sert_emisija, vzs_sert_buka, mr_id, md_id, vzpv_id, vzkl_id, em_id, gr_id, mdt_id, mdvr_id, mdvz_id, mt_id, kr_id)
                            VALUES (r_t.vzs_id, r_t.vzs_oznaka, r_t.vzs_godina, r_t.vzs_mesta_sedenje, r_t.vzs_mesta_stajanje, r_t.vzs_masa, r_t.vzs_nosivost, r_t.vzs_masa_max, r_t.vzs_duzina, r_t.vzs_sirina, r_t.vzs_visina, r_t.vzs_kuka_sert, r_t.vzs_max_brzina, r_t.vzs_kw_kg, r_t.vzs_co2, r_t.vzs_sert_hmlg_tip, r_t.vzs_sert_emisija, r_t.vzs_sert_buka, r_t.mr_id, r_t.md_id, r_t.vzpv_id, r_t.vzkl_id, r_t.em_id, r_t.gr_id, r_t.mdt_id, r_t.mdvr_id, r_t.mdvz_id, r_t.mt_id, r_t.kr_id);
    ELSE
      r_new := r_t;
      SELECT t.*
        INTO r_old
        FROM hmlg.v_vozilo_sert t
        WHERE t.vzs_id=r_new.vzs_id;

      SELECT COUNT(*)=2 AS ok2updt
        INTO vb_ok2updt
        FROM (
              SELECT r_old AS r
                UNION
              SELECT r_new AS r
             ) t;
      IF vb_ok2updt THEN
        UPDATE hmlg.vozilo_sert t
          SET vzs_godina=r_t.vzs_godina,
              vzs_mesta_sedenje=r_t.vzs_mesta_sedenje,
              vzs_mesta_stajanje=r_t.vzs_mesta_stajanje,
              vzs_masa=r_t.vzs_masa,
              vzs_nosivost=r_t.vzs_nosivost,
              vzs_masa_max=r_t.vzs_masa_max,
              vzs_duzina=r_t.vzs_duzina,
              vzs_sirina=r_t.vzs_sirina,
              vzs_visina=r_t.vzs_visina,
              vzs_kuka_sert=r_t.vzs_kuka_sert,
              vzs_max_brzina=r_t.vzs_max_brzina,
              vzs_kw_kg=r_t.vzs_kw_kg,
              vzs_co2=r_t.vzs_co2,
              vzs_sert_hmlg_tip=r_t.vzs_sert_hmlg_tip,
              vzs_sert_emisija=r_t.vzs_sert_emisija,
              vzs_sert_buka=r_t.vzs_sert_buka,
              mr_id=r_t.mr_id,
              md_id=r_t.md_id,
              em_id=r_t.em_id,
              gr_id=r_t.gr_id,
              mdt_id=r_t.mdt_id,
              mdvr_id=r_t.mdvr_id,
              mdvz_id=r_t.mdvz_id,
              mt_id=r_t.mt_id,
              kr_id=r_t.kr_id
          WHERE t.vzs_id=r_t.vzs_id;
        GET DIAGNOSTICS vi_row_count=ROW_COUNT;
      END IF;
    END IF;

    -- hmlg.vozilo_s_osovina
    FOR r_c IN WITH
                 v AS
                  (
                   SELECT r_t.vzs_id,
                          ROW_NUMBER() OVER (ORDER BY 1)::integer AS vzos_rb,
                          t.vzos_nosivost,
                          t.vzos_tockova,
                          t.vzos_pneumatik
                     FROM json_to_recordset(r_t.vzs_osovine::json)
                       AS t (vzs_id integer, vzos_rb integer, vzos_nosivost integer, vzos_tockova integer, vzos_pneumatik varchar)
                  ),
                 vo AS
                  (
                   SELECT v.vzs_id,
                          v.vzos_rb,
                          v.vzos_nosivost,
                          v.vzos_tockova,
                          v.vzos_pneumatik
                     FROM v
                     WHERE v.vzos_rb<=r_t.vzs_os_broj
                  ),
                 vo1 AS
                  (
                   SELECT t.vzs_id,
                          t.vzos_rb,
                          t.vzos_nosivost,
                          t.vzos_tockova,
                          t.vzos_pneumatik
                     FROM hmlg.vozilo_s_osovina t
                       WHERE t.vzs_id=r_t.vzs_id
                  )
               SELECT vo.vzs_id,
                      vo.vzos_rb,
                      vo.vzos_nosivost,
                      vo.vzos_tockova,
                      vo.vzos_pneumatik,
                      vo1.vzs_id AS vzs_id1,
                      vo1.vzos_rb AS vzos_rb1,
                      vo1.vzos_nosivost AS vzos_nosivost1,
                      vo1.vzos_tockova AS vzos_tockova1,
                      vo1.vzos_pneumatik AS vzos_pneumatik1
                 FROM vo
                   FULL JOIN vo1 ON (vo1.vzs_id=vo.vzs_id AND vo1.vzos_rb=vo.vzos_rb)
                 ORDER BY 1, 2, 6, 7 LOOP

      IF r_c.vzs_id IS NULL THEN
        SELECT row_to_json(t)::varchar
          INTO vc_rec
          FROM (
                SELECT r_c.vzs_id1 AS vzs_id,
                       r_c.vzos_rb1 AS vzos_rb
               ) t;
        vi_row_count1 := hmlg.f_vozilo_s_osovina_d(vc_rec);
      ELSE
        SELECT row_to_json(t)::varchar
          INTO vc_rec
          FROM (
                SELECT r_c.vzs_id,
                       CASE WHEN r_c.vzs_id1 IS NULL THEN null::integer ELSE r_c.vzos_rb END AS vzos_rb,
                       r_c.vzos_nosivost,
                       r_c.vzos_tockova,
                       r_c.vzos_pneumatik
               ) t;
        vi_row_count1 := hmlg.f_vozilo_s_osovina_iu(vc_rec);
      END IF;
    END LOOP;

    -- hmlg.vzs_vzk
    FOR r_c IN WITH
                 s1 AS
                  (
                   SELECT r_t.vzs_id,
                          vzk.vzk_id
                     FROM regexp_split_to_table(r_t.vzk_oznaka, '/', 'i') AS s
                       JOIN sif.vozilo_karoserija vzk ON (vzk.vzk_oznaka=s.s)
                  ),
                 s2 AS
                  (
                   SELECT s.vzs_id,
                          s.vzk_id
                     FROM hmlg.vzs_vzk s
                     WHERE s.vzs_id=r_t.vzs_id
                  )
               SELECT s1.vzs_id,
                      s1.vzk_id,
                      s2.vzs_id AS vzs_id1,
                      s2.vzk_id AS vzk_id1
                FROM s1
                  FULL JOIN s2 ON (s2.vzs_id=s1.vzs_id AND s2.vzk_id=s1.vzk_id) LOOP
      IF r_c.vzs_id1 IS NULL THEN
        SELECT row_to_json(t)::varchar
          INTO vc_rec
          FROM (
                SELECT r_c.vzs_id,
                       r_c.vzk_id
               ) t;
        vi_row_count1 := hmlg.f_v_vzs_vzk_iu(vc_rec);
      ELSE
        IF r_c.vzs_id IS NULL THEN
          SELECT row_to_json(t)::varchar
            INTO vc_rec
            FROM (
                  SELECT r_c.vzs_id1 AS vzs_id,
                         r_c.vzk_id1 AS vzk_id
                 ) t;
          vi_row_count1 := hmlg.f_v_vzs_vzk_d(vc_rec);
        END IF;
      END IF;
    END LOOP;

    -- hmlg.vzs_vzdo
    FOR r_c IN WITH
                 s1 AS
                  (
                   SELECT r_t.vzs_id,
                          vzdo.vzdo_id
                     FROM regexp_split_to_table(r_t.vzdo_oznaka, '/', 'i') AS s
                       JOIN sif.vozilo_dod_oznaka vzdo ON (vzdo.vzdo_oznaka=s.s)
                  ),
                 s2 AS
                  (
                   SELECT s.vzs_id,
                          s.vzdo_id
                     FROM hmlg.vzs_vzdo s
                     WHERE s.vzs_id=r_t.vzs_id
                  )
               SELECT s1.vzs_id,
                      s1.vzdo_id,
                      s2.vzs_id AS vzs_id1,
                      s2.vzdo_id AS vzdo_id1
                FROM s1
                  FULL JOIN s2 ON (s2.vzs_id=s1.vzs_id AND s2.vzdo_id=s1.vzdo_id) LOOP
      IF r_c.vzs_id1 IS NULL THEN
        SELECT row_to_json(t)::varchar
          INTO vc_rec
          FROM (
                SELECT r_c.vzs_id,
                       r_c.vzdo_id
               ) t;
        vi_row_count1 := hmlg.f_v_vzs_vzdo_iu(vc_rec);
      ELSE
        IF r_c.vzs_id IS NULL THEN
          SELECT row_to_json(t)::varchar
            INTO vc_rec
            FROM (
                  SELECT r_c.vzs_id1 AS vzs_id,
                         r_c.vzdo_id1 AS vzdo_id
                 ) t;
          vi_row_count1 := hmlg.f_v_vzs_vzdo_d(vc_rec);
        END IF;
      END IF;
    END LOOP;
  END IF;
  IF vb_ins THEN
    vi_row_count := vi_vzs_id;
  END IF;
  IF vi_row_count>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_row_count;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vzs_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID vozila već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vzs_sasija', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Vozilo sa tim brojem šasije već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN not_null_violation THEN
    IF regexp_match(sqlerrm, 'vzs_id', 'i') IS NOT NULL THEN
      RAISE not_null_violation USING MESSAGE = 'ID vozila ne može bit prazan!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava: %: %!', sqlstate, sqlerrm;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_vozilo_sert_iu(varchar) OWNER TO postgres;
