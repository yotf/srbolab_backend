DROP FUNCTION IF EXISTS hmlg.f_v_vozilo_iu(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_v_vozilo_iu(
                            pc_rec varchar
                           )
  RETURNS integer AS
$$
DECLARE

  r_t hmlg.v_vozilo;
  r_new hmlg.v_vozilo;
  r_old hmlg.v_vozilo;

  vi_vz_id integer;
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
    FROM json_populate_record(null::hmlg.v_vozilo, j_rec) j;
  r_t.vz_sasija := UPPER(r_t.vz_sasija);

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

-- hmlg.vozilo
  vb_ins := r_t.vz_id IS NULL;

  vt_cts := current_timestamp;
  IF r_t.vz_sasija IS NOT NULL THEN
    IF vb_ins THEN
      SELECT COALESCE(MAX(t.vz_id), 0)+1
        INTO vi_vz_id
        FROM hmlg.vozilo t;

      r_t.vz_id := vi_vz_id;
      INSERT INTO hmlg.vozilo (vz_id, vz_sasija, vz_godina, vz_reg, vz_mesta_sedenje, vz_mesta_stajanje, vz_masa, vz_nosivost, vz_masa_max, vz_duzina, vz_sirina, vz_visina, vz_kuka, vz_kuka_sert, vz_km, vz_max_brzina, vz_kw_kg, vz_motor, vz_co2, vz_elektro, vz_sert_hmlg_tip, vz_sert_emisija, vz_sert_buka, vz_vreme, mr_id, md_id, vzpv_id, vzkl_id, em_id, gr_id, mdt_id, mdvr_id, mdvz_id, mt_id, kr_id)
                       VALUES (r_t.vz_id, r_t.vz_sasija, r_t.vz_godina, r_t.vz_reg, r_t.vz_mesta_sedenje, r_t.vz_mesta_stajanje, r_t.vz_masa, r_t.vz_nosivost, r_t.vz_masa_max, r_t.vz_duzina, r_t.vz_sirina, r_t.vz_visina, r_t.vz_kuka, r_t.vz_kuka_sert, r_t.vz_km, r_t.vz_max_brzina, r_t.vz_kw_kg, r_t.vz_motor, r_t.vz_co2, r_t.vz_elektro, r_t.vz_sert_hmlg_tip, r_t.vz_sert_emisija, r_t.vz_sert_buka, vt_cts, r_t.mr_id, r_t.md_id, r_t.vzpv_id, r_t.vzkl_id, r_t.em_id, r_t.gr_id, r_t.mdt_id, r_t.mdvr_id, r_t.mdvz_id, r_t.mt_id, r_t.kr_id);
    ELSE
      r_new := r_t;
      SELECT t.*
        INTO r_old
        FROM hmlg.v_vozilo t
        WHERE t.vz_id=r_new.vz_id;

      SELECT COUNT(*)=2 AS ok2updt
        INTO vb_ok2updt
        FROM (
              SELECT r_old AS r
                UNION
              SELECT r_new AS r
             ) t;
      IF vb_ok2updt THEN
        UPDATE hmlg.vozilo t
          SET vz_sasija=r_t.vz_sasija,
              vz_godina=r_t.vz_godina,
              vz_reg=r_t.vz_reg,
              vz_mesta_sedenje=r_t.vz_mesta_sedenje,
              vz_mesta_stajanje=r_t.vz_mesta_stajanje,
              vz_masa=r_t.vz_masa,
              vz_nosivost=r_t.vz_nosivost,
              vz_masa_max=r_t.vz_masa_max,
              vz_duzina=r_t.vz_duzina,
              vz_sirina=r_t.vz_sirina,
              vz_visina=r_t.vz_visina,
              vz_kuka=r_t.vz_kuka,
              vz_kuka_sert=r_t.vz_kuka_sert,
              vz_km=r_t.vz_km,
              vz_max_brzina=r_t.vz_max_brzina,
              vz_kw_kg=r_t.vz_kw_kg,
              vz_motor=r_t.vz_motor,
              vz_co2=r_t.vz_co2,
              vz_elektro=r_t.vz_elektro,
              vz_sert_hmlg_tip=r_t.vz_sert_hmlg_tip,
              vz_sert_emisija=r_t.vz_sert_emisija,
              vz_sert_buka=r_t.vz_sert_buka,
              vz_vreme=vt_cts,
              mr_id=r_t.mr_id,
              md_id=r_t.md_id,
              em_id=r_t.em_id,
              gr_id=r_t.gr_id,
              mdt_id=r_t.mdt_id,
              mdvr_id=r_t.mdvr_id,
              mdvz_id=r_t.mdvz_id,
              mt_id=r_t.mt_id,
              kr_id=r_t.kr_id
          WHERE t.vz_id=r_t.vz_id;
        GET DIAGNOSTICS vi_row_count=ROW_COUNT;
      END IF;
    END IF;

    -- hmlg.vozilo_osovina
    FOR r_c IN WITH
                 v AS
                  (
                   SELECT r_t.vz_id,
                          ROW_NUMBER() OVER (ORDER BY 1)::integer AS vzo_rb,
                          t.vzo_nosivost,
                          t.vzo_tockova,
                          t.vzo_pneumatik
                     FROM json_to_recordset(r_t.vz_osovine::json)
                       AS t (vz_id integer, vzo_rb integer, vzo_nosivost integer, vzo_tockova integer, vzo_pneumatik varchar)
                  ),
                 vo AS
                  (
                   SELECT v.vz_id,
                          v.vzo_rb,
                          v.vzo_nosivost,
                          v.vzo_tockova,
                          v.vzo_pneumatik
                     FROM v
                     WHERE v.vzo_rb<=r_t.vz_os_broj
                  ),
                 vo1 AS
                  (
                   SELECT t.vz_id,
                          t.vzo_rb,
                          t.vzo_nosivost,
                          t.vzo_tockova,
                          t.vzo_pneumatik
                     FROM hmlg.vozilo_osovina t
                       WHERE t.vz_id=r_t.vz_id
                  )
               SELECT vo.vz_id,
                      vo.vzo_rb,
                      vo.vzo_nosivost,
                      vo.vzo_tockova,
                      vo.vzo_pneumatik,
                      vo1.vz_id AS vz_id1,
                      vo1.vzo_rb AS vzo_rb1,
                      vo1.vzo_nosivost AS vzo_nosivost1,
                      vo1.vzo_tockova AS vzo_tockova1,
                      vo1.vzo_pneumatik AS vzo_pneumatik1
                 FROM vo
                   FULL JOIN vo1 ON (vo1.vz_id=vo.vz_id AND vo1.vzo_rb=vo.vzo_rb)
                 ORDER BY 1, 2, 6, 7 LOOP

      IF r_c.vz_id IS NULL THEN
        SELECT row_to_json(t)::varchar
          INTO vc_rec
          FROM (
                SELECT r_c.vz_id1 AS vz_id,
                       r_c.vzo_rb1 AS vzo_rb
               ) t;
        vi_row_count1 := hmlg.f_vozilo_osovina_d(vc_rec);
      ELSE
        SELECT row_to_json(t)::varchar
          INTO vc_rec
          FROM (
                SELECT r_c.vz_id,
                       CASE WHEN r_c.vz_id1 IS NULL THEN null::integer ELSE r_c.vzo_rb END AS vzo_rb,
                       r_c.vzo_nosivost,
                       r_c.vzo_tockova,
                       r_c.vzo_pneumatik
               ) t;
        vi_row_count1 := hmlg.f_vozilo_osovina_iu(vc_rec);
      END IF;
    END LOOP;

    -- hmlg.vz_vzk
    FOR r_c IN WITH
                 s1 AS
                  (
                   SELECT r_t.vz_id,
                          vzk.vzk_id
                     FROM regexp_split_to_table(r_t.vzk_oznaka, '/', 'i') AS s
                       JOIN sif.vozilo_karoserija vzk ON (vzk.vzk_oznaka=s.s)
                  ),
                 s2 AS
                  (
                   SELECT s.vz_id,
                          s.vzk_id
                     FROM hmlg.vz_vzk s
                     WHERE s.vz_id=r_t.vz_id
                  )
               SELECT s1.vz_id,
                      s1.vzk_id,
                      s2.vz_id AS vz_id1,
                      s2.vzk_id AS vzk_id1
                FROM s1
                  FULL JOIN s2 ON (s2.vz_id=s1.vz_id AND s2.vzk_id=s1.vzk_id) LOOP
      IF r_c.vz_id1 IS NULL THEN
        SELECT row_to_json(t)::varchar
          INTO vc_rec
          FROM (
                SELECT r_c.vz_id,
                       r_c.vzk_id
               ) t;
        vi_row_count1 := hmlg.f_v_vz_vzk_iu(vc_rec);
      ELSE
        IF r_c.vz_id IS NULL THEN
          SELECT row_to_json(t)::varchar
            INTO vc_rec
            FROM (
                  SELECT r_c.vz_id1 AS vz_id,
                         r_c.vzk_id1 AS vzk_id
                 ) t;
          vi_row_count1 := hmlg.f_v_vz_vzk_d(vc_rec);
        END IF;
      END IF;
    END LOOP;

    -- hmlg.vz_vzdo
    FOR r_c IN WITH
                 s1 AS
                  (
                   SELECT r_t.vz_id,
                          vzdo.vzdo_id
                     FROM regexp_split_to_table(r_t.vzdo_oznaka, '/', 'i') AS s
                       JOIN sif.vozilo_dod_oznaka vzdo ON (vzdo.vzdo_oznaka=s.s)
                  ),
                 s2 AS
                  (
                   SELECT s.vz_id,
                          s.vzdo_id
                     FROM hmlg.vz_vzdo s
                     WHERE s.vz_id=r_t.vz_id
                  )
               SELECT s1.vz_id,
                      s1.vzdo_id,
                      s2.vz_id AS vz_id1,
                      s2.vzdo_id AS vzdo_id1
                FROM s1
                  FULL JOIN s2 ON (s2.vz_id=s1.vz_id AND s2.vzdo_id=s1.vzdo_id) LOOP
      IF r_c.vz_id1 IS NULL THEN
        SELECT row_to_json(t)::varchar
          INTO vc_rec
          FROM (
                SELECT r_c.vz_id,
                       r_c.vzdo_id
               ) t;
        vi_row_count1 := hmlg.f_v_vz_vzdo_iu(vc_rec);
      ELSE
        IF r_c.vz_id IS NULL THEN
          SELECT row_to_json(t)::varchar
            INTO vc_rec
            FROM (
                  SELECT r_c.vz_id1 AS vz_id,
                         r_c.vzdo_id1 AS vzdo_id
                 ) t;
          vi_row_count1 := hmlg.f_v_vz_vzdo_d(vc_rec);
        END IF;
      END IF;
    END LOOP;
/*
  -- vozilo_gas
    vz_id,
    vzg_id,
    vzg_tip,
    vzg_aktivan,
    org_id
    -- vozilo_gu
      vz_id,
      vzg_id,
      vzgu_id,
      vzgu_broj,
      agu_id,
      agp_id,
      agh_id
*/
  END IF;
  IF vb_ins THEN
    vi_row_count := vi_vz_id;
  END IF;
  IF vi_row_count>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_row_count;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vz_pk', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Takav ID vozila već postoji!';
    ELSEIF regexp_match(sqlerrm, 'vz_sasija', 'i') IS NOT NULL THEN
      RAISE unique_violation USING MESSAGE = 'Vozilo sa tim brojem šasije već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN not_null_violation THEN
    IF regexp_match(sqlerrm, 'vz_id', 'i') IS NOT NULL THEN
      RAISE not_null_violation USING MESSAGE = 'ID vozila ne može bit prazan!';
    ELSEIF regexp_match(sqlerrm, 'vz_sasija', 'i') IS NOT NULL THEN
      RAISE not_null_violation USING MESSAGE = 'Broj šasije ne može bit prazan!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_v_vozilo_iu(varchar) OWNER TO postgres;
