DROP TYPE IF EXISTS public.t_tbls CASCADE;
CREATE TYPE public.t_tbls AS
(
  table_schema character varying,
  table_name character varying,
  table_type character varying,
  table_comment character varying
);
ALTER TYPE public.t_tbls OWNER TO postgres;
