CREATE OR REPLACE
VIEW _t.v_vozilo_imp AS
  SELECT count(*) OVER (PARTITION BY vzi.vz_sasija) AS vz_sasija_br,
         row_number() OVER (PARTITION BY vzi.vz_sasija ORDER BY vzi.pr_datum DESC, vzi.pr_broj) AS vz_sasija_rb,
         vzi.vzi_br,
         dense_rank() OVER (ORDER BY vzi.vz_sasija)+100000 AS vz_id,
         to_char(dense_rank() OVER (ORDER BY vzi.vz_sasija)+100000, 'fm000000') AS vz_oznaka,
         max(vzi.pr_broj) OVER (PARTITION BY vzi.vz_sasija) AS pr_broj,
         max(vzi.kl_naziv) OVER (PARTITION BY vzi.vz_sasija) AS kl_naziv,
         max(vzi.kl_adresa) OVER (PARTITION BY vzi.vz_sasija) AS kl_adresa,
         max(vzi.kl_telefon) OVER (PARTITION BY vzi.vz_sasija) AS kl_telefon,
         vzi.vz_sasija,
         max(vzi.vzpv_naziv) OVER (PARTITION BY vzi.vz_sasija) AS vzpv_naziv,
         max(vzi.vzk_naziv) OVER (PARTITION BY vzi.vz_sasija) AS vzk_naziv,
         max(vzi.mr_naziv) OVER (PARTITION BY vzi.vz_sasija) AS mr_naziv,
         max(vzi.mdt_oznaka) OVER (PARTITION BY vzi.vz_sasija) AS mdt_oznaka,
         max(vzi.mdvr_oznaka) OVER (PARTITION BY vzi.vz_sasija) AS mdvr_oznaka,
         max(vzi.mdvz_oznaka) OVER (PARTITION BY vzi.vz_sasija) AS mdvz_oznaka,
         max(vzi.md_naziv_k) OVER (PARTITION BY vzi.vz_sasija) AS md_naziv_k,
         max(coalesce(vzi.vz_br_osovina, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_br_osovina,
         max(coalesce(vzi.vz_br_tockova, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_br_tockova,
         max(coalesce(vzi.vzo_nosivost1, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vzo_nosivost1,
         max(coalesce(vzi.vzo_nosivost2, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vzo_nosivost2,
         max(coalesce(vzi.vzo_nosivost3, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vzo_nosivost3,
         max(coalesce(vzi.vzo_nosivost4, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vzo_nosivost4,
         max(vzi.vzo_pneumatik1) OVER (PARTITION BY vzi.vz_sasija) AS vzo_pneumatik1,
         max(vzi.vzo_pneumatik2) OVER (PARTITION BY vzi.vz_sasija) AS vzo_pneumatik2,
         max(vzi.vzo_pneumatik3) OVER (PARTITION BY vzi.vz_sasija) AS vzo_pneumatik3,
         max(vzi.vzo_pneumatik4) OVER (PARTITION BY vzi.vz_sasija) AS vzo_pneumatik4,
         max(coalesce(vzi.vz_masa, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_masa,
         max(coalesce(vzi.vz_masa_max, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_masa_max,
         max(
             CASE 
               WHEN substring(coalesce(vzi.vzpv_naziv, '#'), 1, 1) IN ('N', 'O') THEN
                 CASE coalesce(vzi.vz_masa, 0)*coalesce(vzi.vz_masa_max, 0)
                   WHEN 0 THEN coalesce(vzi.vz_nosivost, 0)
                   ELSE nullif(coalesce(vzi.vz_nosivost, vzi.vz_masa_max-vzi.vz_masa), 0)
                 END
               ELSE
                coalesce(vzi.vz_nosivost, 0)
             END
            ) OVER (PARTITION BY vzi.vz_sasija) AS vz_nosivost,
         max(vzi.vz_motor) OVER (PARTITION BY vzi.vz_sasija) AS vz_motor,
         max(vzi.mt_oznaka) OVER (PARTITION BY vzi.vz_sasija) AS mt_oznaka,
         max(coalesce(vzi.mt_cm3, 0)) OVER (PARTITION BY vzi.vz_sasija) AS mt_cm3,
         max(coalesce(vzi.mt_kw, 0)) OVER (PARTITION BY vzi.vz_sasija) AS mt_kw,
         max(vzi.gr_naziv) OVER (PARTITION BY vzi.vz_sasija) AS gr_naziv,
         max(vzi.gr_gas) OVER (PARTITION BY vzi.vz_sasija) AS gr_gas,
         max(vzi.vz_elektro) OVER (PARTITION BY vzi.vz_sasija) AS vz_elektro,
         max(vzi.vz_mesta_sedenje) OVER (PARTITION BY vzi.vz_sasija) AS vz_mesta_sedenje,
         max(vzi.vz_mesta_stajanje) OVER (PARTITION BY vzi.vz_sasija) AS vz_mesta_stajanje,
         max(coalesce(vzi.vz_kw_kg, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_kw_kg,
         max(coalesce(vzi.vz_kmh, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_kmh,
         max(coalesce(vzi.vz_godina, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_godina,
         max(coalesce(vzi.vz_duzina, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_duzina,
         max(coalesce(vzi.vz_sirina, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_sirina,
         max(coalesce(vzi.vz_visina, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_visina,
         max(coalesce(vzi.vz_km, 0)) OVER (PARTITION BY vzi.vz_sasija) AS vz_km,
         max(vzi.vz_kuka) OVER (PARTITION BY vzi.vz_sasija) AS vz_kuka,
         max(vzi.em_naziv) OVER (PARTITION BY vzi.vz_sasija) AS em_naziv,
         max(vzi.vz_co2) OVER (PARTITION BY vzi.vz_sasija) AS vz_co2,
         max(vzi.vz_napomena) OVER (PARTITION BY vzi.vz_sasija) AS vz_napomena,
         max(vzi.vz_primedbe) OVER (PARTITION BY vzi.vz_sasija) AS vz_primedbe,
         max(vzi.pr_datum) OVER (PARTITION BY vzi.vz_sasija) AS pr_datum,
         max(vzi.kr_ime) OVER (PARTITION BY vzi.vz_sasija) AS kr_ime,
         max(vzi.vz_saobracajna) OVER (PARTITION BY vzi.vz_sasija) AS vz_saobracajna,
         max(vzi.vz_odg_dok) OVER (PARTITION BY vzi.vz_sasija) AS vz_odg_dok,
         max(vzi.vz_coc) OVER (PARTITION BY vzi.vz_sasija) AS vz_coc,
         max(vzi.vz_potvrda_pr) OVER (PARTITION BY vzi.vz_sasija) AS vz_potvrda_pr,
         max(vzi.vz_tip_var_ver) OVER (PARTITION BY vzi.vz_sasija) AS vz_tip_var_ver,
         max(vzi.vz_pneumatici) OVER (PARTITION BY vzi.vz_sasija) AS vz_pneumatici,
         max(vzi.vz_zakljucak) OVER (PARTITION BY vzi.vz_sasija) AS vz_zakljucak,
         max(vzi.vz_prebaceno1) OVER (PARTITION BY vzi.vz_sasija) AS vz_prebaceno1,
         max(vzi.vz_prebaceno2) OVER (PARTITION BY vzi.vz_sasija) AS vz_prebaceno2,
         max(vzi.vz_br_oso_toc) OVER (PARTITION BY vzi.vz_sasija) AS vz_br_oso_toc,
         max(vzi.vz_karakter10) OVER (PARTITION BY vzi.vz_sasija) AS vz_karakter10
    FROM _t.vozilo_imp vzi
    WHERE vzi.vz_sasija IS NOT NULL;
