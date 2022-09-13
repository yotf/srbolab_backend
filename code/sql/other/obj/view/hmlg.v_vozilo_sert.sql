CREATE OR REPLACE
VIEW hmlg.v_vozilo_sert AS
WITH
  os0 AS
   (
    SELECT vzos.vzs_id,
           row_number() OVER (PARTITION BY vzos.vzs_id ORDER BY vzos.vzos_rb DESC) AS vzos_rb,
           count(*) OVER (PARTITION BY vzos.vzs_id)::integer AS vzs_os_broj,
           sum(vzos.vzos_tockova) OVER (PARTITION BY vzos.vzs_id)::integer AS vzs_os_tockova,
           string_agg(coalesce(vzos.vzos_pneumatik, ''), '#') OVER (PARTITION BY vzos.vzs_id ORDER BY vzos.vzos_rb)::character varying AS vzs_os_pneumatici,
           string_agg(coalesce(vzos.vzos_nosivost, 0)::text, ' / ') OVER (PARTITION BY vzos.vzs_id ORDER BY vzos.vzos_rb)::character varying AS vzs_os_nosivost,
           string_agg(coalesce(vzos.vzos_tockova, 0)::text, ' / ') OVER (PARTITION BY vzos.vzs_id ORDER BY vzos.vzos_rb)::character varying AS vzs_os_tockovi
      FROM hmlg.vozilo_s_osovina vzos
   ),
  os AS
   (
    SELECT os0.vzs_id,
           os0.vzs_os_broj,
           os0.vzs_os_tockova,
           os0.vzs_os_tockovi,
           (SELECT string_agg(DISTINCT t, ' / ') AS p FROM unnest(string_to_array(os0.vzs_os_pneumatici, '#')) t)::character varying AS vzs_os_pneumatici,
           os0.vzs_os_nosivost
      FROM os0
      WHERE os0.vzos_rb=1
   ),
  vzk AS
   (
    SELECT t.vzs_id,
           string_agg(coalesce(vzk.vzk_oznaka, ''), '/') AS vzk_oznaka
      FROM hmlg.vzs_vzk t
        JOIN sif.vozilo_karoserija vzk ON (vzk.vzk_id=t.vzk_id)
      GROUP BY t.vzs_id
   ),
  vzdo AS
   (
    SELECT t.vzs_id,
           string_agg(coalesce(vzdo.vzdo_oznaka, ''), '/') AS vzdo_oznaka
      FROM hmlg.vzs_vzdo t
        JOIN sif.vozilo_dod_oznaka vzdo ON (vzdo.vzdo_id=t.vzdo_id)
      GROUP BY t.vzs_id
   )
SELECT vzs.vzs_id,
       vzs.vzs_oznaka,
       vzs.mr_id,
       mr.mr_naziv,
       vzs.md_id,
       md.md_naziv_k,
       vzs.vzpv_id,
       vzpv.vzpv_oznaka,
       vzpv.vzpv_naziv,
       vzk.vzk_oznaka,
       vzdo.vzdo_oznaka,
       vzs.vzkl_id,
       vzkl.vzkl_oznaka,
       vzkl.vzkl_naziv,
       vzs.mdt_id,
       mdt.mdt_oznaka,
       vzs.mdvr_id,
       mdvr.mdvr_oznaka,
       vzs.mdvz_id,
       mdvz.mdvz_oznaka,
       vzs.mt_id,
       mto.mto_id,
       mto.mto_oznaka,
       mt.mt_cm3::float,
       mt.mt_kw::float,
       mt.mtt_id,
       vzs.gr_id,
       gr.gr_naziv,
       vzs.em_id,
       em.em_naziv,
       vzs.vzs_co2::float,
       os.vzs_os_broj,
       os.vzs_os_tockova,
       os.vzs_os_tockovi,
       os.vzs_os_pneumatici,
       os.vzs_os_nosivost,
       vzs.vzs_godina,
       vzs.vzs_mesta_sedenje,
       vzs.vzs_mesta_stajanje,
       vzs.vzs_masa,
       vzs.vzs_nosivost,
       vzs.vzs_masa_max,
       vzs.vzs_duzina,
       vzs.vzs_sirina,
       vzs.vzs_visina,
       vzs.vzs_kuka_sert,
       vzs.vzs_max_brzina,
       vzs.vzs_kw_kg::float,
       vzs.vzs_sert_hmlg_tip,
       vzs.vzs_sert_emisija,
       vzs.vzs_sert_buka,
       vzs.kr_id,
       kr.kr_username,
       null::varchar AS vzs_osovine
  FROM hmlg.vozilo_sert vzs
    JOIN sys.korisnik kr ON (kr.kr_id=vzs.kr_id)
    LEFT JOIN sif.marka mr ON (mr.mr_id=vzs.mr_id)
    LEFT JOIN sif.model md ON (md.mr_id=mr.mr_id AND md.md_id=vzs.md_id)
    LEFT JOIN sif.motor mt ON (mt.mt_id=vzs.mt_id)
    LEFT JOIN sif.motor_oznaka mto ON (mto.mto_id=mt.mto_id)
    LEFT JOIN sif.vozilo_podvrsta vzpv ON (vzpv.vzpv_id=vzs.vzpv_id)
    LEFT JOIN sif.vozilo_klasa vzkl ON (vzkl.vzkl_id=vzs.vzkl_id)
    LEFT JOIN sif.emisija em ON (em.em_id=vzs.em_id)
    LEFT JOIN sif.gorivo gr ON (gr.gr_id=vzs.gr_id)
    LEFT JOIN sif.model_tip mdt ON (mdt.mdt_id=vzs.mdt_id)
    LEFT JOIN sif.model_varijanta mdvr ON (mdvr.mdvr_id=vzs.mdvr_id)
    LEFT JOIN sif.model_verzija mdvz ON (mdvz.mdvz_id=vzs.mdvz_id)
    LEFT JOIN os ON (os.vzs_id=vzs.vzs_id)
    LEFT JOIN vzk ON (vzk.vzs_id=vzs.vzs_id)
    LEFT JOIN vzdo ON (vzdo.vzs_id=vzs.vzs_id);
COMMENT ON VIEW hmlg.v_vozilo_sert IS 'Vozilo';
COMMENT ON COLUMN hmlg.v_vozilo_sert.vzs_os_broj IS 'Broj osovina';
COMMENT ON COLUMN hmlg.v_vozilo_sert.vzs_os_nosivost IS 'Osovinsko opterećenje';
COMMENT ON COLUMN hmlg.v_vozilo_sert.vzs_os_tockova IS 'Broj točkova';
COMMENT ON COLUMN hmlg.v_vozilo_sert.vzs_os_tockovi IS 'Točkovi po osovinama';
COMMENT ON COLUMN hmlg.v_vozilo_sert.vzs_os_pneumatici IS 'Pneumatici';
COMMENT ON COLUMN hmlg.v_vozilo_sert.vzs_osovine IS 'Osovine vozila';
