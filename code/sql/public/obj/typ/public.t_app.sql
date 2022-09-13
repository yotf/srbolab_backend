DROP TYPE IF EXISTS public.t_app CASCADE;
CREATE TYPE public.t_app AS
(
  aap_id integer,
  aap_naziv character varying,
  afo_id integer,
  afo_naziv character varying,
  afo_tabele character varying,
  afo_izvestaji character varying,
  arl_id integer,
  arl_naziv character varying,
  arf_akcije_d character varying,
  afo_dostupna character varying
);
ALTER TYPE public.t_app OWNER TO postgres;
