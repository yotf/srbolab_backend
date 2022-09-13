DROP FUNCTION IF EXISTS sif.f_c_motor(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_c_motor(
                       pc_rec varchar
                      )
  RETURNS TABLE(mto_id integer, mto_oznaka varchar, mt_id integer, mt_cm3 float, mt_kw float, col2display varchar) AS
$$
DECLARE

  j_rec json := coalesce(pc_rec, '{}')::json;
  vc_re_opt varchar := CASE WHEN coalesce(json_extract_path_text(j_rec, 'casesens')::boolean, false) THEN '' ELSE 'i' END;
  vc_text varchar := replace(replace(replace(replace(replace(replace(replace(rtrim(trim(regexp_replace(json_extract_path_text(j_rec, 'text'), '(,[ ]*|[ ]*,)', ',', 'g')), ', '), '\', '\\'), '*', '\*'), '.', '\.'), '(', '\('), ')', '\)'), '[', '\['), ']', '\]');
  a_text varchar[] := string_to_array(vc_text, ',', '')::varchar[];
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
    WITH
      v AS
       (
        SELECT mto.mto_id,
               mto.mto_oznaka,
               null::integer AS mt_id,
               null::float AS mt_cm3,
               null::float AS mt_kw,
               (mto.mto_oznaka||' =>  - cm3 /  - kW / ?')::varchar AS col2display
          FROM sif.motor_oznaka mto
          WHERE mto.mto_oznaka='-'
        UNION ALL
        SELECT mto.mto_id,
               mto.mto_oznaka,
               null::integer AS mt_id,
               null::float AS mt_cm3,
               null::float AS mt_kw,
               (mto.mto_oznaka||' =>  - cm3 /  - kW / ?')::varchar AS col2display
          FROM sif.motor_oznaka mto
          WHERE NOT EXISTS
                 (
                  SELECT 1
                    FROM hmlg.vozilo vz
                      JOIN sif.motor mt ON (mt.mt_id=vz.mt_id)
                    WHERE mt.mto_id=mto.mto_id
                 )
        UNION ALL
        SELECT mto.mto_id,
               mto.mto_oznaka,
               mt.mt_id,
               mt.mt_cm3::float,
               mt.mt_kw::float,
               (mto.mto_oznaka||' => '||
                  coalesce(rtrim(to_char(nullif(mt.mt_cm3, 0), 'FM999999D999'), ','), '-')||' cm3 / '||
                  coalesce(rtrim(to_char(nullif(mt.mt_kw, 0), 'FM999999D999'), ','), '-')||' kW / '||
                  coalesce(mtt.mtt_naziv, '?'))::varchar AS col2display
          FROM hmlg.vozilo vz
            JOIN sif.motor mt ON (vz.mt_id=mt.mt_id)
            JOIN sif.motor_oznaka mto ON (mto.mto_id=mt.mto_id)
            LEFT JOIN sif.motor_tip mtt ON (mtt.mtt_id=mt.mtt_id)
            LEFT JOIN sif.model_tip mdt ON (mdt.mdt_id=vz.mdt_id)
            LEFT JOIN sif.model_varijanta mdvr ON (mdvr.mdvr_id=vz.mdvr_id)
            LEFT JOIN sif.model_verzija mdvz ON (mdvz.mdvz_id=vz.mdvz_id)
          GROUP BY mto.mto_id, mto.mto_oznaka, mt.mt_id, mt.mt_cm3, mt.mt_kw, mtt.mtt_id, mtt.mtt_oznaka, mtt.mtt_naziv
       )
    SELECT v.mto_id,
           v.mto_oznaka,
           v.mt_id,
           v.mt_cm3,
           v.mt_kw,
           v.col2display
      FROM v
      WHERE regexp_match(v.mto_oznaka, a_text[1], vc_re_opt) IS NOT NULL
        AND regexp_match(regexp_replace(v.mt_cm3::varchar, '\.[0]+$', '', 'g'), a_text[2], vc_re_opt) IS NOT NULL
        AND regexp_match(regexp_replace(v.mt_kw::varchar, '\.[0]+$', '', 'g'), a_text[3], vc_re_opt) IS NOT NULL
      ORDER BY v.mto_oznaka, v.mt_cm3 NULLS FIRST, v.mt_kw NULLS FIRST;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_c_motor(varchar) OWNER TO postgres;
