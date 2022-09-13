DROP FUNCTION IF EXISTS public.f_tbls(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_tbls(
                       pc_table character varying DEFAULT NULL::character varying
                      )
  RETURNS SETOF public.t_tbls AS
$$
DECLARE

  r_rec RECORD;

BEGIN

  FOR r_rec IN SELECT n.nspname::character varying AS table_schema,
                      c.relname::character varying AS table_name,
                      CASE c.relkind WHEN 'r' THEN 't' ELSE 'v' END::character varying AS table_type,
                      d.description::character varying AS table_comment
                 FROM pg_catalog.pg_class AS c
                   LEFT JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace
                   LEFT JOIN pg_catalog.pg_description d ON (d.objoid=c.oid AND d.objsubid=0)
                 WHERE n.nspname !~* '^(information_schema|pg_[ct]|public|_.*)'
                   AND c.relkind IN ('r', 'v')
                   AND (pc_table IS NULL OR (pc_table ~* '^(t|v)$' AND c.relkind=CASE lower(pc_table) WHEN 't' THEN 'r' ELSE 'v' END) OR c.relname=pc_table) LOOP
    RETURN NEXT r_rec;
  END LOOP;

END;
$$ LANGUAGE 'plpgsql';
ALTER FUNCTION public.f_tbls(character varying) OWNER TO postgres;
