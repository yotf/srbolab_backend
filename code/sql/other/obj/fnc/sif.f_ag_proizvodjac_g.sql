DROP FUNCTION IF EXISTS sif.f_ag_proizvodjac_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_ag_proizvodjac_g(
                                pc_rec character varying DEFAULT NULL::character varying
                               )
  RETURNS SETOF sif.ag_proizvodjac AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT t.*
                 FROM sif.ag_proizvodjac t
                   CROSS JOIN (SELECT r.* from json_populate_record(null::sif.ag_proizvodjac, j_rec) r) j
                 WHERE t.agp_id=coalesce(j.agp_id, t.agp_id)
                   AND t.agp_naziv ~* coalesce(j.agp_naziv, '.+')
                   AND coalesce(t.agp_napomena, '#') ~* coalesce(j.agp_napomena, '.*')
                 ORDER BY t.agp_naziv
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_ag_proizvodjac_g(character varying) OWNER TO postgres;
