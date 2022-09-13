DROP FUNCTION IF EXISTS _t.fix_kl_naziv(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.fix_kl_naziv(pc_text text)
  RETURNS text
AS $$
DECLARE

  va_rexp text[][];
  vc_text varchar;

BEGIN

  va_rexp := array[
                   ['x', '^AC MILENIJUM.*$', 'AUTO CENTAR MILENIJUM DOO BEOGRAD', 'ig'],
                   ['x', '^.*HERTNER.*$', 'HERTNER AUTO DOO BEOGRAD', 'ig'],
                   ['x', '^.*KRLE.*PLUS.*$', 'KRLE ŠPED PLUS', 'ig'],
                   ['x', '^.*TIDUO.*$', 'TIDUOAUTO', 'ig'],
                   ['x', '^.*URO.*CAR.*$', 'UROŠEVIĆ CARS DOO', 'ig'],
                   ['x', '^MILANO.+AUTO.+$', 'MILANO-AUTO 2005 DOO, ŠABAC', 'ig'],
                   ['r', 'NICIFOROVIC', 'NIĆIFOROVIĆ', 'ig'],
                   ['r', 'ДУКУЋ', 'ДУКИЋ', 'ig'],
                   ['r', 'ПЕДРАГ', 'ПРЕДРАГ', 'ig'],
                   ['x', '(IC)( |$)', 'IĆ', 'ig'],
                   ['x', '^(.+)( )(.+(УЋ|ИЋ|SKI|IĆ|КА))$', '\3\2\1', 'ig']
                  ];

  vc_text := _t.fix_str(va_rexp, upper(pc_text));
  IF NOT _t.iscir(vc_text) AND ((_t.word_cnt(vc_text)=2 AND vc_text !~* '(D\.|O\.|SZR|MILENIJ)') OR (_t.word_cnt(vc_text)=3 AND vc_text ~* 'IVANA')) THEN
    vc_text := _t.lat2cir(vc_text);
  END IF;
  vc_text := CASE
               WHEN (
                     (_t.word_cnt(vc_text)=2 AND vc_text !~* '(D\.|SZR|MILENIJ)') OR (_t.word_cnt(vc_text)=3 AND vc_text ~* 'IVANA')
                    ) AND NOT _t.iscir(vc_text) THEN
                 _t.lat2cir(vc_text)
               ELSE
                 vc_text
             END;

  RETURN vc_text;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.fix_kl_naziv(text) OWNER TO postgres;
