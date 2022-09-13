CREATE OR REPLACE
VIEW sif.v_vzpv_vzk AS
SELECT tc.vzpv_id,
       tc.vzk_id,
       tp1.vzk_oznaka,
       tp1.vzk_naziv
  FROM sif.vzk_vzpv tc
    JOIN sif.vozilo_karoserija tp1 ON (tp1.vzk_id=tc.vzk_id);
COMMENT ON VIEW sif.v_vzpv_vzk IS 'Karoserije za kategoriju vozila';
