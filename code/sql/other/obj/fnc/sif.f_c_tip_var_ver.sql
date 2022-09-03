DROP FUNCTION IF EXISTS sif.f_c_tip_var_ver(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_c_tip_var_ver(
                             pc_rec varchar
                            )
  RETURNS TABLE(mdt_id integer, mdt_oznaka varchar, mdvr_id integer, mdvr_oznaka varchar, mdvz_id integer, mdvz_oznaka varchar, col2display varchar) AS
$$
DECLARE

  j_rec json := coalesce(pc_rec, '{}')::json;
  vc_re_opt varchar := CASE WHEN coalesce(json_extract_path_text(j_rec, 'casesens')::boolean, false) THEN '' ELSE 'i' END;
--   vc_text varchar := public.f_str4re(rtrim(trim(regexp_replace(json_extract_path_text(j_rec, 'text'), '(,[ ]*|[ ]*,)', ',', 'g'))));
  vc_text varchar := public.f_str4re(rtrim(trim(regexp_replace(json_extract_path_text(j_rec, 'text'), '(/[ ]*|[ ]*/)', '/', 'g'))));
--   a_text varchar[] := string_to_array(vc_text, ',', '')::varchar[];
  a_text varchar[] := string_to_array(vc_text, '/', '')::varchar[];
  vi_arrlen integer := array_length(a_text, 1);
  vc_fromstart varchar := CASE WHEN coalesce(json_extract_path_text(j_rec, 'fromstart')::boolean, false)::boolean THEN '^' ELSE '' END;

BEGIN

  FOR vi_idx IN 1..3 LOOP
    IF vi_idx<=vi_arrlen THEN
      a_text[vi_idx] := vc_fromstart||coalesce(a_text[vi_idx], '.+');
    ELSE
      a_text := array_append(a_text, (vc_fromstart||'.+')::varchar);
    END IF;
  END LOOP;

  RETURN QUERY
    SELECT mdt.mdt_id,
           mdt.mdt_oznaka,
           mdvr.mdvr_id,
           mdvr.mdvr_oznaka,
           mdvz.mdvz_id,
           mdvz.mdvz_oznaka,
           (coalesce(mdt.mdt_oznaka, '-')||' / '||coalesce(mdvr.mdvr_oznaka, '-')||' / '||coalesce(mdvz.mdvz_oznaka, '-'))::varchar AS col2display
      FROM hmlg.vozilo vz
        JOIN sif.marka mr ON (vz.mr_id=mr.mr_id)
        JOIN sif.model md ON (md.mr_id=vz.mr_id AND md.md_id=vz.md_id)
        LEFT JOIN sif.model_tip mdt ON (mdt.mdt_id=vz.mdt_id)
        LEFT JOIN sif.model_varijanta mdvr ON (mdvr.mdvr_id=vz.mdvr_id)
        LEFT JOIN sif.model_verzija mdvz ON (mdvz.mdvz_id=vz.mdvz_id)
      WHERE (mdt.mdt_id IS NOT NULL OR mdvr.mdvr_id IS NOT NULL OR mdvz.mdvz_id IS NOT NULL)
        AND regexp_match(coalesce(mdt.mdt_oznaka, '-'), a_text[1], vc_re_opt) IS NOT NULL
        AND regexp_match(coalesce(mdvr.mdvr_oznaka, '-'), a_text[2], vc_re_opt) IS NOT NULL
        AND regexp_match(coalesce(mdvz.mdvz_oznaka, '-'), a_text[3], vc_re_opt) IS NOT NULL
      GROUP BY mdt.mdt_id, mdt.mdt_oznaka, mdvr.mdvr_id, mdvr.mdvr_oznaka, mdvz.mdvz_id, mdvz.mdvz_oznaka
      ORDER BY mdt.mdt_oznaka, mdvr.mdvr_oznaka, mdvz.mdvz_oznaka;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_c_tip_var_ver(varchar) OWNER TO postgres;
