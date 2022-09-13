CREATE OR REPLACE
VIEW hmlg.v_vzs_vzdo AS
SELECT tc.vzs_id,
       tc.vzdo_id,
       tp1.vzdo_oznaka,
       tp1.vzdo_naziv
  FROM hmlg.vzs_vzdo tc
    JOIN sif.vozilo_dod_oznaka tp1 ON (tp1.vzdo_id=tc.vzdo_id);
COMMENT ON VIEW hmlg.v_vz_vzdo IS 'Dodatne oznake za vozilo';
