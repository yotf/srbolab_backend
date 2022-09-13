DROP FUNCTION IF EXISTS _t.fix_md_naziv(text, text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.fix_md_naziv(
                     pc_text text,
                     pc_text1 text
                    )
  RETURNS text
AS $$
DECLARE

  va_rexp text[][];

BEGIN

  va_rexp := array[
                   ['x', '^'||upper(pc_text1)||' ', '', 'ig'],
                   ['x', '^(ALFA|CHEVROLET) ', '', 'ig'],
                   ['r', '-G-', ' ', 'ig']
                  ];

  RETURN _t.fix_str(va_rexp, upper(pc_text));

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.fix_md_naziv(text, text) OWNER TO postgres;
