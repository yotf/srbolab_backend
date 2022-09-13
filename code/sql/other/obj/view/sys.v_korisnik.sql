CREATE OR REPLACE
VIEW sys.v_korisnik AS
SELECT kr.kr_id,
       kr.kr_prezime,
       kr.kr_ime,
       kr.kr_username,
       kr.kr_password,
       kr.kr_aktivan,
       kr.arl_id,
       arl.arl_naziv
FROM sys.korisnik kr
  LEFT JOIN adm.adm_rola arl ON (arl.arl_id=kr.arl_id);
COMMENT ON VIEW sys.v_korisnik IS 'Korisnici sistema';
