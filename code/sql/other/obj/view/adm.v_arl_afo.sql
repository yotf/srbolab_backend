CREATE OR REPLACE
VIEW adm.v_arl_afo AS
SELECT arf.arl_id,
       afo.aap_id,
       aap.aap_naziv,
       afo.afo_id,
       afo.afo_naziv,
       arf.arf_akcije_d
  FROM adm.arl_afo arf
    JOIN adm.adm_forma afo ON (afo.afo_id=arf.afo_id)
    JOIN adm.adm_aplikacija aap ON (aap.aap_id=afo.aap_id);
COMMENT ON VIEW adm.v_arl_afo IS 'Forme za rolu';
