CREATE OR REPLACE
VIEW adm.v_adm_forma AS
SELECT afo.aap_id,
       aap.aap_naziv,
       afo.afo_id,
       afo.afo_naziv
  FROM adm.adm_forma afo
    JOIN adm.adm_aplikacija aap ON (aap.aap_id=afo.aap_id);
COMMENT ON VIEW adm.v_adm_forma IS 'Forme';
