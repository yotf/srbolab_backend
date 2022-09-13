CREATE OR REPLACE
VIEW sys.v_cena AS
SELECT cn.ck_id,
       cn.cn_id,
       cn.cn_cena,
       cn.us_id,
       us.us_naziv
  FROM sys.cena cn
    JOIN usluga us ON (us.us_id=cn.us_id);
COMMENT ON VIEW sys.v_cena IS 'Cene usluga';
