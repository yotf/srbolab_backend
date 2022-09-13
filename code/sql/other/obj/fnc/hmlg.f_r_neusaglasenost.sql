DROP FUNCTION IF EXISTS hmlg.f_r_neusaglasenost(integer) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_r_neusaglasenost(
                                 pi_pr_id integer
                                )
  RETURNS TABLE(
                pr_id integer, 
                pr_broj varchar, 
                kl_naziv varchar, 
                kl_adresa varchar, 
                vz_sasija varchar, 
                vz_motor varchar, 
                pr_napomena varchar, 
                pr_primedbe varchar, 
                pr_zakljucak varchar
               ) AS
$$
DECLARE

BEGIN

  RETURN QUERY
    SELECT v.pr_id,
           v.pr_broj,
           v.kl_naziv,
           v.kl_adresa,
           v.vz_sasija,
           coalesce(v.vz_motor, '-') AS vz_motor,
           v.pr_napomena,
           v.pr_primedbe,
           v.pr_zakljucak
      FROM hmlg.v_predmet v
      WHERE v.pr_id=pi_pr_id;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_r_neusaglasenost(integer) OWNER TO postgres;
