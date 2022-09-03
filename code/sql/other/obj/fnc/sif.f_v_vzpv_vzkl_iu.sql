DROP FUNCTION IF EXISTS sif.f_v_vzpv_vzkl_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_vzpv_vzkl_iu(
                              pc_rec character varying
                             )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.v_vzpv_vzkl;
  r_old sif.v_vzpv_vzkl;

  vb_ins boolean;
  vi_row_count integer := 0;
  vb_ok2updt boolean;

  vc_rec character varying;
  vi_id integer := 0;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.v_vzpv_vzkl, j_rec) j;

-- sif.vozilo_klasa
  IF r_new.vzkl_oznaka IS NOT NULL AND r_new.vzkl_naziv IS NOT NULL THEN
    SELECT row_to_json(t)::character varying
      INTO vc_rec
      FROM (
            SELECT r_new.vzkl_id,
                   r_new.vzkl_oznaka,
                   r_new.vzkl_naziv
           ) t;
    IF r_new.vzv_id IS NULL THEN
      vi_id := sif.f_vozilo_klasa_iu(vc_rec);
      r_new.vzpv_id := vi_id;
      vi_row_count := 1;
    ELSE
      vi_row_count := sif.f_vozilo_klasa_iu(vc_rec);
    END IF;
  END IF;

  SELECT COUNT(*)=0
    INTO vb_ins
    FROM sif.vzkl_vzpv t
    WHERE t.vzkl_id=r_new.vzkl_id
      AND t.vzpv_id=r_new.vzpv_id;

  IF vb_ins THEN
    INSERT INTO sif.vzkl_vzpv (vzkl_id, vzpv_id)
      VALUES (r_new.vzkl_id, r_new.vzpv_id);
    GET DIAGNOSTICS vi_row_count=ROW_COUNT;
  END IF;

  IF vi_row_count>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_row_count;

EXCEPTION

  WHEN unique_violation THEN
    IF sqlerrm ~* 'vzklpv_pk' THEN
      RAISE unique_violation USING MESSAGE = 'Takva veza klase i kategorije vozila već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_vzpv_vzkl_iu(character varying) OWNER TO postgres;
