DROP FUNCTION IF EXISTS _t.word(text, integer) CASCADE;
CREATE OR REPLACE
FUNCTION _t.word(
                 pc_text text,
                 pi_word_no integer
                )
  RETURNS text
AS $$
DECLARE

  ac_words varchar[] := string_to_array(regexp_replace(pc_text, ' {2,}', ' ', 'gi'), ' ', '')::varchar[];
  vi_word_cnt integer := array_length(ac_words, 1);
  vc_word varchar;

BEGIN

  IF pi_word_no>0 AND pi_word_no<=vi_word_cnt THEN
    vc_word := ac_words[pi_word_no];
  END IF;

  RETURN vc_word;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.word(text, integer) OWNER TO postgres;
