CREATE OR REPLACE
VIEW hmlg.v_pr_vzd AS
SELECT prd.pr_id,
       prd.vzd_id,
       vzd.vzd_oznaka,
       vzd.vzd_naziv
  FROM hmlg.pr_vzd prd
    JOIN sif.vozilo_dokument vzd ON (vzd.vzd_id=prd.vzd_id);
COMMENT ON VIEW hmlg.v_pr_vzd IS 'Dokumenta za vozilo za predmet';
