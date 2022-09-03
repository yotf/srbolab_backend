DROP FUNCTION IF EXISTS public.f_firma(integer) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_firma(
                        pi_fir_id integer
                       )
  RETURNS SETOF public.sys_firma AS
$$
DECLARE

  r_rec RECORD;

BEGIN

  FOR r_rec IN SELECT fir.fir_id,
                      fir.fir_naziv,
                      fir.fir_naziv_s,
                      fir.fir_opis,
                      fir.fir_opis_s,
                      fir.fir_mesto_sediste,
                      fir.fir_adresa_sediste,
                      fir.fir_mesto,
                      fir.fir_adresa,
                      fir.fir_tel1,
                      fir.fir_tel2,
                      fir.fir_mail,
                      fir.fir_web,
                      fir.fir_logo,
                      fir.fir_pib,
                      fir.fir_mbr,
                      fir.fir_banka,
                      fir.fir_ziro_rac,
                      fir.sr_cir
                 FROM public.sys_firma fir
                 WHERE fir.fir_id=pi_fir_id LOOP
    RETURN NEXT r_rec;
  END LOOP;

END;
$$ LANGUAGE 'plpgsql';
ALTER FUNCTION public.f_firma(integer) OWNER TO postgres;
