CREATE OR REPLACE
VIEW sys.v_raspored AS
SELECT to_char(kn.kn_datum, 'dd.mm.yyyy') AS kn_datum,
       rs.lk_id,
       lk.lk_naziv,
       kr.kr_id,
       kr.kr_prezime,
       kr.kr_ime,
       rs.rs_napomena
  FROM sys.kalendar kn
    JOIN sys.raspored rs ON (kn.kn_datum=rs.kn_datum)
    JOIN sys.korisnik kr ON (kr.kr_id=rs.kr_id)
    JOIN sys.lokacija lk ON (lk.lk_id=rs.lk_id);
COMMENT ON VIEW sys.v_raspored IS 'Raspored rada po lokacijama';
