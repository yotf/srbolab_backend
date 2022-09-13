DROP FUNCTION IF EXISTS public.f_lat2cir(text, integer) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_lat2cir(
                           pc_text text,
                           pi_2cir integer DEFAULT 0
                          )
  RETURNS text
AS $$
DECLARE

  ac_lat text[];
  ac_cir text[];
  vc_text text;
  vi_arrlen integer;

BEGIN

  vc_text := pc_text;
  IF vc_text IS NOT NULL THEN
    ac_lat := array['DJ', 'LJ', 'NJ', 'DŽ', 'dj', 'lj', 'nj', 'dž', 'Dj', 'Lj', 'Nj', 'Dž', 'dJ', 'lJ', 'nJ', 'dŽ', 'A', 'B', 'V', 'G', 'D', 'Đ', 'E', 'Ž', 'Z', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'R', 'S', 'T', 'Ć', 'U', 'F', 'H', 'C', 'Č', 'Š', 'a', 'b', 'v', 'g', 'd', 'đ', 'e', 'ž', 'z', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'ć', 'u', 'f', 'h', 'c', 'č', 'š'];
    ac_cir := array['Ђ', 'Љ', 'Њ', 'Џ', 'ђ', 'љ', 'њ', 'џ', 'Ђ', 'Љ', 'Њ', 'Џ', 'ђ', 'љ', 'њ', 'џ', 'А', 'Б', 'В', 'Г', 'Д', 'Ђ', 'Е', 'Ж', 'З', 'И', 'Ј', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'Ћ', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'а', 'б', 'в', 'г', 'д', 'ђ', 'е', 'ж', 'з', 'и', 'ј', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'ћ', 'у', 'ф', 'х', 'ц', 'ч', 'ш'];
    vi_arrlen := array_length(ac_lat, 1);
    IF coalesce(pi_2cir, 0)=0 THEN
      FOR vi_idx IN 1..vi_arrlen LOOP
        vc_text := replace(vc_text, ac_lat[vi_idx], ac_cir[vi_idx]);
      END LOOP;
    ELSE
      FOR vi_idx IN 1..vi_arrlen LOOP
        vc_text := replace(vc_text, ac_cir[vi_idx], ac_lat[vi_idx]);
      END LOOP;
    END IF;
  END IF;

  RETURN vc_text;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION public.f_lat2cir(text, integer) OWNER TO postgres;
