DROP FUNCTION IF EXISTS hmlg.f_r_predmet(integer) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_r_predmet(
                          pi_pr_id integer
                         )
  RETURNS TABLE(
                pr_broj varchar,
                kl_naziv varchar,
                kl_adresa varchar,
                kl_telefon varchar,
                pr_datum varchar,
                pvd_oznaka varchar,
                pr_napomena varchar,
                pr_primedbe varchar,
                pr_zakljucak varchar,
                kr_username varchar,
                kr_prezime varchar,
                kr_ime varchar,
                vz_reg varchar,
                vz_sasija varchar,
                mr_naziv varchar,
                md_naziv_k varchar,
                vz_kategorija varchar,
                vz_vzk varchar,
                vzkl_naziv varchar,
                vz_mdtvv varchar,
                vz_motor varchar,
                mto_oznaka varchar,
                mt_cm3 varchar,
                mt_kw varchar,
                gr_naziv varchar,
                vz_co2 varchar,
                vz_os_broj varchar,
                vz_os_pneumatici varchar,
                vz_os_nosivost varchar,
                vz_elektro varchar,
                vz_godina varchar,
                vz_mesta_sedenje varchar,
                vz_mesta_stajanje varchar,
                vz_masa varchar,
                vz_masa_max varchar,
                vz_nosivost varchar,
                vz_duzina varchar,
                vz_sirina varchar,
                vz_visina varchar,
                vz_kuka varchar,
                vz_km varchar,
                vz_max_brzina varchar,
                vz_kw_kg varchar,
                vz_sert_hmlg_tip varchar,
                vz_sert_emisija varchar,
                vz_sert_buka varchar
               ) AS
$$
DECLARE

  vc_res character varying;

BEGIN

  RETURN QUERY
    WITH
      pvd AS
       (
        SELECT t.pr_id,
               string_agg(coalesce(vzd.vzd_oznaka, ''), '/')::varchar AS pvd_oznaka
          FROM hmlg.pr_vzd t
            JOIN sif.vozilo_dokument vzd ON (vzd.vzd_id=t.vzd_id)
          GROUP BY t.pr_id
       )
    SELECT pr.pr_broj,
           kl.kl_naziv,
           kl.kl_adresa,
           coalesce(kl.kl_telefon, '---') AS kl_telefon,
           to_char(pr.pr_datum, 'dd.mm.yyyy')::varchar AS pr_datum,
           pvd.pvd_oznaka,
           pr.pr_napomena,
           pr.pr_primedbe,
           pr.pr_zakljucak,
           kr.kr_username,
           kr.kr_prezime,
           kr.kr_ime,
           vz.vz_reg,
           vz.vz_sasija,
           vz.mr_naziv,
           vz.md_naziv_k,
           (vz.vzpv_oznaka||' - '||vz.vzpv_naziv)::varchar AS vz_kategorija,
           (vz.vzk_oznaka||CASE WHEN coalesce(vz.vzdo_oznaka, '~')='~' THEN '' ELSE '/'||vz.vzdo_oznaka END)::varchar AS vz_vzk,
           vz.vzkl_naziv,
           (coalesce(vz.mdt_oznaka, '---')||'/'||coalesce(vz.mdvr_oznaka, '---')||'/'||coalesce(vz.mdvz_oznaka, '---'))::varchar AS vz_mdtvv,
           coalesce(vz.vz_motor, '---') AS vz_motor,
           coalesce(vz.mto_oznaka, '---') AS mto_oznaka,
           coalesce(rtrim(to_char(nullif(vz.mt_cm3, 0), 'FM999999D999'), ','), '---')::varchar AS mt_cm3,
           coalesce(rtrim(to_char(nullif(vz.mt_kw, 0), 'FM999999D999'), ','), '---')::varchar AS mt_kw,
           coalesce(vz.gr_naziv, '---') AS gr_naziv,
           (coalesce(vz.em_naziv, '---')||' / '||coalesce(rtrim(to_char(nullif(vz.vz_co2, 0), 'FM999999D999'), ','), '---'))::varchar AS vz_co2,
           (coalesce(vz.vz_os_broj::text, '---')||' / '||coalesce(vz.vz_os_tockova::text, '---'))::varchar AS vz_os_broj,
           coalesce(nullif(vz.vz_os_pneumatici, '-'), '---')::varchar AS vz_os_pneumatici,
           coalesce(vz.vz_os_nosivost, '---')::varchar AS vz_os_nosivost,
           CASE coalesce(vz.vz_elektro, 'N') WHEN 'D' THEN 'Da' ELSE 'Ne' END::varchar AS vz_elektro,
           coalesce(nullif(vz.vz_godina, 0)::text, '---')::varchar AS vz_godina,
           coalesce(nullif(vz.vz_mesta_sedenje, 0)::text, '---')::varchar AS vz_mesta_sedenje,
           coalesce(nullif(vz.vz_mesta_stajanje, 0)::text, '---')::varchar AS vz_mesta_stajanje,
           coalesce(nullif(vz.vz_masa, 0)::text, '---')::varchar AS vz_masa,
           coalesce(nullif(vz.vz_masa_max, 0)::text, '---')::varchar AS vz_masa_max,
           coalesce(nullif(vz.vz_nosivost, 0)::text, '---')::varchar AS vz_nosivost,
           coalesce(nullif(vz.vz_duzina, 0)::text, '---')::varchar AS vz_duzina,
           coalesce(nullif(vz.vz_sirina, 0)::text, '---')::varchar AS vz_sirina,
           coalesce(nullif(vz.vz_visina, 0)::text, '---')::varchar AS vz_visina,
           CASE coalesce(vz.vz_kuka, 'N') WHEN 'D' THEN 'Da' ELSE 'Ne' END::varchar AS vz_kuka,
           coalesce(nullif(vz.vz_km, 0)::text, '---')::varchar AS vz_km,
           coalesce(nullif(vz.vz_max_brzina, 0)::text, '---')::varchar AS vz_max_brzina,
           coalesce(rtrim(to_char(nullif(vz.vz_kw_kg, 0), 'FM999999D999'), ','), '---')::varchar AS vz_kw_kg,
           coalesce(vz.vz_sert_hmlg_tip, '---') AS vz_sert_hmlg_tip,
           coalesce(vz.vz_sert_emisija, '---') AS vz_sert_emisija,
           coalesce(vz.vz_sert_buka, '---') AS vz_sert_buka
      FROM hmlg.predmet pr
        JOIN hmlg.predmet_status prs ON (prs.prs_id=pr.prs_id)
        JOIN hmlg.v_vozilo vz ON (vz.vz_id=pr.vz_id)
        JOIN hmlg.klijent kl ON (kl.kl_id=pr.kl_id)
        JOIN sys.korisnik kr ON (kr.kr_id=pr.kr_id)
        LEFT JOIN pvd ON (pvd.pr_id=pr.pr_id)
      WHERE pr.pr_id=pi_pr_id;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_r_predmet(integer) OWNER TO postgres;
