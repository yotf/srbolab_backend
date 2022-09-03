CREATE OR REPLACE
VIEW sif.v_agp_agh AS
SELECT agph.agp_id,
       agu.agu_id,
       agu.agu_oznaka,
       agu.agu_naziv,
       agph.agh_id,
       agh.agh_oznaka
  FROM sif.agp_agh agph
    JOIN sif.ag_homologacija agh ON (agh.agh_id=agph.agh_id)
    JOIN sif.ag_uredjaj agu ON (agu.agu_id=agh.agu_id);
COMMENT ON VIEW sif.v_agp_agh IS 'Homologacije za proizvođača';
