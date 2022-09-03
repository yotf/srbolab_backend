DROP FUNCTION IF EXISTS public.f_compc(text, text) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_compc(
                        pc_val1 text,
                        pc_val2 text
                       )
  RETURNS boolean
AS $$
DECLARE

  vb_cond boolean;
  vc_val1 varchar := coalesce(nullif(pc_val1, ''), '`');
  vc_val2 varchar := coalesce(nullif(pc_val2, ''), chr(1));
  vc_1stc varchar := substring(vc_val2, 1, 1);

BEGIN

  IF vc_1stc IN ('=', '!', '^', '$') THEN
    vc_val2 := substring(vc_val2, 2);
  END IF;
  vb_cond := CASE vc_val2
               WHEN chr(1) THEN true
               WHEN '`' THEN pc_val1 IS NULL
               WHEN '~' THEN pc_val1 IS NOT NULL
               ELSE
                 CASE vc_1stc
                   WHEN '=' THEN upper(vc_val1)=upper(vc_val2)
                   WHEN '!' THEN vc_val1 NOT ILIKE '%'||vc_val2||'%'
                   WHEN '^' THEN vc_val1 ILIKE vc_val2||'%'
                   WHEN '$' THEN vc_val1 ILIKE '%'||vc_val2
                   ELSE
                     CASE
                       WHEN position(',' in vc_val2)=0 THEN vc_val1 ILIKE '%'||vc_val2||'%'
                       ELSE vc_val1 ~* ('('||replace(vc_val2, ',', '|')||')')::varchar
                     END
                 END
             END;

  RETURN vb_cond;

END;
$$ LANGUAGE 'plpgsql' IMMUTABLE;
ALTER FUNCTION public.f_compc(text, text) OWNER TO postgres;
