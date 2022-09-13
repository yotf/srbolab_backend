CREATE OR REPLACE
VIEW adm.v_adm_log AS
WITH
  lg AS
   (
    SELECT ROW_NUMBER() OVER (PARTITION BY SUBSTRING(alg.alg_login::varchar, 1, 19) ORDER BY alg.alg_login DESC) AS alg_ord,
           TO_CHAR(alg.alg_login, 'dd.mm.yyyy hh24:mi:ss') AS alg_login,
           kr.kr_username,
           kr.kr_prezime,
           kr.kr_ime,
           alg.alg_ip,
           COALESCE(lk.lk_naziv, 'nepoznata') AS lk_naziv,
           alg_id
      FROM adm.adm_log alg
        JOIN sys.korisnik kr ON (kr.kr_id=alg.kr_id)
        LEFT JOIN sys.lokacija lk ON (lk.lk_ip=alg.alg_ip)
   )
SELECT lg.alg_id,
       lg.alg_login,
       lg.kr_username,
       lg.kr_prezime,
       lg.kr_ime,
       lg.alg_ip,
       lg.lk_naziv
  FROM lg
  WHERE lg.alg_ord=1;
COMMENT ON VIEW adm.v_adm_log IS 'Dnevnik rada';
