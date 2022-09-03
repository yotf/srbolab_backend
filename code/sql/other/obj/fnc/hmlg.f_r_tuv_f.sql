DROP FUNCTION IF EXISTS hmlg.f_r_potvrda_f(INTEGER) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_r_potvrda_f(
                            pi_pr_id INTEGER
                           )
  RETURNS TABLE(vz_sert_lbl VARCHAR, vz_sert VARCHAR) AS
$$
DECLARE

BEGIN

  RETURN QUERY
    WITH
      pr AS
       (
        SELECT p.vz_sert_hmlg_tip,
               p.vz_sert_emisija,
               p.vz_sert_buka
          FROM hmlg.v_predmet p
          WHERE p.pr_id=pi_pr_id
       )
    SELECT (tis.tis_desc_sr||':')::VARCHAR AS vz_sert_lbl, 
           COALESCE(CASE tis.tis_order
                      WHEN 1 THEN pr.vz_sert_hmlg_tip
                      WHEN 2 THEN pr.vz_sert_emisija
                      WHEN 3 THEN pr.vz_sert_buka
                    END, '---')::VARCHAR AS vz_sert
      FROM public.tuv_imp_sert tis
        CROSS JOIN pr
      WHERE tis.tis_part='f'
      ORDER BY tis.tis_order;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_r_potvrda_f(INTEGER) OWNER TO postgres;
