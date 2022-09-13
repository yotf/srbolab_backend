DROP FUNCTION IF EXISTS _t.fix_str(text[], text, text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.fix_str(pa_rexp text[], pc_text text, pc_null text DEFAULT NULL::text)
  RETURNS text
AS $$
DECLARE

  vc_text text;
  vn_arrlen integer;

BEGIN

  vc_text := coalesce(upper(pc_text), pc_null);
  IF vc_text IS NOT NULL THEN
    vn_arrlen := array_length(pa_rexp, 1);
    FOR vn_idx IN 1..vn_arrlen LOOP
      CASE pa_rexp[vn_idx][1]
        WHEN 'x' THEN
          IF vc_text ~* (pa_rexp[vn_idx][2]) THEN
            vc_text := regexp_replace(vc_text, pa_rexp[vn_idx][2], pa_rexp[vn_idx][3], pa_rexp[vn_idx][4]);
          END IF;
        WHEN 'r' THEN
          IF position(pa_rexp[vn_idx][2] IN vc_text)>0 THEN
            vc_text := replace(vc_text, pa_rexp[vn_idx][2], pa_rexp[vn_idx][3]);
          END IF;
        ELSE
          NULL;
      END CASE;
    END LOOP;
    vc_text := nullif(trim(regexp_replace(vc_text, ' {2,}', ' ', 'ig')), '');
  END IF;

  RETURN vc_text;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.fix_str(text[], text, text) OWNER TO postgres;
