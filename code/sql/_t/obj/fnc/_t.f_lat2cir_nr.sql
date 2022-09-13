DROP FUNCTION IF EXISTS _t.lat2cir_rn(text, integer) CASCADE;
CREATE OR REPLACE
FUNCTION _t.lat2cir_rn(
                       pc_text text,
                       pi_2cir integer DEFAULT 0
                      )
  RETURNS text
AS $$
DECLARE

  vc_text text;
  vc_re varchar := 'M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})';

BEGIN

  vc_text := pc_text;
  IF vc_text IS NOT NULL THEN
    IF coalesce(pi_2cir, 0)=0 THEN
      IF regexp_match(vc_text, '(?<=[, ])'||vc_re||'(?=$)', 'i') IS NOT NULL
        OR regexp_match(vc_text, '(?<=^)'||vc_re||'(?=[, ])', 'i') IS NOT NULL
        OR regexp_match(vc_text, '(?<=[, ])'||vc_re||'(?=[, ])', 'i') IS NOT NULL THEN
        SELECT string_agg(t.s, ' ') AS s
          INTO vc_text
          FROM (
                SELECT CASE
                         WHEN regexp_match(s.s, '(?<=(^|,))'||vc_re||'(?=($|,))', 'i') IS NOT NULL THEN
                           s.s
                         ELSE
                           public.f_lat2cir(s.s)
                       END AS s
                  FROM regexp_split_to_table(vc_text, '[ ]+', 'i') AS s
               ) t;
      ELSE
        vc_text := public.f_lat2cir(vc_text, pi_2cir);
      END IF;
    ELSE
      vc_text := public.f_lat2cir(vc_text, pi_2cir);
    END IF;
  END IF;

  RETURN vc_text;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.lat2cir_rn(text, integer) OWNER TO postgres;
