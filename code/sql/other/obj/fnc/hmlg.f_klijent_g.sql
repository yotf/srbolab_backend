DROP FUNCTION IF EXISTS hmlg.f_klijent_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_klijent_g(
                          pc_rec character varying DEFAULT NULL::character varying
                         )
  RETURNS SETOF hmlg.klijent AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM hmlg.klijent t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::hmlg.klijent, j_rec) r) j
                 WHERE t.kl_id=coalesce(j.kl_id, t.kl_id)
                   AND t.kl_naziv ~* coalesce(j.kl_naziv, '.+')
                   AND t.kl_adresa ~* coalesce(j.kl_adresa, '.+')
                   AND coalesce(t.kl_telefon, '#') ~* coalesce(j.kl_telefon, '.+')
                   AND t.kl_firma ~* coalesce(j.kl_firma, '[DN]')
                 ORDER BY t.kl_id
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_klijent_g(character varying) OWNER TO postgres;
