DROP FUNCTION IF EXISTS _t.fix_mdt_oznaka(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.fix_mdt_oznaka(pc_text text)
  RETURNS text
AS $$
DECLARE

  va_rexp text[][];

BEGIN

  va_rexp := array[
                   ['x', '([ ]+)(MONOCAB)', '/\2', 'ig'],
                   ['x', '([^/])(MONOCAB)', '\1/\2', 'ig'],
                   ['x', '^AHM0N0CAB$', 'A-H/MONOCAB', 'ig'],
                   ['x', '^ULK-C/X$', 'UKL-C/X', 'ig'],
                   ['x', '^COMBOC-VAN$', 'COMBO-C-VAN', 'ig'],
                   ['x', '^(204|245)(X|G)$', '\1 \2', 'ig'],
                   ['x', '^(2|P|S)([\*]{4,6})$', '\1*****', 'ig'],
                   ['x', '^(MONOCAB)( B)$', '\1', 'ig'],
                   ['x', '^(A-H)$', '\1/MONOCAB', 'ig']
                  ];

  RETURN _t.fix_str(va_rexp, upper(pc_text));

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.fix_mdt_oznaka(text) OWNER TO postgres;
