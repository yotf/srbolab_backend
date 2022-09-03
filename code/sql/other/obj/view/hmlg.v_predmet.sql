CREATE OR REPLACE
VIEW hmlg.v_predmet AS
WITH
  pus AS
   (
    SELECT t.pr_id,
           string_agg(coalesce(us.us_oznaka, ''), '/') AS pus_oznaka
      FROM hmlg.predmet_usluga t
        JOIN sys.usluga us ON (us.us_id=t.us_id)
      GROUP BY t.pr_id
   ),
  pvd AS
   (
    SELECT t.pr_id,
           string_agg(coalesce(vzd.vzd_oznaka, ''), '/') AS pvd_oznaka
      FROM hmlg.pr_vzd t
        JOIN sif.vozilo_dokument vzd ON (vzd.vzd_id=t.vzd_id)
      GROUP BY t.pr_id
   )
SELECT pr.pr_id,
       pr.pr_broj,
       pr.kl_id,
       kl.kl_naziv,
       kl.kl_adresa,
       kl.kl_telefon,
       kl.kl_firma,
       to_char(pr.pr_datum, 'dd.mm.yyyy') AS pr_datum,
       to_char(pr.pr_datum_zak, 'dd.mm.yyyy') AS pr_datum_zak,
       pus.pus_oznaka,
       pvd.pvd_oznaka,
       pr.prs_id,
       prs.prs_oznaka,
       prs.prs_naziv,
       pr.pr_napomena,
       pr.pr_primedbe,
       pr.pr_zakljucak,
       pr.kr_id AS kr_id_p,
       kr.kr_username AS kr_username_p,
       pr.vz_id,
       vz.vz_reg,
       vz.vz_sasija,
       vz.vz_sasija_10,
       vz.mr_id,
       vz.mr_naziv,
       vz.md_id,
       vz.md_naziv_k,
       vz.vzpv_id,
       vz.vzpv_oznaka,
       vz.vzpv_naziv,
       vz.vzk_oznaka,
       vz.vzdo_oznaka,
       vz.vzkl_id,
       vz.vzkl_oznaka,
       vz.vzkl_naziv,
       vz.mdt_id,
       vz.mdt_oznaka,
       vz.mdvr_id,
       vz.mdvr_oznaka,
       vz.mdvz_id,
       vz.mdvz_oznaka,
       vz.mt_id,
       vz.vz_motor,
       vz.mto_id,
       vz.mto_oznaka,
       vz.mt_cm3::float,
       vz.mt_kw::float,
       vz.mtt_id,
       vz.gr_id,
       vz.gr_naziv,
       vz.em_id,
       vz.em_naziv,
       vz.vz_co2::float,
       vz.vz_os_broj,
       vz.vz_os_tockova,
       vz.vz_os_tockovi,
       vz.vz_os_pneumatici,
       vz.vz_os_nosivost,
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
       vz.kr_username,
       vz.vzs_id,
       vz.vzs_oznaka,
       vz.vz_osovine
  FROM hmlg.predmet pr
    JOIN hmlg.predmet_status prs ON (prs.prs_id=pr.prs_id)
    JOIN hmlg.v_vozilo vz ON (vz.vz_id=pr.vz_id)
    JOIN hmlg.klijent kl ON (kl.kl_id=pr.kl_id)
    JOIN sys.korisnik kr ON (kr.kr_id=pr.kr_id)
    LEFT JOIN pus ON (pus.pr_id=pr.pr_id)
    LEFT JOIN pvd ON (pvd.pr_id=pr.pr_id);
COMMENT ON VIEW hmlg.v_predmet IS 'Predmet';
COMMENT ON COLUMN hmlg.v_predmet.pus_oznaka IS 'Usluge za predmet';
COMMENT ON COLUMN hmlg.v_predmet.pvd_oznaka IS 'Dokumenta za predmet';
COMMENT ON COLUMN hmlg.v_predmet.vz_os_broj IS 'Broj osovina';
COMMENT ON COLUMN hmlg.v_predmet.vz_os_nosivost IS 'Osovinsko opterećenje';
COMMENT ON COLUMN hmlg.v_predmet.vz_os_tockova IS 'Broj točkova';
COMMENT ON COLUMN hmlg.v_predmet.vz_os_pneumatici IS 'Pneumatici';
COMMENT ON COLUMN hmlg.v_predmet.kr_id_p IS 'ID korisnika';
COMMENT ON COLUMN hmlg.v_predmet.kr_username_p IS 'Korisničko ime korisnika';
COMMENT ON COLUMN hmlg.v_predmet.vz_sasija_10 IS 'Kontrolni karakter iz broja šasije';
COMMENT ON COLUMN hmlg.v_predmet.vz_osovine IS 'Osovine vozila';
