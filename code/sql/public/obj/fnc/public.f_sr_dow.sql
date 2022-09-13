DROP FUNCTION IF EXISTS public.f_sr_dow(date, integer) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_sr_dow(
                         pd_date date,
                         pi_cir integer DEFAULT 0
                        )
  RETURNS character varying AS
$$
DECLARE

  vc_sr_dow character varying;

BEGIN

  IF pi_cir=0 THEN
    vc_sr_dow := ('{"Ponedeljak","Utorak","Sreda","Četvrtak","Petak","Subota","Nedelja"}'::text[])[extract(isodow from pd_date)];
  ELSE
    vc_sr_dow := ('{"Понедељак","Уторак","Среда","Четвртак","Петак","Субота","Недеља"}'::text[])[extract(isodow from pd_date)];
  END IF;

  RETURN vc_sr_dow;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION public.f_sr_dow(date, integer) OWNER TO postgres;
