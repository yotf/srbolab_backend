DROP FUNCTION IF EXISTS _t.iscir(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.iscir(
                  pc_text text
                 )
  RETURNS boolean
AS $$
DECLARE

BEGIN

  RETURN regexp_match(pc_text, '^[^A-ZŠĐČĆŽ]+$', 'i') IS NOT NULL;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.iscir(text) OWNER TO postgres;
