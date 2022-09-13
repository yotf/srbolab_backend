CREATE OR REPLACE
VIEW sys.v_kalendar AS
SELECT to_char(t.kn_datum, 'dd.mm.yyyy') AS kn_datum,
       ('{"Ponedeljak","Utorak","Sreda","Četvrtak","Petak","Subota","Nedelja"}'::text[])[extract(isodow from t.kn_datum)] AS kn_dan,
--       ('{"Понедељак","Уторак","Среда","Четвртак","Петак","Субота","Недеља"}'::text[])[extract(isodow from t.kn_datum)] AS kn_dan,
       t.kn_napomena
  FROM sys.kalendar t;
COMMENT ON VIEW sys.v_kalendar IS 'Kalendar';
COMMENT ON COLUMN sys.v_kalendar.kn_datum IS 'Datum';
COMMENT ON COLUMN sys.v_kalendar.kn_dan IS 'Dan';
