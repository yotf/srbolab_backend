DROP FUNCTION IF EXISTS public.f_str4re(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_str4re(
                         pc_text varchar
                        )
  RETURNS varchar
AS $$   
DECLARE

  ac_f varchar[];
  ac_t varchar[];
  vi_arrlen integer;
  vc_text varchar;

BEGIN

  ac_f := array['\', '*', '.', '(', ')', '[', ']'];
  ac_t := array['\\', '\*', '\.', '\(', '\)', '\[', '\]'];
  vi_arrlen := array_length(ac_f, 1);
  vc_text := rtrim(pc_text);
  FOR vi_idx IN 1..vi_arrlen LOOP
    vc_text := replace(vc_text, ac_f[vi_idx], ac_t[vi_idx]);
  END LOOP;

  RETURN vc_text;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION public.f_str4re(varchar) OWNER TO postgres;
