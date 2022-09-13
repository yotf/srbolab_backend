CREATE OR REPLACE
VIEW hmlg.v_potvrda AS
SELECT pot.pot_id,
       pot.pot_broj,
       pot.pot_datum,
       pot.pot_vreme,
       pot.pr_id,
       pr.pr_broj,
       pot.lk_id,
       lk.lk_naziv,
       pot.kr_id,
       kr.kr_prezime,
       kr.kr_ime,
       kr.kr_username
  FROM hmlg.potvrda pot
    JOIN hmlg.predmet pr ON (pr.pr_id=pot.pr_id)
    JOIN sys.korisnik kr ON (kr.kr_id=pot.kr_id)
    LEFT JOIN sys.lokacija lk ON (lk.lk_id=pot.lk_id);
COMMENT ON VIEW hmlg.v_potvrda IS 'Potvrde o tehničkim karakteristikama vozila';
