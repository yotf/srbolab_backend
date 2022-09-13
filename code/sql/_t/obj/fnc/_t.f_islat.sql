DROP FUNCTION IF EXISTS _t.islat(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.islat(
                  pc_text text
                 )
  RETURNS boolean
AS $$
DECLARE

BEGIN

  RETURN regexp_match(pc_text, '^[^АБВГДЂЕЖЗИЈКЛЉМНЊОПРСТЋУФХЦЧЏШ]+$', 'i') IS NOT NULL;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.islat(text) OWNER TO postgres;
