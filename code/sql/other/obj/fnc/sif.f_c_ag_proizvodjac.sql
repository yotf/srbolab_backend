DROP FUNCTION IF EXISTS sif.f_c_ag_proizvodjac(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_c_ag_proizvodjac(
                                pc_rec character varying
                               )
  RETURNS SETOF sif.ag_proizvodjac AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vc_text character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'fromstart')::boolean, false)::boolean THEN '^' ELSE '' END||coalesce(json_extract_path_text(j_rec, 'text'), '.+');
  vc_re_opt character varying := CASE WHEN coalesce(json_extract_path_text(j_rec, 'casesens')::boolean, false) THEN '' ELSE 'i' END;

BEGIN

  FOR r_rec IN SELECT v.agp_id,
                      v.agp_naziv,
                      v.agp_napomena
                 FROM sif.ag_proizvodjac v
                 WHERE NOT EXISTS
                        (
                         SELECT 1
                           FROM sif.agp_agh r
                           WHERE r.agh_id=json_extract_path_text(j_rec, 'agh_id')::integer
                             AND r.agp_id=v.agp_id
                        )
                   AND (
                        regexp_match(v.agp_naziv, vc_text, vc_re_opt) IS NOT NULL
                     OR regexp_match(coalesce(v.agp_napomena, '#'), vc_text, vc_re_opt) IS NOT NULL
                       )
                 ORDER BY v.agp_naziv LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_c_ag_proizvodjac(character varying) OWNER TO postgres;
