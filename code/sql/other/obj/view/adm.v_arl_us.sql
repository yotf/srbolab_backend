CREATE OR REPLACE
VIEW sys.v_arl_us AS
SELECT arlus.arl_id,
       us.us_id,
       us.us_naziv
  FROM sys.arl_us arlus
    JOIN sys.usluga us ON (us.us_id=arlus.us_id);
COMMENT ON VIEW sys.v_arl_us IS 'Usluge za rolu';
