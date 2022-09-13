DROP FUNCTION IF EXISTS _t.fix_md_naziv_k(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.fix_md_naziv_k(pc_text text)
  RETURNS text
AS $$
DECLARE

  va_rexp text[][];

BEGIN

  va_rexp := array[
                   ['x', '(A|320|530|1|F)( )(4|D|ER|650)', '\1\3', 'ig'],
                   ['x', '(X)(1|3|4|5|6)([ ]*)(|X|S)(DRIVE)([ ]*)([0-9]{2}D)', '\1\2 \4\5 \7', 'ig'],
                   ['x', '^COMPAS$', 'COMPASS', 'ig'],
                   ['x', '^CEED$', 'CEE''D', 'ig'],
                   ['x', '^(A|B|C|E|S)([0-9]{3})(| CDI)$', '\1 \2\3', 'ig'],
                   ['x', '^(RAV)([ ]+)(4)$', '\1\3', 'ig'],
                   ['x', '^(C|S|V)([ ]*)([0-9]{2})$', '\1\3', 'ig'],
                   ['x', '([0-9]{3})(CDI)', '\1 \2', 'ig'],
                   ['x', '(-[A-Z])$', '', 'ig'],
                   ['x', '^([0-9]{3})([A-Z])$', '\1 \2', 'ig'],
--                   ['x', '^(116)(ED)$', '\1 \2', 'ig'],
                   ['x', '(;)([^ ])', '\1 \2', 'ig'],
                   ['x', '^([0-9]{3})([ ]+)([A-Z])$', '\1\3', 'ig'],
                   ['x', '(TCSON|TUCON)', 'TUCSON', 'ig'],
                   ['r', 'I X 35', 'IX35', 'ig'],
                   ['r', 'IX35,LM', 'IX35, LM', 'ig'],
                   ['r', 'AN 650', 'AN650', 'ig'],
                   ['r', 'BOXPT', 'BOXER', 'ig'],
                   ['r', 'TGX 18440', 'TGX 18.440', 'ig'],
                   ['r', 'X5 XDRIVE50I', 'X5 XDRIVE 50I', 'ig'],
                   ['r', 'GLC 250D 4MATIC', 'GLC 250 D 4MATIC', 'ig'],
                   ['r', 'G- CABRIO', 'G-CABRIO', 'ig'],
                   ['x', '(TRANSIT)(.+)(TOURNEO)', '\1 \3', 'ig'],
                   ['x', '(LANCIA)([^ ]+)', '\1 \2', 'ig'],
                   ['x', '(TGA)([^ ]+)', '\1 \2', 'ig'],
                   ['x', '(COMPRESSOR|KOPRESSOR)', 'KOMPRESSOR', 'ig'],
                   ['x', '(XC)([ ]+)([0-9]{2})', '\1\3', 'ig'],
                   ['x', '(ML)([0-9]{3})(.+)', '\1 \2\3', 'ig']
                  ];

  RETURN _t.fix_str(va_rexp, upper(pc_text));

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.fix_md_naziv_k(text) OWNER TO postgres;
