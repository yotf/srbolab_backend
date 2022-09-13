DROP FUNCTION IF EXISTS _t.fix_vzo_pneumatik(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.fix_vzo_pneumatik(pc_text text)
  RETURNS text
AS $$
DECLARE

  va_rexp text[][];

BEGIN

  va_rexp := array[
                   ['x', '([ ]{1,})(R|Z)', '\2', 'ig'],
                   ['x', '^(195|205|215)(/)(50|55|65)(R1)$', '\1\2\3\46', 'ig'],
                   ['r', '/*', '/', 'ig'],
                   ['r', '.', ',', 'ig'],
                   ['r', 'R158', 'R15', 'ig'],
                   ['r', 'RZR', 'ZR', 'ig'],
                   ['r', '225/50R17225/45R1', '225/50R17', 'ig']
                  ];

  RETURN _t.fix_str(va_rexp, upper(pc_text));

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.fix_vzo_pneumatik(text) OWNER TO postgres;
