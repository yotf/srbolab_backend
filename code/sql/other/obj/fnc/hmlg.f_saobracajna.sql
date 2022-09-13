DROP FUNCTION IF EXISTS hmlg.f_saobracajna(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_saobracajna(
                            pc_text character varying
                           )
  RETURNS TABLE(vz_reg varchar, kl_id integer, kl_naziv varchar, kl_adresa varchar, kl_telefon varchar, kl_firma varchar, mr_id integer, mr_naziv varchar, vzv_id integer, vzv_oznaka varchar, vzv_naziv varchar, vz_godina integer, md_id integer, md_naziv_k varchar, vz_sert_hmlg_tip varchar, vz_os_broj integer, vz_sasija varchar, vz_cm3 float, vz_motor varchar, vz_masa integer, vz_kw float, vz_nosivost integer, vz_kw_kg float, vz_masa_max integer, vzpv_id integer, vzpv_oznaka varchar, vzpv_naziv varchar, gr_id integer, gr_naziv varchar, vz_mesta_sedenje integer, vz_mesta_stajanje integer) AS
$$
DECLARE

BEGIN

  RETURN QUERY
    WITH
      p AS
       (
        SELECT array['Registarska oznaka','Vlasnik','Ime vlasnika','Adresa vlasnika','Marka','Tip','Godina proizvodnje','Model','Homologacijska oznaka','Broj osovina','Broj šasije','Zapremina motora','Broj motora','Masa','Snaga motora','Nosivost','Odnos snaga/masa','Najveća dozvoljena masa','Kategorija','Pogonsko gorivo','Broj mesta za sedenje','Broj mesta za stajanje'] AS al,
               pc_text AS txt
       ),
      txt AS
       (
        SELECT s.s AS lne,
               trim((regexp_split_to_array(s.s, ':')::varchar[])[1]) AS lbl,
               trim((regexp_split_to_array(s.s, ':')::varchar[])[2]) AS val
          FROM p
            CROSS JOIN regexp_split_to_table(p.txt, '[\n]+', 'i') AS s
          WHERE s.s ~ ('^('||array_to_string(p.al, '|', '')||'):.+$')
       ),
      sd AS
       (
        SELECT txt.lne,
               txt.lbl,
               txt.val,
               CASE WHEN txt.lbl=p.al[1] THEN nullif(txt.val, '-') ELSE null END AS vz_reg,
               CASE WHEN txt.lbl=p.al[2] THEN nullif(txt.val, '-') ELSE null END AS kl_naziv,
               CASE WHEN txt.lbl=p.al[3] THEN nullif(txt.val, '-') ELSE null END AS kl_naziv1,
               CASE WHEN txt.lbl=p.al[4] THEN public.f_lat2cir_rn(regexp_replace(rtrim(txt.val, ','), '(,)([^ ])', '\1 \2', 'g')) ELSE null END AS kl_adresa,
               CASE WHEN txt.lbl=p.al[5] THEN nullif(txt.val, '-') ELSE null END AS mr_naziv,
               CASE WHEN txt.lbl=p.al[6] THEN nullif(txt.val, '-') ELSE null END AS vzv_naziv,
               CASE WHEN txt.lbl=p.al[7] THEN CASE WHEN txt.val ~ '[0-9]{4}' THEN to_number(txt.val, '9999') ELSE null END ELSE null END AS vz_godina,
               CASE WHEN txt.lbl=p.al[8] THEN txt.val ELSE null END AS md_naziv_k,
               CASE WHEN txt.lbl=p.al[9] THEN nullif(txt.val, '-') ELSE null END AS vz_sert_hmlg_tip,
               CASE WHEN txt.lbl=p.al[10] THEN CASE WHEN txt.val ~ '[0-9]{4}' THEN to_number(txt.val, '99') ELSE null END ELSE null END AS vz_os_broj,
               CASE WHEN txt.lbl=p.al[11] THEN nullif(txt.val, '-') ELSE null END AS vz_sasija,
               CASE WHEN txt.lbl=p.al[12] THEN CASE WHEN txt.val ~ '[0-9]{2,}[\.]*[0-9]*' THEN to_number(txt.val, '9999999D99') ELSE null END ELSE null END AS vz_cm3,
               CASE WHEN txt.lbl=p.al[13] THEN nullif(txt.val, '-') ELSE null END AS vz_motor,
               CASE WHEN txt.lbl=p.al[14] THEN CASE WHEN txt.val ~ '[0-9]{2,}' THEN to_number(txt.val, '999999') ELSE null END ELSE null END AS vz_masa,
               CASE WHEN txt.lbl=p.al[15] THEN CASE WHEN txt.val ~ '[0-9]{2,}[\.]*[0-9]*' THEN to_number(txt.val, '9999999D99') ELSE null END ELSE null END AS vz_kw,
               CASE WHEN txt.lbl=p.al[16] THEN to_number(txt.val, '999999')::integer ELSE null END AS vz_nosivost,
               CASE WHEN txt.lbl=p.al[17] THEN CASE WHEN txt.val ~ '[0-9]{2,}[\.]*[0-9]*' THEN to_number(txt.val, '9999999D99') ELSE null END ELSE null END AS vz_kw_kg,
               CASE WHEN txt.lbl=p.al[18] THEN CASE WHEN txt.val ~ '[0-9]{2,}' THEN to_number(txt.val, '999999') ELSE null END ELSE null END AS vz_masa_max,
               CASE WHEN txt.lbl=p.al[19] THEN nullif(txt.val, '-') ELSE null END AS vzpv_naziv,
               CASE WHEN txt.lbl=p.al[20] THEN nullif(txt.val, '-') ELSE null END AS gr_naziv,
               CASE WHEN txt.lbl=p.al[21] THEN CASE WHEN txt.val ~ '[0-9]{1,}' THEN to_number(txt.val, '9999') ELSE null END ELSE null END AS vz_mesta_sedenje,
               CASE WHEN txt.lbl=p.al[22] THEN CASE WHEN txt.val ~ '[0-9]{1,}' THEN to_number(txt.val, '9999') ELSE null END ELSE null END AS vz_mesta_stajanje
          FROM txt
            CROSS JOIN p
       ),
      pv AS
       (
        SELECT max(sd.vz_reg) AS vz_reg,
               max(sd.kl_naziv) AS kl_naziv,
               max(sd.kl_naziv1) AS kl_naziv1,
               max(sd.kl_adresa) AS kl_adresa,
               max(sd.mr_naziv) AS mr_naziv,
               max(sd.vzv_naziv) AS vzv_naziv,
               max(sd.vz_godina) AS vz_godina,
               max(sd.md_naziv_k) AS md_naziv_k,
               max(sd.vz_sert_hmlg_tip) AS vz_sert_hmlg_tip,
               max(sd.vz_os_broj) AS vz_os_broj,
               max(sd.vz_sasija) AS vz_sasija,
               max(sd.vz_cm3) AS vz_cm3,
               max(sd.vz_motor) AS vz_motor,
               max(sd.vz_masa) AS vz_masa,
               max(sd.vz_kw) AS vz_kw,
               max(sd.vz_nosivost) AS vz_nosivost,
               max(sd.vz_kw_kg) AS vz_kw_kg,
               max(sd.vz_masa_max) AS vz_masa_max,
               max(sd.vzpv_naziv) AS vzpv_naziv,
               max(sd.gr_naziv) AS gr_naziv,
               max(sd.vz_mesta_sedenje) AS vz_mesta_sedenje,
               max(sd.vz_mesta_stajanje) AS vz_mesta_stajanje
          FROM sd
       )
    SELECT pv.vz_reg::varchar,
           kl.kl_id::integer,
           CASE WHEN nullif(pv.kl_naziv1, '-') IS NOT NULL THEN public.f_lat2cir(regexp_replace(pv.kl_naziv, '^(.+)(IC)$', '\1IĆ', 'g')||' '||pv.kl_naziv1) ELSE pv.kl_naziv END::varchar AS kl_naziv,
           coalesce(kl.kl_adresa, pv.kl_adresa)::varchar AS kl_adresa,
           kl.kl_telefon::varchar,
           CASE WHEN nullif(pv.kl_naziv1, '-') IS NOT NULL THEN 'N' ELSE 'D' END::varchar AS kl_firma,
           mr.mr_id::integer,
           pv.mr_naziv::varchar,
           vzv.vzv_id::integer,
           vzv.vzv_oznaka::varchar,
           pv.vzv_naziv::varchar,
           pv.vz_godina::integer,
           md.md_id::integer,
           pv.md_naziv_k::varchar,
           pv.vz_sert_hmlg_tip::varchar,
           pv.vz_os_broj::integer,
           pv.vz_sasija::varchar,
           pv.vz_cm3::float,
           pv.vz_motor::varchar,
           pv.vz_masa::integer,
           pv.vz_kw::float,
           pv.vz_nosivost::integer,
           pv.vz_kw_kg::float,
           pv.vz_masa_max::integer,
           vzpv.vzpv_id::integer,
           vzpv.vzpv_oznaka::varchar,
           pv.vzpv_naziv::varchar,
           gr.gr_id::integer,
           coalesce(gr.gr_naziv, pv.gr_naziv)::varchar,
           pv.vz_mesta_sedenje::integer,
           pv.vz_mesta_stajanje::integer
      FROM pv
        LEFT JOIN hmlg.klijent kl ON (kl.kl_naziv=pv.kl_naziv)
        LEFT JOIN sif.marka mr ON (mr.mr_naziv=pv.mr_naziv)
        LEFT JOIN sif.model md ON (md.mr_id=mr.mr_id AND md.md_naziv_k=pv.md_naziv_k)
        LEFT JOIN sif.gorivo gr ON (public.f_lat2cir(upper(gr.gr_naziv), 1)=pv.gr_naziv)
        LEFT JOIN sif.vozilo_vrsta vzv ON (public.f_lat2cir(upper(vzv.vzv_naziv), 1)=pv.vzv_naziv)
        LEFT JOIN sif.vozilo_podvrsta vzpv ON (public.f_lat2cir(upper(vzpv.vzpv_naziv), 1)=pv.vzpv_naziv);

EXCEPTION

  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_saobracajna(character varying) OWNER TO postgres;
