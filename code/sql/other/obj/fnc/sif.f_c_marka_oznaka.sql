DROP FUNCTION IF EXISTS sif.f_c_marka_oznaka(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_c_marka_oznaka(
                              pc_rec character varying
                             )
  RETURNS SETOF sif.marka AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vc_text character varying := '^'||coalesce(json_extract_path_text(j_rec, 'text'), '#')||'$';
  vc_re_opt character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'casesens')::boolean, false) THEN '' ELSE 'i' END;

BEGIN

  FOR r_rec IN SELECT mr.mr_id,
                      mr.mr_naziv
                 FROM sif.marka mr
                   JOIN sif.mr_oznaka mro ON (mro.mr_id=mr.mr_id)
                 WHERE regexp_match(mro.mro_oznaka, vc_text, vc_re_opt) IS NOT NULL
                 ORDER BY mr.mr_naziv LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_c_marka_oznaka(character varying) OWNER TO postgres;
