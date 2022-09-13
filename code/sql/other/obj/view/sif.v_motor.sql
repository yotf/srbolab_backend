CREATE OR REPLACE
VIEW sif.v_motor AS
SELECT mt.mt_id,
       mt.mto_id,
       mto.mto_oznaka,
       mt.mt_cm3::FLOAT AS mt_cm3,
       mt.mt_kw::FLOAT AS mt_kw,
       mt.mtt_id,
       mtt.mtt_oznaka,
       mtt.mtt_naziv
  FROM sif.motor mt
    JOIN sif.motor_oznaka mto ON (mto.mto_id=mt.mto_id)
    LEFT JOIN sif.motor_tip mtt ON (mtt.mtt_id=mt.mtt_id);
COMMENT ON VIEW sif.v_motor IS 'Motor';
