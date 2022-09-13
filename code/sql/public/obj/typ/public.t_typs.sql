DROP TYPE IF EXISTS public.t_typs CASCADE;
CREATE TYPE public.t_typs AS
(
  type_schema character varying,
  type_name character varying
);
ALTER TYPE public.t_typs OWNER TO postgres;
