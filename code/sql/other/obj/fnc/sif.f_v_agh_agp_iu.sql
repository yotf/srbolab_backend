DROP FUNCTION IF EXISTS sif.f_v_agh_agp_iu(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_agh_agp_iu(
                            pc_rec character varying
                           )
  RETURNS integer AS
$$
DECLARE

  j_rec json := pc_rec::json;
  r_new sif.v_agh_agp;
  r_old sif.v_agh_agp;

  vb_ins boolean;
  vi_row_count integer := 0;
  vb_ok2updt boolean;

  vc_rec character varying;
  vi_id integer := 0;

BEGIN

  SELECT j.*
    INTO r_new
    FROM json_populate_record(null::sif.v_agh_agp, j_rec) j;

-- sif.ag_proizvodjac
  IF r_t.agp_oznaka IS NOT NULL THEN
    SELECT row_to_json(t)::character varying
      INTO vc_rec
      FROM (
            SELECT r_new.agp_id,
                   r_new.agp_oznaka,
                   r_new.agp_napomena
           ) t;
    IF r_new.agh_id IS NULL THEN
      vi_id := sif.f_ag_proizvodjac_iu(vc_rec);
      r_new.agp_id := vi_id;
      vi_row_count := 1;
    ELSE
      vi_row_count := sif.f_ag_proizvodjac_iu(vc_rec);
    END IF;
  END IF;

  SELECT COUNT(*)=0
    INTO vb_ins
    FROM sif.agp_agh t
    WHERE t.agp_id=r_new.agp_id
      AND t.agh_id=r_new.agh_id;

  IF vb_ins THEN
    INSERT INTO sif.agp_agh (agp_id, agh_id)
      VALUES (r_new.agp_id, r_new.agh_id);
    GET DIAGNOSTICS vi_row_count=ROW_COUNT;
  END IF;

  IF vi_row_count>0 THEN
    RAISE INFO 'Red je uspešno %.', CASE WHEN vb_ins THEN 'dodat' ELSE 'izmenjen' END;
  END IF;

  RETURN vi_row_count;

EXCEPTION

  WHEN unique_violation THEN
    IF regexp_match(sqlerrm, 'agph_pk', 'i') IS NOT null THEN
      RAISE unique_violation USING MESSAGE = 'Takva veza proizvođača gasnih uređaja i homologacije već postoji!';
    ELSE
      RAISE EXCEPTION 'Nemamo pojma šta se dešava % %!', sqlerrm, sqlstate;
    END IF;
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_agh_agp_iu(character varying) OWNER TO postgres;
