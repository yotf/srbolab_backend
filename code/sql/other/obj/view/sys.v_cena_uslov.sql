CREATE OR REPLACE
VIEW sys.v_cena_uslov AS
SELECT cnu.ck_id,
       cnu.cn_id,
       cnu.cnu_id,
       cnu.vzv_id,
       vzv.vzv_oznaka,
       vzv.vzv_naziv,
       cnu.vzpv_id,
       vzpv.vzpv_oznaka,
       vzpv.vzpv_naziv,
       cnu.vzk_id,
       vzk.vzk_oznaka,
       vzk.vzk_naziv,
       cnu.cnu_uslov
  FROM sys.cena_uslov cnu
    LEFT JOIN sif.vozilo_vrsta vzv ON (vzv.vzv_id=cnu.vzv_id)
    LEFT JOIN sif.vozilo_podvrsta vzpv ON (vzpv.vzpv_id=cnu.vzpv_id AND vzpv.vzv_id=vzv.vzv_id)
    LEFT JOIN sif.vozilo_karoserija vzk ON (vzk.vzk_id=cnu.vzk_id);
COMMENT ON VIEW sys.v_cena_uslov IS 'Uslovi važenja cene';
