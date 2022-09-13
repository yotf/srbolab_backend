DROP FUNCTION IF EXISTS public.f_compn(numeric, numeric) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_compn(
                        pn_val1 numeric,
                        pn_val2 numeric
                       )
  RETURNS boolean
AS $$
DECLARE

  vb_cond boolean;
  vb_neq boolean := substring(pn_val2::text, 1, 1)='-';
  vn_val1 numeric := coalesce(pn_val1, 0);
  vn_val2 numeric := abs(coalesce(pn_val2, 0));

BEGIN

  vb_cond := CASE
               WHEN pn_val2 IS NULL THEN true
               WHEN vb_neq THEN vn_val1::varchar NOT LIKE vn_val2::varchar||'%'
               ELSE vn_val1::varchar LIKE vn_val2::varchar||'%'
             END;
--   vb_cond := CASE
--                WHEN pn_val2 IS NULL THEN true
--                WHEN vb_neq THEN vn_val1!=vn_val2
--                ELSE vn_val1=vn_val2
--              END;

  RETURN vb_cond;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION public.f_compn(numeric, numeric) OWNER TO postgres;
