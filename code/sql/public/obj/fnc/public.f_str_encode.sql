DROP FUNCTION IF EXISTS public.f_str_encode(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_str_encode(
                             pc_string varchar
                            )
  RETURNS character varying AS
$$
DECLARE

BEGIN

  RETURN encode(sha256(pc_string::bytea), 'hex');

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION public.f_str_encode(varchar) OWNER TO postgres;
