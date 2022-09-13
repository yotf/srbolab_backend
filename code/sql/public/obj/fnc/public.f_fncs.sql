DROP FUNCTION IF EXISTS public.f_fncs(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_fncs(
                       pc_function character varying DEFAULT NULL::character varying
                      )
  RETURNS SETOF public.t_fncs AS
$$
DECLARE

  r_rec record;

BEGIN

  FOR r_rec IN SELECT n.nspname::character varying AS function_schema,
                      p.proname::character varying AS function_name,
                      array_to_string(p.proargnames, ', ', null)::character varying AS param_names,
                      (
                       SELECT max(t2.types) AS types
                         FROM (
                               SELECT string_agg(CASE substr(t1.typname, 1, 1)
                                                   WHEN '_' THEN substr(t1.typname, 2)||'[]'
                                                   ELSE t1.typname
                                                 END, ', ') OVER (ORDER BY t0.p_no) AS types
                                 FROM (
                                       SELECT row_number() OVER () AS p_no,
                                              oid
                                         FROM unnest(string_to_array(p.proargtypes::text, ' ', null)::integer[]) AS oid
                                      ) t0
                                   JOIN pg_catalog.pg_type t1 ON (t1.oid=t0.oid)
                              ) t2
                      )::character varying AS param_types,
                      (
                       SELECT CASE substr(t0.typname, 1, 1)
                                WHEN '_' THEN substr(t0.typname, 2)||'[]'
                                ELSE t0.typname
                              END AS r_type
                         FROM pg_catalog.pg_type t0
                         WHERE t0.oid=p.prorettype
                      )::character varying AS return_type,
                      CASE (
                            SELECT t0.typname
                              FROM pg_catalog.pg_type t0
                              WHERE t0.oid=p.prorettype
                           )
                        WHEN 'trigger' THEN 'y'
                        ELSE 'n'
                      END::character varying AS is_trigger,
                      p.prosrc::text AS function_body
                 FROM pg_catalog.pg_namespace n
                   JOIN pg_catalog.pg_proc p ON (p.pronamespace=n.oid)
                 WHERE n.nspname !~ '^(information_schema|pg_[ct])'
                   AND p.proname=coalesce(pc_function, p.proname) LOOP
    RETURN NEXT r_rec;
  END LOOP;

END;
$$ LANGUAGE 'plpgsql';
ALTER FUNCTION public.f_fncs(character varying) OWNER TO postgres;
