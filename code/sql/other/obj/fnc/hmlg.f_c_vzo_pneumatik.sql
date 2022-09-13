DROP FUNCTION IF EXISTS hmlg.f_c_vzo_pneumatik(varchar) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_c_vzo_pneumatik(
                                pc_rec varchar
                               )
  RETURNS TABLE(
                vzo_pneumatik varchar
               ) AS
$$
DECLARE

  j_rec json := coalesce(pc_rec, '{}')::json;
  vc_re_opt varchar := CASE WHEN coalesce(json_extract_path_text(j_rec, 'casesens')::boolean, false) THEN '' ELSE 'i' END;
  vc_text varchar := CASE WHEN coalesce(json_extract_path_text(j_rec, 'fromstart')::boolean, false)::boolean THEN '^' ELSE '' END||coalesce(_t.fix_str4re(json_extract_path_text(j_rec, 'text')), '.+');
  vc_fromstart varchar := CASE WHEN coalesce(json_extract_path_text(j_rec, 'fromstart')::boolean, false)::boolean THEN '^' ELSE '' END;

BEGIN

  RETURN QUERY
    SELECT DISTINCT
           t.vzo_pneumatik
      FROM hmlg.vozilo_osovina t
      WHERE coalesce(t.vzo_pneumatik, '-')<>'-'
        AND regexp_match(t.vzo_pneumatik, vc_text, vc_re_opt) IS NOT NULL
      ORDER BY t.vzo_pneumatik;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION hmlg.f_c_vzo_pneumatik(varchar) OWNER TO postgres;
