CREATE OR REPLACE
VIEW sif.v_vzv_vzdo AS
SELECT tc.vzv_id,
       tc.vzdo_id,
       tp1.vzdo_oznaka,
       tp1.vzdo_naziv
  FROM sif.vzdo_vzv tc
    JOIN sif.vozilo_dod_oznaka tp1 ON (tp1.vzdo_id=tc.vzdo_id);
COMMENT ON VIEW sif.v_vzv_vzdo IS 'Dodatne oznake za vrstu vozila';
