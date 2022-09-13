DROP FUNCTION IF EXISTS sys.f_r_raspored(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION sys.f_r_raspored(
                          pc_kn_datum varchar
                         )
  RETURNS TABLE(kn_datum varchar, kn_dan varchar, lk_id integer, lk_naziv_d varchar, lk_naziv varchar, kr_id integer, kr_prezime varchar, kr_ime varchar, rs_napomena varchar) AS
$$
DECLARE

  vc_res character varying;

BEGIN

  RETURN QUERY
    SELECT kn.kn_datum::varchar,
           public.f_lat2cir(kn.kn_dan)::varchar AS kn_dan,
           rs.lk_id,
           CASE
             WHEN lag(rs.lk_naziv) OVER (PARTITION BY rs.lk_id ORDER BY rs.lk_id, rs.kr_prezime, rs.kr_ime)=rs.lk_naziv THEN
               ''
             ELSE
               rs.lk_naziv
           END::varchar AS lk_naziv_d,
           rs.lk_naziv,
           rs.kr_id,
           rs.kr_prezime,
           rs.kr_ime,
           rs.rs_napomena
      FROM sys.v_kalendar kn
        JOIN sys.v_raspored rs ON (rs.kn_datum::date=kn.kn_datum::date)
      WHERE kn.kn_datum::date=pc_kn_datum::date
      ORDER BY rs.lk_id, rs.kr_prezime, rs.kr_ime;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sys.f_r_raspored(varchar) OWNER TO postgres;
