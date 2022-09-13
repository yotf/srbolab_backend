DROP FUNCTION IF EXISTS public.f_compd(text, text, text) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_compd(
                        pc_date1 text,
                        pc_date2 text,
                        pc_date3 text DEFAULT null::varchar
                       )
  RETURNS boolean
AS $$
DECLARE

  vb_cond boolean;

BEGIN

  vb_cond := CASE
               WHEN pc_date2::date IS NOT NULL THEN
                 CASE
                   WHEN pc_date3::date IS NOT NULL THEN
                     pc_date1::date>=pc_date2::date AND pc_date1::date<=pc_date3::date
                   ELSE
                     pc_date1::date=pc_date2::date
                 END
               ELSE
                 true
             END;

  RETURN vb_cond;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION public.f_compd(text, text, text) OWNER TO postgres;
