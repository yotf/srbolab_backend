DROP FUNCTION IF EXISTS sif.f_v_vzdo_vzv_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_vzdo_vzv_iu(
                             pc_rec character varying
                            )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.v_vzdo_vzv;
  r_old sif.v_vzdo_vzv;

  vb_ins boolean;
  vi_row_count integer := 0;
  vb_ok2updt boolean;

  vc_rec character varying;
  vi_id integer := 0;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.v_vzdo_vzv, j_rec) j;

-- sif.vozilo_vrsta
  IF r_new.vzv_oznaka IS NOT NULL AND r_new.vzv_naziv IS NOT NULL THEN
    SELECT row_to_json(t)::character varying
      INTO vc_rec
      FROM (
            SELECT r_new.vzv_id,
                   r_new.vzv_oznaka,
                   r_new.vzv_naziv
           ) t;
    IF r_new.vzv_id IS NULL THEN
      vi_id := sif.f_vozilo_vrsta_iu(vc_rec);
      r_new.vzdo_id := vi_id;
      vi_row_count := 1;
    ELSE
      vi_row_count := sif.f_vozilo_vrsta_iu(vc_rec);
    END IF;
  END IF;

  SELECT COUNT(*)=0
    INTO vb_ins
    FROM sif.vzdo_vzv t
    WHERE t.vzv_id=r_new.vzv_id
      AND t.vzdo_id=r_new.vzdo_id;

  IF vb_ins THEN
    INSERT INTO sif.vzdo_vzv (vzdo_id, vzv_id)
      VALUES (r_new.vzdo_id, r_new.vzv_id);
    GET DIAGNOSTICS vi_row_count=ROW_COUNT;
  END IF;

  IF vi_row_count>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_row_count;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'vzdov_pk', 'i') IS NOT null THEN
      RAISE unique_violation USING MESSAGE = 'Takva veza vrste vozila i dodatne oznake već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_vzdo_vzv_iu(character varying) OWNER TO postgres;
