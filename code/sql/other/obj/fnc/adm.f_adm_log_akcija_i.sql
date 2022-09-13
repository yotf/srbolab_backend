DROP FUNCTION IF EXISTS adm.f_adm_log_akcija_i(varchar, varchar, text, text, integer) CASCADE;
CREATE OR REPLACE
FUNCTION adm.f_adm_log_akcija_i(
                                pc_ala_tabela varchar,
                                pc_ala_akcija varchar,
                                pc_ala_red_old text,
                                pc_ala_red_new text,
                                pi_kr_id integer
                               )
  RETURNS integer AS
$$
DECLARE

  vn_res_rc INTEGER;

BEGIN

   INSERT INTO adm.adm_log_akcija (ala_vreme, ala_tabela, ala_akcija, ala_red_old, ala_red_new, kr_id)
    VALUES(statement_timestamp(), pc_ala_tabela, pc_ala_akcija, pc_ala_red_old, pc_ala_red_new, pi_kr_id);
  GET DIAGNOSTICS vn_res_rc=ROW_COUNT;

  RETURN vn_res_rc;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION adm.f_adm_log_akcija_i(varchar, varchar, text, text, integer) OWNER TO postgres;
