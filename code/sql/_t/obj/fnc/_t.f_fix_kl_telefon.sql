DROP FUNCTION IF EXISTS _t.fix_kl_telefon(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.fix_kl_telefon(pc_text text)
  RETURNS text
AS $$
DECLARE

  va_rexp text[][];

BEGIN

  va_rexp := array[
                   ['x', '^([-]+)', '', 'ig']
                  ];

  RETURN _t.fix_str(va_rexp, upper(pc_text));

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.fix_kl_telefon(text) OWNER TO postgres;
