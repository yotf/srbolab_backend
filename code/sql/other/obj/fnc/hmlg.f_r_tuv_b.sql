DROP FUNCTION IF EXISTS hmlg.f_r_potvrda_b(INTEGER) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_r_potvrda_b(
                            pi_pr_id INTEGER
                           )
  RETURNS TABLE(tis_lbl_coc VARCHAR, tis_lbl_drvlc VARCHAR, tis_desc VARCHAR, tis_value VARCHAR) AS
$$
DECLARE

BEGIN

  RETURN QUERY
    WITH
      tis AS
       (
        SELECT t.tis_order,
               t.tis_lbl_coc,
               t.tis_lbl_drvlc,
               t.tis_desc_sr,
               t.tis_desc_en,
               t.tis_unit
          FROM public.tuv_imp_sert t
          WHERE t.tis_part='b'
       ),
      pr AS
       (
        SELECT COALESCE(p.mr_naziv, '---') AS mr_naziv,
               COALESCE(p.mdt_oznaka, '---')||'/'||COALESCE(mdvr_oznaka, '---')||'/'||COALESCE(mdvz_oznaka, '---') AS vz_mdtvv,
               COALESCE(p.md_naziv_k, '---') AS md_naziv_k,
               COALESCE(NULLIF(p.vz_godina, 0)::TEXT, '---') AS vz_godina,
               COALESCE(NULLIF(p.vz_masa_max, 0)::TEXT, '---') AS vz_masa_max,
               COALESCE(NULLIF(p.vz_masa, 0)::TEXT, '---') AS vz_masa,
               COALESCE(p.vzpv_oznaka, '---') AS vzpv_oznaka,
               COALESCE(p.vzk_oznaka, '---')||CASE COALESCE(p.vzdo_oznaka, '---') WHEN '---' THEN '' ELSE '/'||p.vzdo_oznaka END AS vzk_oznaka,
               COALESCE(p.vz_os_broj::TEXT, '---')||' / '||COALESCE(p.vz_os_tockova::TEXT, '---') AS vz_os_broj,
               COALESCE(NULLIF(p.vz_duzina, 0)::TEXT, '---') AS vz_duzina,
               COALESCE(NULLIF(p.vz_sirina, 0)::TEXT, '---') AS vz_sirina,
               COALESCE(NULLIF(p.vz_visina, 0)::TEXT, '---') AS vz_visina,
               COALESCE(NULLIF(p.vz_os_pneumatici, '-'), '---') AS vz_os_pneumatici,
               COALESCE(NULLIF(p.mto_oznaka, '-'), '---') AS mto_oznaka,
               COALESCE(RTRIM(TO_CHAR(NULLIF(p.mt_cm3, 0), 'FM999999D999'), ','), '---') AS mt_cm3,
               COALESCE(RTRIM(TO_CHAR(NULLIF(p.mt_kw, 0), 'FM999999D999'), ','), '---') AS mt_kw,
               COALESCE(p.gr_naziv, '---') AS gr_naziv,
               COALESCE(RTRIM(TO_CHAR(NULLIF(p.vz_kw_kg, 0), 'FM999999D999'), ','), '---') AS vz_kw_kg,
               COALESCE(NULLIF(p.vz_mesta_sedenje, 0)::TEXT, '---') AS vz_mesta_sedenje,
               COALESCE(NULLIF(p.vz_mesta_stajanje, 0)::TEXT, '---') AS vz_mesta_stajanje,
               COALESCE(p.vz_kuka_sert, '---') AS vz_kuka_sert,
               COALESCE(NULLIF(p.vz_max_brzina, 0)::TEXT, '---') AS vz_max_brzina,
               COALESCE(p.em_naziv, '---')||' / '||COALESCE(RTRIM(TO_CHAR(NULLIF(p.vz_co2, 0), 'FM999999D999'), ','), '---') AS vz_co2,
               COALESCE(p.vz_os_nosivost, '---') AS vz_os_nosivost
          FROM hmlg.v_predmet p
          WHERE p.pr_id=pi_pr_id
       )
    SELECT tis.tis_lbl_coc::VARCHAR,
           tis.tis_lbl_drvlc::VARCHAR,
           (tis.tis_desc_sr||CASE WHEN tis.tis_unit IS NULL THEN '' ELSE ' ('||tis.tis_unit||')' END||':')::VARCHAR AS tis_desc,
           CASE tis.tis_order
             WHEN  1 THEN NULL
             WHEN  2 THEN pr.mr_naziv
             WHEN  3 THEN pr.vz_mdtvv
             WHEN  4 THEN pr.md_naziv_k
             WHEN  5 THEN pr.vz_godina
             WHEN  6 THEN pr.vz_masa_max
             WHEN  7 THEN pr.vz_masa
             WHEN  8 THEN pr.vzpv_oznaka
             WHEN  9 THEN pr.vzk_oznaka
             WHEN 10 THEN pr.vz_os_broj
             WHEN 11 THEN pr.vz_duzina
             WHEN 12 THEN pr.vz_sirina
             WHEN 13 THEN pr.vz_visina
             WHEN 14 THEN pr.vz_os_pneumatici
             WHEN 15 THEN pr.mto_oznaka
             WHEN 16 THEN pr.mt_cm3
             WHEN 17 THEN pr.mt_kw
             WHEN 18 THEN pr.gr_naziv
             WHEN 19 THEN pr.vz_kw_kg
             WHEN 20 THEN pr.vz_mesta_sedenje
             WHEN 21 THEN pr.vz_mesta_stajanje
             WHEN 22 THEN pr.vz_kuka_sert
             WHEN 23 THEN pr.vz_max_brzina
             WHEN 24 THEN pr.vz_co2
             WHEN 25 THEN pr.vz_os_nosivost
         END::VARCHAR AS tis_value
      FROM tis
        CROSS JOIN pr
      ORDER BY tis.tis_order;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_r_potvrda_b(INTEGER) OWNER TO postgres;
