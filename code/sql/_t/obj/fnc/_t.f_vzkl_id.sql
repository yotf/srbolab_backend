DROP FUNCTION IF EXISTS _t.vzkl_id(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.vzkl_id(
                    pc_text text
                   )
  RETURNS integer
AS $$
DECLARE

  vi_vzkl_id integer;

BEGIN

  SELECT vzkl.vzkl_id
    INTO vi_vzkl_id
    FROM (
          SELECT unnest(string_to_array(pc_text::text, '/', '')::varchar[]) AS kdo
         ) s
      JOIN sif.vozilo_klasa vzkl ON (vzkl.vzkl_naziv=s.kdo)
    WHERE s.kdo !~* '([A-Z]|[0-9]){2}';

  RETURN vi_vzkl_id;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.vzkl_id(text) OWNER TO postgres;
