CREATE OR REPLACE
VIEW hmlg.v_vozilo AS
WITH
  os0 AS
   (
    SELECT vzo.vz_id,
           row_number() OVER (PARTITION BY vzo.vz_id ORDER BY vzo.vzo_rb DESC) AS vzo_rb,
           count(*) OVER (PARTITION BY vzo.vz_id)::integer AS vz_os_broj,
           sum(vzo.vzo_tockova) OVER (PARTITION BY vzo.vz_id)::integer AS vz_os_tockova,
           string_agg(coalesce(vzo.vzo_pneumatik, ''), '#') OVER (PARTITION BY vzo.vz_id ORDER BY vzo.vzo_rb)::character varying AS vz_os_pneumatici,
           string_agg(coalesce(vzo.vzo_nosivost, 0)::text, ' / ') OVER (PARTITION BY vzo.vz_id ORDER BY vzo.vzo_rb)::character varying AS vz_os_nosivost,
           string_agg(coalesce(vzo.vzo_tockova, 0)::text, ' / ') OVER (PARTITION BY vzo.vz_id ORDER BY vzo.vzo_rb)::character varying AS vz_os_tockovi
      FROM hmlg.vozilo_osovina vzo
   ),
  os AS
   (
    SELECT os0.vz_id,
           os0.vz_os_broj,
           os0.vz_os_tockova,
           os0.vz_os_tockovi,
           (SELECT string_agg(DISTINCT t, ' / ') AS p FROM unnest(string_to_array(os0.vz_os_pneumatici, '#')) t)::character varying AS vz_os_pneumatici,
           os0.vz_os_nosivost
      FROM os0
      WHERE os0.vzo_rb=1
   ),
  vzk AS
   (
    SELECT t.vz_id,
           string_agg(coalesce(vzk.vzk_oznaka, ''), '/') AS vzk_oznaka
      FROM hmlg.vz_vzk t
        JOIN sif.vozilo_karoserija vzk ON (vzk.vzk_id=t.vzk_id)
      GROUP BY t.vz_id
   ),
  vzdo AS
   (
    SELECT t.vz_id,
           string_agg(coalesce(vzdo.vzdo_oznaka, ''), '/') AS vzdo_oznaka
      FROM hmlg.vz_vzdo t
        JOIN sif.vozilo_dod_oznaka vzdo ON (vzdo.vzdo_id=t.vzdo_id)
      GROUP BY t.vz_id
   )
SELECT vz.vz_id,
       vz.vz_reg,
       vz.vz_sasija,
       nullif(substring(vz.vz_sasija, CASE WHEN coalesce(mr.mr_naziv, '#') ~* 'FORD' THEN 11 ELSE 10 END, 1), '')::character varying AS vz_sasija_10,
       vz.mr_id,
       mr.mr_naziv,
       vz.md_id,
       md.md_naziv_k,
       vz.vzpv_id,
       vzpv.vzpv_oznaka,
       vzpv.vzpv_naziv,
       vzk.vzk_oznaka,
       vzdo.vzdo_oznaka,
       vz.vzkl_id,
       vzkl.vzkl_oznaka,
       vzkl.vzkl_naziv,
       vz.mdt_id,
       mdt.mdt_oznaka,
       vz.mdvr_id,
       mdvr.mdvr_oznaka,
       vz.mdvz_id,
       mdvz.mdvz_oznaka,
       vz.mt_id,
       vz.vz_motor,
       mto.mto_id,
       mto.mto_oznaka,
       mt.mt_cm3::float,
       mt.mt_kw::float,
       mt.mtt_id,
       vz.gr_id,
       gr.gr_naziv,
       vz.em_id,
       em.em_naziv,
       vz.vz_co2::float,
       os.vz_os_broj,
       os.vz_os_tockova,
       os.vz_os_tockovi,
       os.vz_os_pneumatici,
       os.vz_os_nosivost,
       vz.vz_elektro,
       vz.vz_godina,
       vz.vz_mesta_sedenje,
       vz.vz_mesta_stajanje,
       vz.vz_masa,
       vz.vz_nosivost,
       vz.vz_masa_max,
       vz.vz_duzina,
       vz.vz_sirina,
       vz.vz_visina,
       vz.vz_kuka,
       vz.vz_kuka_sert,
       vz.vz_km,
       vz.vz_max_brzina,
       vz.vz_kw_kg::float,
       vz.vz_sert_hmlg_tip,
       vz.vz_sert_emisija,
       vz.vz_sert_buka,
       vz.kr_id,
       kr.kr_username,
       vzs.vzs_id,
       vzs.vzs_oznaka,
       null::varchar AS vz_osovine
  FROM hmlg.vozilo vz
    JOIN sys.korisnik kr ON (kr.kr_id=vz.kr_id)
    LEFT JOIN sif.marka mr ON (mr.mr_id=vz.mr_id)
    LEFT JOIN sif.model md ON (md.mr_id=mr.mr_id AND md.md_id=vz.md_id)
    LEFT JOIN sif.motor mt ON (mt.mt_id=vz.mt_id)
    LEFT JOIN sif.motor_oznaka mto ON (mto.mto_id=mt.mto_id)
    LEFT JOIN sif.vozilo_podvrsta vzpv ON (vzpv.vzpv_id=vz.vzpv_id)
    LEFT JOIN sif.vozilo_klasa vzkl ON (vzkl.vzkl_id=vz.vzkl_id)
    LEFT JOIN sif.emisija em ON (em.em_id=vz.em_id)
    LEFT JOIN sif.gorivo gr ON (gr.gr_id=vz.gr_id)
    LEFT JOIN sif.model_tip mdt ON (mdt.mdt_id=vz.mdt_id)
    LEFT JOIN sif.model_varijanta mdvr ON (mdvr.mdvr_id=vz.mdvr_id)
    LEFT JOIN sif.model_verzija mdvz ON (mdvz.mdvz_id=vz.mdvz_id)
    LEFT JOIN hmlg.vozilo_sert vzs ON (vz.vzs_id=vzs.vzs_id)
    LEFT JOIN os ON (os.vz_id=vz.vz_id)
    LEFT JOIN vzk ON (vzk.vz_id=vz.vz_id)
    LEFT JOIN vzdo ON (vzdo.vz_id=vz.vz_id);
COMMENT ON VIEW hmlg.v_vozilo IS 'Vozilo';
COMMENT ON COLUMN hmlg.v_vozilo.vz_os_broj IS 'Broj osovina';
COMMENT ON COLUMN hmlg.v_vozilo.vz_os_nosivost IS 'Osovinsko opterećenje';
COMMENT ON COLUMN hmlg.v_vozilo.vz_os_tockova IS 'Broj točkova';
COMMENT ON COLUMN hmlg.v_vozilo.vz_os_tockovi IS 'Točkovi po osovinama';
COMMENT ON COLUMN hmlg.v_vozilo.vz_os_pneumatici IS 'Pneumatici';
COMMENT ON COLUMN hmlg.v_vozilo.vz_sasija_10 IS 'Kontrolni karakter iz broja šasije';
COMMENT ON COLUMN hmlg.v_vozilo.vz_osovine IS 'Osovine vozila';
