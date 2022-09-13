DROP FUNCTION IF EXISTS sif.f_c_ag_homologacija(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_c_ag_homologacija(
                                 pc_rec character varying
                                )
  RETURNS SETOF sif.v_ag_homologacija AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vc_text character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'fromstart')::boolean, false)::boolean THEN '^' ELSE '' END||coalesce(json_extract_path_text(j_rec, 'text'), '.+');
  vc_re_opt character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'casesens')::boolean, false) THEN '' ELSE 'i' END;

BEGIN

  FOR r_rec IN SELECT v.agh_id,
                      v.agh_oznaka,
                      v.agu_id,
                      v.agu_oznaka,
                      v.agu_naziv
                 FROM sif.v_ag_homologacija v
                 WHERE NOT EXISTS
                        (
                         SELECT 1
                           FROM sif.agp_agh r
                           WHERE r.agp_id=json_extract_path_text(j_rec, 'agp_id')::integer
                             AND r.agh_id=v.agh_id
                        )
                   AND (
                        regexp_match(v.agh_oznaka, vc_text, vc_re_opt) IS NOT NULL
                     OR regexp_match(v.agu_oznaka, vc_text, vc_re_opt) IS NOT NULL
                     OR regexp_match(v.agu_naziv, vc_text, vc_re_opt) IS NOT NULL
                       )
                 ORDER BY v.agu_oznaka, v.agh_oznaka LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_c_ag_homologacija(character varying) OWNER TO postgres;
