DROP FUNCTION IF EXISTS sif.f_v_vzv_vzdo_g(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION sif.f_v_vzv_vzdo_g(
                            pc_rec character varying DEFAULT NULL::character varying
                           )
  RETURNS SETOF sif.v_vzv_vzdo AS
$$
DECLARE

  r_rec record;
  j_rec json := coalesce(pc_rec, '{}')::json;
  vi_limit integer := coalesce(json_extract_path_text(j_rec, 'limit')::integer, 100);
  vi_offset integer := coalesce(json_extract_path_text(j_rec, 'offset')::integer, 0);

BEGIN

  FOR r_rec IN SELECT v.*
                 FROM sif.v_vzv_vzdo v
                   CROSS JOIN (
                               SELECT r.* from json_to_record(j_rec) AS r (vzv_id integer, vzdo_id integer, vzdo_oznaka varchar, vzdo_naziv varchar, vzpv_id integer)
                              ) j
                 WHERE EXISTS
                        (
                         SELECT 1
                           FROM sif.vozilo_vrsta t
                             JOIN sif.vozilo_podvrsta t1 ON (t1.vzv_id=t.vzv_id)
                           WHERE t.vzv_id=v.vzv_id
                             AND t1.vzpv_id=j.vzpv_id
                        )
                   AND v.vzv_id=coalesce(j.vzv_id, v.vzv_id)
                   AND v.vzdo_oznaka ~* coalesce(j.vzdo_oznaka, '.+')
                   AND v.vzdo_naziv ~* coalesce(j.vzdo_naziv, '.+')
                 ORDER BY v.vzdo_oznaka
                 LIMIT vi_limit OFFSET vi_offset LOOP
    RETURN NEXT r_rec;
  END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    RAISE;

END;
$$
  LANGUAGE 'plpgsql';
ALTER FUNCTION sif.f_v_vzv_vzdo_g(character varying) OWNER TO postgres;
