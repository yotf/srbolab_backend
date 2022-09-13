DROP FUNCTION IF EXISTS public.f_typs(character varying, character varying) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_typs(
                       pc_schema character varying DEFAULT NULL::character varying,
                       pc_type character varying DEFAULT NULL::character varying
                      )
  RETURNS SETOF public.t_typs AS
$$
DECLARE

  r_rec RECORD;

BEGIN

  FOR r_rec IN SELECT n.nspname AS schema_name,
                      t.typname AS type_name
                 FROM pg_type t
                   LEFT JOIN pg_catalog.pg_namespace n ON (n.oid=t.typnamespace)
                   LEFT JOIN pg_catalog.pg_class c ON (c.oid=t.typrelid)
                 WHERE (t.typrelid=0 OR coalesce(c.relkind, '*')='c')
                   AND NOT EXISTS
                         (
                          SELECT 1
                            FROM pg_catalog.pg_type el
                            WHERE el.oid=t.typelem
                              AND el.typarray=t.oid
                         )
                   AND n.nspname !~ '^(information_schema|pg_[ct]|_.*)'
                   AND n.nspname=COALESCE(pc_schema, n.nspname)
                   AND t.typname=COALESCE(pc_type, t.typname) LOOP
    RETURN NEXT r_rec;
  END LOOP;

END;
$$ LANGUAGE 'plpgsql';
ALTER FUNCTION public.f_typs(character varying, character varying) OWNER TO postgres;
