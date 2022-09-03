CREATE OR REPLACE
VIEW hmlg.v_vz_vzk AS
SELECT tc.vz_id,
       tc.vzk_id,
       tp1.vzk_oznaka,
       tp1.vzk_naziv
  FROM hmlg.vz_vzk tc
    JOIN sif.vozilo_karoserija tp1 ON (tp1.vzk_id=tc.vzk_id);
COMMENT ON VIEW hmlg.v_vz_vzk IS 'Karoserije za vozilo';
