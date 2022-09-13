DROP FUNCTION IF EXISTS public.f_sr_month(date, integer) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_sr_month(
                           pd_date date,
                           pi_cir integer DEFAULT 0
                          )
  RETURNS character varying AS
$$
DECLARE

  vc_sr_month character varying;

BEGIN

  IF pi_cir=0 THEN
    vc_sr_month := ('{"Januar","Februar","Mart","April","Maj","Jun","Jul","Avgust","Septembar","Oktobar","Novembar","Decembar"}'::text[])[extract(month from pd_date)];
  ELSE
    vc_sr_month := ('{"Јануар","Фебруар","Март","Април","Мај","Јун","Јул","Август","Септембар","Октобар","Новембар","Децембар"}'::text[])[extract(month from pd_date)];
  END IF;

  RETURN vc_sr_month;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION public.f_sr_month(date, integer) OWNER TO postgres;
