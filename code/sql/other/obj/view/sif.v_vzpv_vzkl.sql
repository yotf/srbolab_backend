CREATE OR REPLACE
VIEW sif.v_vzpv_vzkl AS
SELECT vzklpv.vzpv_id,
       vzklpv.vzkl_id,
       vzkl.vzkl_oznaka,
       vzkl.vzkl_naziv
  FROM sif.vzkl_vzpv vzklpv
    JOIN sif.vozilo_klasa vzkl ON (vzkl.vzkl_id=vzklpv.vzkl_id);
COMMENT ON VIEW sif.v_vzpv_vzkl IS 'Klase za kategoriju vozila';
