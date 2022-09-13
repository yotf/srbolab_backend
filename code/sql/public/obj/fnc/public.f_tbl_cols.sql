DROP FUNCTION IF EXISTS public.f_tbl_cols(character varying) CASCADE;
CREATE OR REPLACE
FUNCTION public.f_tbl_cols(
                           pc_table character varying DEFAULT NULL::character varying
                          )
  RETURNS SETOF public.t_tbl_cols AS
$$
DECLARE

  r_rec record;
  vc_s2e character varying := '^(information_schema|pg_[ct]|public|_.*)';

BEGIN

  FOR r_rec IN WITH
                 tbls AS -- TABLES/VIEW-s
                  (
                   SELECT n.nspname AS table_schema,
                          c.relname AS table_name,
                          d.description AS table_comment,
                          CASE c.relkind WHEN 'r' THEN 't' ELSE 'v' END AS table_type,
                          0 AS table_level,
                          n.oid AS schema_oid,
                          c.oid AS table_oid
                     FROM pg_catalog.pg_class AS c
                       LEFT JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace
                       LEFT JOIN pg_catalog.pg_description d ON (d.objoid=c.oid AND d.objsubid=0)
                     WHERE n.nspname !~ '^(information_schema|pg_[ct]|public|_.*)'
                       AND c.relkind IN ('r', 'v')
                  ),
                 cns AS -- table CONSTRAINT-s
                  (
                   SELECT t.constraint_schema,
                          t.constraint_name,
                          t.constraint_type,
                          t.table_schema,
                          t.table_name
                     FROM information_schema.table_constraints t
                     WHERE t.table_schema !~ '^(information_schema|pg_[ct]|public|_.*)'
                  ),
                 ccu AS -- CONSTRAINT column usage
                  (
                   SELECT t.constraint_schema,
                          t.constraint_name,
                          t.table_schema,
                          t.table_name,
                          t.column_name
                     FROM information_schema.constraint_column_usage t
                     WHERE t.table_schema !~ '^(information_schema|pg_[ct]|public|_.*)'
                  ),
                 kccu AS -- KEY CONSTRAINT column usage
                  (
                   SELECT t.constraint_schema,
                          t.constraint_name,
                          t.table_schema,
                          t.table_name,
                          t.column_name,
                          t.ordinal_position AS column_order
                     FROM information_schema.key_column_usage t
                     WHERE t.table_schema !~ '^(information_schema|pg_[ct]|public|_.*)'
                  ),
                 cccu AS -- CHECK CONSTRAINT column usage
                  (
                   SELECT cns.constraint_schema,
                          cns.constraint_name,
                          cns.table_schema,
                          cns.table_name,
                          ccu.column_name
                     FROM cns
                       JOIN ccu ON (ccu.constraint_schema=cns.constraint_schema AND ccu.constraint_name=cns.constraint_name AND ccu.table_schema=cns.table_schema AND ccu.table_name=cns.table_name)
                       AND cns.constraint_type='CHECK'
                  ),
                cccs AS -- column CHECK CONSTRAINT-s (stage 1)
                  (
                   SELECT cccu.constraint_schema,
                          cccu.table_schema,
                          cccu.table_name,
                          cccu.column_name,
                          replace(
                                  regexp_replace(
                                                 regexp_replace(
                                                                regexp_replace(
                                                                               regexp_replace(
                                                                                              ccns.check_clause, '(.+\[)(.+?)(\].+)', '\2'
                                                                                             ), '(,)([ ]{1,})', '\1', 'g'
                                                                              ), '::[a-z0-9]+', '', 'g'
                                                ), '([ ]*\([ ]*\([ ]*)||('||cccu.column_name||'[ ]*)(.+)([ ]*\)[ ]*\)[ ]*)', '\3', 'g'
                                 ), '''', ''
                                 ) AS column_check,
                          ccns.check_clause,
                          COUNT(cccu.column_name) OVER (PARTITION BY cccu.constraint_schema, cccu.constraint_name, cccu.table_schema, cccu.table_name) AS column_count
                     FROM cccu
                       JOIN information_schema.check_constraints ccns ON (ccns.constraint_schema=cccu.constraint_schema AND ccns.constraint_name=cccu.constraint_name)
                  ),
                  cccns AS -- CHECK CONSTRAINT column usage (stage 3)
                  (
                   SELECT cccs.table_schema,
                          cccs.table_name,
                          cccs.column_name,
                          cccs.column_check
                     FROM cccs
                     WHERE cccs.column_count=1
                  ),
                 cpkcu AS -- column PRIMARY KEY CONSTRAINT usage
                  (
                   SELECT kccu.table_schema,
                          kccu.table_name,
                          kccu.column_name,
                          kccu.constraint_name,
                          kccu.column_order
                     FROM cns
                       JOIN kccu ON (kccu.table_schema=cns.table_schema AND kccu.table_name=cns.table_name AND kccu.constraint_name=cns.constraint_name)
                       AND cns.constraint_type='PRIMARY KEY'
                  ),
                 cfkcu AS -- column FOREIG KEY CONSTRAINT usage
                  (
                   SELECT kccu.table_schema,
                          kccu.table_name,
                          kccu.column_name,
                          kccu.constraint_name,
                          kccu.column_order
                     FROM cns
                       JOIN kccu ON (kccu.table_schema=cns.table_schema AND kccu.table_name=cns.table_name AND kccu.constraint_name=cns.constraint_name)
                     WHERE cns.constraint_type='FOREIGN KEY'
                  ),
                 cpfkcu AS -- column PRIMARY/FOREIGN KEY CONSTRAINT usage
                  (
                   SELECT cfkcu.table_schema,
                          cfkcu.table_name,
                          cfkcu.column_name,
                          cpkcu.table_schema AS table_schema_p,
                          cpkcu.table_name AS table_name_p,
                          cpkcu.column_name AS column_name_p,
                          ROW_NUMBER() OVER (PARTITION BY cpkcu.table_schema, cpkcu.table_name, cpkcu.column_order, cpkcu.constraint_name) AS chld_cnt
                     FROM information_schema.referential_constraints rc
                       JOIN cpkcu ON (cpkcu.table_schema=rc.unique_constraint_schema AND cpkcu.constraint_name=rc.unique_constraint_name)
                       JOIN cfkcu ON (cfkcu.table_schema=rc.constraint_schema AND cfkcu.constraint_name=rc.constraint_name AND cfkcu.column_order=cpkcu.column_order)
                  ),
                 colsa AS -- all columns
                  (
                   SELECT c.table_schema,
                          c.table_name,
                          c.ordinal_position AS column_order,
                          c.column_name,
                          replace(replace(c.data_type, 'text', 'character varying'), 'double precision', 'numeric') AS column_type,
                          coalesce(CASE WHEN c.numeric_precision IS NOT NULL THEN c.numeric_precision ELSE c.character_maximum_length END, 8) AS column_length,
                          coalesce(c.numeric_scale, 0) AS column_dec,
                          CASE SUBSTR(c.is_nullable, 1, 1) WHEN 'N' THEN 'Y' ELSE 'N' END AS column_is_nn,
                          CASE
                            WHEN c.column_default IS NOT NULL THEN
                              CASE substr(c.data_type, 1, 1)
                                WHEN 'c' THEN
                                  replace(regexp_replace(c.column_default, '::[a-z0-9]+', '', 'g'), '''', '')
                                ELSE
                                  lower(c.column_default)
                              END
                            ELSE
                              NULL
                          END AS column_default,
                          cc.column_check::character varying,
                          CASE WHEN pkc.column_name IS NULL THEN 'N' ELSE 'Y' END::character varying AS column_is_pk,
                          CASE WHEN fkc.column_name IS NULL THEN 'N' ELSE 'Y' END::character varying AS column_is_fk
                     FROM information_schema.columns c
                       LEFT JOIN cpkcu pkc ON (pkc.table_schema=c.table_schema AND pkc.table_name=c.table_name AND pkc.column_name=c.column_name)
                       LEFT JOIN cfkcu fkc ON (fkc.table_schema=c.table_schema AND fkc.table_name=c.table_name AND fkc.column_name=c.column_name)
                       LEFT JOIN cccns cc ON (cc.table_schema=c.table_schema AND cc.table_name=c.table_name AND cc.column_name=c.column_name)
                     WHERE c.table_schema !~ '^(information_schema|pg_[ct]|public|_.*)'
                  ),
                  vcu AS -- VIEW column usage
                  (
                   SELECT vc.view_schema AS table_schema,
                          vc.view_name AS table_name,
                          vc.column_name AS column_name,
                          vc.table_schema AS table_schema_p,
                          vc.table_name AS table_name_p,
                          DENSE_RANK() OVER (PARTITION BY vc.view_schema, vc.view_name, vc.column_name ORDER BY vc.table_schema, CASE WHEN regexp_match(vc.view_name, 'v_('||vc.table_name||'|'||regexp_replace(vc.table_name, '(^.+)(_)(.+$)', '\3\2\1', 'g')||')') IS NOT NULL THEN chr(1) ELSE chr(255) END||vc.table_name, vc.column_name) AS dr
                     FROM information_schema.view_column_usage vc
                     WHERE vc.view_schema !~* '^(information_schema|pg_[ct]|public|_.*)'
                  ),
                 vcols AS -- VIEW columnS
                  (
                   SELECT vcu.table_schema,
                          vcu.table_name,
                          vcu.column_name,
                          vcu.table_schema_p,
                          vcu.table_name_p
                     FROM vcu
                     WHERE vcu.dr=1
                  ),
                 ccm AS -- COLUMN COMMENT-s
                  (
                   SELECT c.table_schema,
                          c.table_name,
                          c.column_name,
                          MAX(d.description) OVER (PARTITION BY c.column_name) AS column_comment
                     FROM colsa c
                       JOIN tbls t ON (t.table_schema=c.table_schema AND c.table_name=t.table_name)
                       LEFT JOIN pg_catalog.pg_description d ON (d.objoid=t.table_oid AND d.objsubid=c.column_order)
                  )
               SELECT c.table_schema::character varying,
                      c.table_name::character varying,
                      c.column_order::integer,
                      c.column_name::character varying,
                      c.column_type::character varying,
                      c.column_length::integer,
                      c.column_dec::integer,
                      max(coalesce(c.column_is_nn, ca.column_is_nn)) OVER (PARTITION BY c.column_name)::character varying AS column_is_nn,
                      max(coalesce(c.column_default, ca.column_default)) OVER (PARTITION BY c.column_name)::character varying AS column_default,
                      max(coalesce(c.column_check, ca.column_check)) OVER (PARTITION BY c.column_name)::character varying AS column_check,
                      coalesce(ca.column_is_pk, c.column_is_pk) AS column_is_pk,
                      coalesce(ca.column_is_fk, c.column_is_fk) AS column_is_fk,
                      coalesce(fkc.table_schema_p, vc.table_schema_p)::character varying AS table_schema_p,
                      coalesce(fkc.table_name_p, vc.table_name_p)::character varying AS table_name_p,
                      coalesce(fkc.column_name_p, vc.column_name)::character varying AS column_name_p,
                      coalesce(tccm.column_comment, pccm.column_comment, vccm.column_comment)::character varying AS column_comment
                 FROM tbls t
                   JOIN colsa c ON (c.table_schema=t.table_schema AND c.table_name=t.table_name)
                   LEFT JOIN cpfkcu fkc ON (fkc.table_schema=c.table_schema AND fkc.table_name=c.table_name AND fkc.column_name=c.column_name)
                   LEFT JOIN vcols vc ON (vc.table_schema=c.table_schema AND vc.table_name=c.table_name AND vc.column_name=c.column_name)
                   LEFT JOIN colsa ca ON (ca.table_schema=vc.table_schema_p AND ca.table_name=vc.table_name_p AND ca.column_name=vc.column_name)
                   LEFT JOIN ccm tccm ON (tccm.table_schema=c.table_schema AND tccm.table_name=c.table_name AND tccm.column_name=c.column_name)
                   LEFT JOIN ccm vccm ON (vccm.table_schema=vc.table_schema_p AND vccm.table_name=vc.table_name_p AND vccm.column_name=vc.column_name)
                   LEFT JOIN ccm pccm ON (pccm.table_schema=fkc.table_schema_p AND pccm.table_name=fkc.table_name_p AND pccm.column_name=fkc.column_name_p)
                 WHERE t.table_name=COALESCE(pc_table, t.table_name)
                 ORDER BY c.table_schema, c.table_name, c.column_order, c.column_name LOOP
    RETURN NEXT r_rec;
  END LOOP;

END;
$$ LANGUAGE 'plpgsql';
ALTER FUNCTION public.f_tbl_cols(character varying) OWNER TO postgres;
