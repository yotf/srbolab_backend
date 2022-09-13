DROP FUNCTION IF EXISTS _t.fix_kl_adresa(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.fix_kl_adresa(pc_text text)
  RETURNS text
AS $$
DECLARE

  va_rexp text[][];
  ac_f varchar[];
  ac_t varchar[];
  vi_arrlen integer;
  vc_text varchar;

BEGIN

  va_rexp := array[
                   ['x', '(,)([^ ])', '\1 \2', 'ig'],
                   ['r', '6Х', '6X', 'ig'],
                   ['x', '(ВРТЛАРСКА 59)(.+)', '\1, ЗЕМУН', 'ig'],
                   ['x', '(ПРИЧИНОВИЋ)$', '\1, ШАБАЦ', 'ig'],
                   ['x', '^(КНЕЗА МИХАИЛА 30).*$', '\1, БЕОГРАД', 'ig'],
                   ['x', '^(ДУНАВСКИ|DUNAVSKI)([ ]+)(КЕЈ|KEJ) .*$', 'ДУНАВСКИ КЕЈ 9, БЕОГРАД', 'ig'],
                   ['x', '^(ВЛАДИМИРА ПОПОВИЋА 38-40).*$', '\1, БЕОГРАД', 'ig'],
                   ['x', '(LJUMOVI|SREJOVI|MIHAILOVI|GRULOVI|VASI)(CA)', '\1ĆA', 'ig'],
                   ['x', '(A.[ ]*)(RAJSA)', 'ARČIBALDA \2', 'ig'],
                   ['x', '(Т.[ ]*)(ПАВЛОВ)', 'ТЕОДОРА \2', 'ig'],
                   ['x', '([ ]+)(,)', '\2', 'ig'],
                   ['x', '(,|\.)([^ ])', '\1 \2', 'ig'],
                   ['x', '([0]+)([1-9]+)', '\2', 'ig']
                  ];

  vc_text := _t.fix_str(va_rexp, rtrim(upper(pc_text), ', '));

  ac_f := array['DUSAN', 'KALUDERICA', 'VINCA', 'LESTANE', 'ZIVORAD', 'SABAC', 'SREMCICA', 'CUKARICA', 'ZIVANICEVA', 'MOSTANICA', 'SARCEVICA', 'ЈЕРКОБИ'];
  ac_t := array['DUŠAN', 'KALUĐERICA', 'VINČA', 'LEŠTANE', 'ŽIVORAD', 'ŠABAC', 'SREMČICA', 'ČUKARICA', 'ŽIVANIĆEVA', 'MOŠTANICA', 'ŠARČEVIĆA', 'ЈЕРКОВИ'];
  vi_arrlen := array_length(ac_f, 1);

  FOR vi_idx IN 1..vi_arrlen LOOP
    vc_text := replace(vc_text, ac_f[vi_idx], ac_t[vi_idx]);
  END LOOP;
  IF _t.islat(substring(vc_text, 2)) THEN
    vc_text := _t.lat2cir(vc_text);
  END IF;

  RETURN vc_text;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.fix_kl_adresa(text) OWNER TO postgres;
