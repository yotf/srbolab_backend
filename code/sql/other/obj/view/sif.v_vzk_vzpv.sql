CREATE OR REPLACE
VIEW sif.v_vzk_vzpv AS
SELECT tc.vzk_id,
       tc.vzpv_id,
       tp1.vzpv_oznaka,
       tp1.vzpv_naziv
  FROM sif.vzk_vzpv tc
    JOIN sif.vozilo_podvrsta tp1 ON (tp1.vzpv_id=tc.vzpv_id);
COMMENT ON VIEW sif.v_vzk_vzpv IS 'Kategorije vozila za karoseriju';
