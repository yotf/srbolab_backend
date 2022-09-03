DROP TYPE IF EXISTS public.t_fncs CASCADE;
CREATE TYPE public.t_fncs AS
(
  function_schema character varying,
  function_name character varying,
  param_names character varying,
  param_types character varying,
  return_type character varying,
  is_trigger character varying,
  function_body text
);
ALTER TYPE public.t_fncs OWNER TO postgres;
