/* Table _t.model_year */
DROP TABLE IF EXISTS _t.model_year CASCADE;
-- Table _t.model_year
CREATE TABLE _t.model_year
(
  my_rng INTEGER NOT NULL,
  my_oznaka CHAR(1) NOT NULL,
  my_godina INTEGER NOT NULL
);

-- Primary key on table _t.model_year
ALTER TABLE _t.model_year ADD CONSTRAINT vzi_pk PRIMARY KEY (my_godina);

-- Alternate keys on table _t.model_year
ALTER TABLE _t.model_year ADD CONSTRAINT my_rng_oznaka_uk UNIQUE (my_rng, my_oznaka);

-- Indexes on table _t.model_year
CREATE INDEX my_rng_i ON _t.model_year (my_rng);
CREATE INDEX my_oznaka_i ON _t.model_year (my_oznaka);

--------------------------------------------------------------------------------

INSERT INTO _t.model_year (my_rng, my_oznaka, my_godina)
SELECT t.my_rng::INTEGER,
       t.my_oznaka::VARCHAR,
       t.my_godina::INTEGER
  FROM (
        VALUES (1, 'A', 1980),
               (1, 'B', 1981),
               (1, 'C', 1982),
               (1, 'D', 1983),
               (1, 'E', 1984),
               (1, 'F', 1985),
               (1, 'G', 1986),
               (1, 'H', 1987),
               (1, 'J', 1988),
               (1, 'K', 1989),
               (1, 'L', 1990),
               (1, 'M', 1991),
               (1, 'N', 1992),
               (1, 'P', 1993),
               (1, 'R', 1994),
               (1, 'S', 1995),
               (1, 'T', 1996),
               (1, 'V', 1997),
               (1, 'W', 1998),
               (1, 'X', 1999),
               (1, 'Y', 2000),
               (1, '1', 2001),
               (1, '2', 2002),
               (1, '3', 2003),
               (1, '4', 2004),
               (1, '5', 2005),
               (1, '6', 2006),
               (1, '7', 2007),
               (1, '8', 2008),
               (1, '9', 2009),
               (2, 'A', 2010),
               (2, 'B', 2011),
               (2, 'C', 2012),
               (2, 'D', 2013),
               (2, 'E', 2014),
               (2, 'F', 2015),
               (2, 'G', 2016),
               (2, 'H', 2017),
               (2, 'J', 2018),
               (2, 'K', 2019),
               (2, 'L', 2020),
               (2, 'M', 2021),
               (2, 'N', 2022),
               (2, 'P', 2023),
               (2, 'R', 2024),
               (2, 'S', 2025),
               (2, 'T', 2026),
               (2, 'V', 2027),
               (2, 'W', 2028),
               (2, 'X', 2029),
               (2, 'Y', 2030),
               (2, '1', 2031),
               (2, '2', 2032),
               (2, '3', 2033),
               (2, '4', 2034),
               (2, '5', 2035),
               (2, '6', 2036),
               (2, '7', 2037),
               (2, '8', 2038),
               (2, '9', 2039)
       ) t (my_rng, my_oznaka, my_godina)
  ORDER BY t.my_godina;
COMMIT;
