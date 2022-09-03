CREATE OR REPLACE
VIEW sif.v_vzkl_vzpv AS
SELECT vzklpv.vzkl_id,
       vzklpv.vzpv_id,
       vzpv.vzpv_oznaka,
       vzpv.vzpv_naziv
  FROM sif.vzkl_vzpv vzklpv
    JOIN sif.vozilo_podvrsta vzpv ON (vzpv.vzpv_id=vzklpv.vzpv_id);
COMMENT ON VIEW sif.v_vzkl_vzpv IS 'Kategorije vozila za klasu';
