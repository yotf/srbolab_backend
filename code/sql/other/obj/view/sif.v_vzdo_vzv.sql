CREATE OR REPLACE
VIEW sif.v_vzdo_vzv AS
SELECT vzdov.vzdo_id,
       vzdov.vzv_id,
       vzv.vzv_oznaka,
       vzv.vzv_naziv
  FROM sif.vzdo_vzv vzdov
    JOIN sif.vozilo_vrsta vzv ON (vzv.vzv_id=vzdov.vzv_id);
COMMENT ON VIEW sif.v_vzdo_vzv IS 'Vrste vozila za dodatnu oznaku';
