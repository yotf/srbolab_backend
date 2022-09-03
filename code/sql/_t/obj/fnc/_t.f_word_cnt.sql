DROP FUNCTION IF EXISTS _t.word_cnt(text) CASCADE;
CREATE OR REPLACE
FUNCTION _t.word_cnt(
                     pc_text text
                    )
  RETURNS integer
AS $$
DECLARE

  ac_words varchar[] := string_to_array(regexp_replace(pc_text, ' {2,}', ' ', 'gi'), ' ', '')::varchar[];
  vi_word_cnt integer := array_length(ac_words, 1);

BEGIN

  RETURN vi_word_cnt;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION _t.word_cnt(text) OWNER TO postgres;
