CREATE OR REPLACE
VIEW sif.v_model AS
SELECT mr.mr_id, 
       mr.mr_naziv, 
       md.md_id, 
       md.md_naziv_k 
  FROM sif.marka mr
    JOIN sif.model md ON (md.mr_id=mr.mr_id);
COMMENT ON VIEW sif.v_model IS 'Modeli za marku';
