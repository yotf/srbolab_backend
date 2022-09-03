CREATE OR REPLACE
VIEW hmlg.v_predmet_usluga AS
SELECT pru.pr_id,
       pru.us_id,
       us.us_oznaka,
       us.us_naziv
  FROM hmlg.predmet_usluga pru
    JOIN sys.usluga us ON (us.us_id=pru.us_id);
COMMENT ON VIEW hmlg.v_predmet_usluga IS 'Usluge za predmet';
