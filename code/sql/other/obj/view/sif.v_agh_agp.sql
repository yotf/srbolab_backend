CREATE OR REPLACE
VIEW sif.v_agh_agp AS
SELECT agph.agh_id,
       agph.agp_id,
       agp.agp_naziv,
       agp.agp_napomena
  FROM sif.agp_agh agph
    JOIN sif.ag_proizvodjac agp ON (agp.agp_id=agph.agp_id);
COMMENT ON VIEW sif.v_agh_agp IS 'Proizvođači za homologaciju';
