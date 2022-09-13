DROP FUNCTION IF EXISTS hmlg.f_r_potvrda_h(INTEGER) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_r_potvrda_h(
                            pi_pr_id INTEGER
                           )
  RETURNS TABLE(h_lbl VARCHAR, h_val VARCHAR) AS
$$
DECLARE

BEGIN

  RETURN QUERY
    WITH
      p AS
       (
        SELECT pi_pr_id AS pr_id
       ),
      po1 AS
       (
        SELECT MAX(pot.pot_broj) AS pot_broj,
               MAX(pot.pot_datum) AS pot_datum
          FROM p
            JOIN hmlg.potvrda pot ON (pot.pr_id=p.pr_id)
       ),
      po2 AS
       (
        SELECT TO_CHAR(COALESCE(MAX(pot.pot_broj::INTEGER), 0)+1, 'FM000000') AS pot_broj,
               CURRENT_DATE AS pot_datum
          FROM hmlg.potvrda pot
       ),
      pr AS
       (
        SELECT pr.pr_broj,
               pr.pr_datum,
               pr.vz_sasija
          FROM p 
            JOIN hmlg.v_predmet pr ON (pr.pr_id=p.pr_id)
       )
    SELECT (tis.tis_desc_sr||':')::VARCHAR AS h_lbl, 
           CASE tis.tis_order
             WHEN 1 THEN COALESCE(po1.pot_broj, po2.pot_broj)
             WHEN 2 THEN TO_CHAR(COALESCE(po1.pot_datum, po2.pot_datum), 'DD.MM.YYYY')
             WHEN 3 THEN pr.vz_sasija
           END::VARCHAR AS h_val
      FROM public.tuv_imp_sert tis
        CROSS JOIN po1
        CROSS JOIN po2
        CROSS JOIN pr
      WHERE tis.tis_part='h'
      ORDER BY tis.tis_order;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_r_potvrda_h(INTEGER) OWNER TO postgres;
