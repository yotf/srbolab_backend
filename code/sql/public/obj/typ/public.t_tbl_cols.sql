DROP TYPE IF EXISTS public.t_tbl_cols CASCADE;
CREATE TYPE public.t_tbl_cols AS
(
  table_schema character varying,
  table_name character varying,
  column_order integer,
  column_name character varying,
  column_type character varying,
  column_length integer,
  column_dec integer,
  column_is_nn character varying,
  column_default character varying,
  column_check character varying,
  column_is_pk character varying,
  column_is_fk character varying,
  table_schema_p character varying,
  table_name_p character varying,
  column_name_p character varying,
  column_comment character varying
);
ALTER TYPE public.t_tbl_cols OWNER TO postgres;
