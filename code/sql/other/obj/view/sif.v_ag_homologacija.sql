CREATE OR REPLACE
VIEW sif.v_ag_homologacija AS
SELECT agh.agh_id,
       agh.agh_oznaka,
       agh.agu_id,
       agu.agu_oznaka,
       agu.agu_naziv
  FROM sif.ag_homologacija agh
    JOIN sif.ag_uredjaj agu ON (agu.agu_id=agh.agu_id);
COMMENT ON VIEW sif.v_ag_homologacija IS 'Homologacije za uređaj';
