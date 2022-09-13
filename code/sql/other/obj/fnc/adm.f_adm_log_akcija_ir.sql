DROP FUNCTION IF EXISTS adm.f_adm_log_akcija_i(r_rec adm.adm_log_akcija) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_adm_log_akcija_i(
                                pr_rec adm.adm_log_akcija
                               )
  RETURNS integer AS
$$
DECLARE

  vn_res_rc INTEGER;

BEGIN

  pr_rec.ala_vreme := statement_timestamp();
  INSERT INTO adm.adm_log_akcija SELECT pr_rec.*;
  GET DIAGNOSTICS vn_res_rc=ROW_COUNT;

  RETURN vn_res_rc;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_adm_log_akcija_i(r_rec adm.adm_log_akcija) OWNER TO postgres;
