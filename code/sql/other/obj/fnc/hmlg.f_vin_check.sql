DROP FUNCTION IF EXISTS hmlg.f_vin_check(varchar, integer) CASCADE;
CREATE OR REPLACE
FUNCTION hmlg.f_vin_check(
                          pc_vin varchar,
                          pi_pos integer DEFAULT 10
                         )
  RETURNS varchar
AS $$
DECLARE

  vc_vin varchar;
  vc_inv_chars varchar;
  vc_vin_errors varchar;

BEGIN

  vc_vin := trim(upper(pc_vin));
  IF length(vc_vin)=17 THEN
    IF pc_vin ~ '^[A-HJ-NPR-Z0-9]+$' THEN
      IF substring(pc_vin, pi_pos, 1) ~ '^[A-HJ-NPR-TV-Y1-9]+$' THEN
        NULL;
      ELSE
        vc_vin_errors := format('Pogrešan znak (%s) za godinu modela!', substring(pc_vin, pi_pos, 1));
      END IF;
    ELSE
      WITH
        s AS
         (
          SELECT DISTINCT
                 (c.c)[1]
            FROM regexp_matches(pc_vin, '[IOQ]', 'g') AS c
         ),
        r AS
         (
          SELECT row_number() OVER (ORDER BY s.c DESC) AS n,
                 string_agg(s.c, ',') OVER (ORDER BY s.c) AS c
            FROM s
         )
      SELECT r.c
        INTO vc_inv_chars
        FROM r
        WHERE r.n=1;
      vc_vin_errors := format('Ima nedozvoljenih znakova (%s) u broju šasije!', vc_inv_chars);
    END IF;
  ELSE
    IF length(vc_vin)<17 THEN
      vc_vin_errors := 'Dužina broja šasije je manja od 17 znakova!';
    ELSE
      vc_vin_errors := 'Dužina broja šasije je veća od 17 znakova!';
    END IF;
  END IF;

  RETURN vc_vin_errors;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION hmlg.f_vin_check(varchar, integer) OWNER TO postgres;
