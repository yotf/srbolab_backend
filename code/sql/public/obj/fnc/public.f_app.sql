DROP FUNCTION IF EXISTS public.f_app(integer) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_app(
                      pi_kr_id integer
                     )
  RETURNS SETOF public.t_app AS
$$
DECLARE

  r_rec record;

BEGIN

  FOR r_rec IN SELECT aap.aap_id,
                      aap.aap_naziv,
                      afo.afo_id,
                      afo.afo_naziv,
                      CASE WHEN afo.afo_tabele ~ '\{.*\}' THEN afo.afo_tabele ELSE '{}' END::varchar AS afo_tabele,
                      CASE WHEN afo.afo_izvestaji ~ '\{.*\}' THEN afo.afo_izvestaji ELSE '{}' END::varchar AS afo_izvestaji,
                      arl.arl_id,
                      arl.arl_naziv,
                      arf.arf_akcije_d::varchar,
                      CASE WHEN afo.afo_tabele ~ '\{.*\}' AND nullif(arf.arf_akcije_d, '{}') IS NOT NULL THEN 'y' ELSE 'n' END::varchar AS afo_dostupna
                 FROM adm.adm_aplikacija aap
                   JOIN adm.adm_forma afo ON (afo.aap_id=aap.aap_id)
                   JOIN (
                         SELECT 0 AS arl_id,
                                afo.afo_id,
                                CASE WHEN afo.afo_tabele ~ '\{.+\}' THEN format('{"actions": %s}', json_extract_path_text(nullif(afo.afo_tabele, '*')::json, 'actions')::varchar) ELSE NULL END AS arf_akcije_d
                           FROM adm.adm_forma afo
                         UNION ALL
                         SELECT kr.arl_id,
                                afo.afo_id,
                                coalesce(arf.arf_akcije_d, '{}') AS arf_akcije_d
                           FROM adm.adm_forma afo
                             CROSS JOIN sys.korisnik kr
                             LEFT JOIN adm.arl_afo arf ON (arf.afo_id=afo.afo_id AND arf.arl_id=kr.arl_id)
                           WHERE kr.kr_id=pi_kr_id
                             AND kr.arl_id<>0
                        ) arf ON (arf.afo_id=afo.afo_id)
                   JOIN adm.adm_rola arl ON (arl.arl_id=arf.arl_id)
                   JOIN sys.korisnik kr ON (kr.arl_id=arf.arl_id)
                 WHERE (kr.kr_id=pi_kr_id)
                 ORDER BY aap.aap_id, afo.afo_id LOOP
    RETURN NEXT r_rec;
  END LOOP;

END;
$$ LANGUAGE 'plpgsql';
ALTER FUNCTION public.f_app(integer) OWNER TO postgres;
