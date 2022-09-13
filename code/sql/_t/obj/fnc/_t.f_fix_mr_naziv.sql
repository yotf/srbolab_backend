DROP FUNCTION IF EXISTS _t.fix_mr_naziv(pc_text text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.fix_mr_naziv(pc_text text)
  RETURNS text
AS $$
DECLARE

  va_rexp text[][];

BEGIN   

  va_rexp := array[
                   ['x', '^MERCEDES.*$', 'MERCEDES-BENZ', 'ig'],
                   ['x', '^M$', 'VOLKSWAGEN, VW', 'ig'],
                   ['x', '^(SCHMITZ)(.*)$', '\1', 'ig']
                  ];

  RETURN _t.fix_str(va_rexp, upper(pc_text));

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.fix_mr_naziv(pc_text text) OWNER TO postgres;
