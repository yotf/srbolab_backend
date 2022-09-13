DROP FUNCTION IF EXISTS sys.f_r_lokacija(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_r_lokacija(
                          pc_lk_aktivna varchar
                         )
  RETURNS TABLE(lk_id integer, lk_naziv varchar, lk_naziv_l varchar, lk_ip varchar, lk_aktivna varchar) AS
$$
DECLARE

  vc_res character varying;

BEGIN

  RETURN QUERY
    SELECT t.lk_id,
           t.lk_naziv,
           t.lk_naziv_l,
           t.lk_ip,
           (t.lk_aktivna||CASE t.lk_aktivna WHEN 'D' THEN 'a' ELSE 'e' END)::varchar AS lk_aktivna
      FROM sys.lokacija t
      WHERE (nullif(pc_lk_aktivna, '') IS NULL OR t.lk_aktivna=upper(substr(pc_lk_aktivna, 1, 1)))
      ORDER BY t.lk_id;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_r_lokacija(varchar) OWNER TO postgres;
