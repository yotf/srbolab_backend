DROP FUNCTION IF EXISTS public.f_json_keys_check(varchar, json) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_json_keys_check(
                                  pc_keys varchar,
                                  pj_json json
                                 )
  RETURNS varchar
AS $$
DECLARE

  vc_keys_missing varchar;

BEGIN

  SELECT string_agg(t.column_name, ', ') AS keys_missing
    INTO vc_keys_missing
    FROM (
          SELECT lower(trim(column_name))::varchar AS column_name
            FROM unnest(string_to_array(pc_keys::varchar, ',', null)::varchar[]) AS column_name
         ) t
    WHERE NOT EXISTS
           (
            SELECT 1
              FROM (
                    SELECT column_name::varchar
                      FROM json_object_keys(pj_json) AS column_name
                   ) j
                WHERE j.column_name=t.column_name
           );

  RETURN vc_keys_missing;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION public.f_json_keys_check(varchar, json) OWNER TO postgres;
