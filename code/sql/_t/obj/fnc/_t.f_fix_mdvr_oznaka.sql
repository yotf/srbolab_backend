DROP FUNCTION IF EXISTS _t.fix_mdvr_oznaka(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.fix_mdvr_oznaka(pc_text text)
  RETURNS text
AS $$
DECLARE

  va_rexp text[][];

BEGIN

  va_rexp := array[
                   ['x', '^(MONOCAB)$', 'BE11', 'ig']
                  ];

  RETURN _t.fix_str(va_rexp, upper(pc_text));

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.fix_mdvr_oznaka(text) OWNER TO postgres;
