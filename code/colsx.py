#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
import sys
import os.path as osp
import sqlite3 as db_sqll

# site-packages
from box import SBox as dd
moduldir = osp.dirname(osp.dirname(osp.abspath(__file__)))

sys.path.append(osp.join(moduldir, 'flask_app', 'code'))

# local
from procedures.pgdb import pgdb
from ddlfix import mdl

#---------------------------------------
# global variables
#---------------------------------------
#= FUNCTION ============================
# colsx_update
#=======================================
def colsx_update():

  sqls = dd({})
  sqls['sql_ts'] = """SELECT t.table_name,
       t.table_schema,
       t.table_type,
       t.table_comment,
       t.table_level
  FROM db_tables t
  ORDER BY t.table_name;"""
  sqls['sql_t2d'] = """SELECT t.table_name
  FROM db_tables t
  WHERE NOT EXISTS
         (
          SELECT 1
            FROM db_columns c
            WHERE c.table_name=t.table_name
         )
  ORDER BY t.table_name;"""
  sqls['sql_cs'] = """SELECT c.table_name,
       c.column_name,
       c.column_order,
       c.column_type,
       c.column_length,
       c.column_dec,
       c.column_is_nn,
       c.column_default,
       c.column_check,
       c.column_is_pk,
       c.column_is_fk,
       c.table_name_p,
       c.column_name_p,
       c.column_comment,
       c.column_label,
       c.column_header,
       c.column_tooltip,
       c.column_show,
       c.column_edit,
       c.column_fill,
       c.column_pick,
       c.column_control
  FROM db_columns c
  ORDER BY c.table_name, c.column_order;"""
  sqls['sql_c2d'] = """SELECT c.table_name,
       c.column_name
  FROM db_columns c
  WHERE NOT EXISTS
         (
          SELECT 1
            FROM db_tables t
            WHERE t.table_name=c.table_name
         )
  ORDER BY c.table_name, c.column_order;"""
  sqls['sql_tp'] = """SELECT f.table_name,
       f.table_schema,
       f.table_type,
       f.table_comment,
       0 AS table_level,
       NULL AS table_iu,
       NULL AS table_cols
  FROM public.f_tbls() f
  ORDER BY f.table_name;"""
  sqls['sql_cp'] = """SELECT f.table_name,
       f.column_name,
       f.column_order,
       f.column_type,
       f.column_length,
       f.column_dec,
       lower(f.column_is_nn) AS column_is_nn,
       f.column_default,
       f.column_check,
       lower(f.column_is_pk) AS column_is_pk,
       lower(f.column_is_fk) AS column_is_fk,
       f.table_name_p,
       f.column_name_p,
       f.column_comment,
--       null AS column_label,
       f.column_comment AS column_label,
       initcap(substring(f.column_name, strpos(f.column_name, '_')+1)) AS column_header,
--       null AS column_tooltip,
       f.column_comment AS column_tooltip,
       CASE WHEN strpos(f.column_name, '_id')>0 THEN 'n' ELSE 'y' END AS column_show,
       CASE WHEN strpos(f.column_name, '_id')>0 THEN 'n' ELSE 'y' END AS column_edit,
       CASE WHEN strpos(f.column_name, '_id')>0 THEN 'n' ELSE 'y' END AS column_fill,
       'n' AS column_pick,
       CASE WHEN f.column_check IN ('D,N', 'N,D') THEN 'check' ELSE 'text' END AS column_control,
       NULL AS column_iu
  FROM public.f_tbl_cols() f
  ORDER BY f.table_name, f.column_order;"""
  sqls['dml_td'] = """DELETE
  FROM db_tables
  WHERE table_name=:table_name;"""
  sqls['dml_ti'] = """INSERT INTO db_tables (table_name, table_schema, table_type, table_comment, table_level) VALUES (:table_name, :table_schema, :table_type, :table_comment, :table_level);"""
  sqls['dml_tu'] = """UPDATE db_tables
  SET table_schema=:table_schema,
      table_type=:table_type,
      table_comment=:table_comment
  WHERE table_name=:table_name;"""
  sqls['dml_cd'] = """DELETE
  FROM db_columns
  WHERE table_name=:table_name
    AND column_name=:column_name;"""
  sqls['dml_ci'] = """INSERT INTO db_columns (table_name, column_name, column_order, column_type, column_length, column_dec, column_is_nn, column_default, column_check, column_is_pk, column_is_fk, table_name_p, column_name_p, column_comment, column_label, column_header, column_tooltip, column_show, column_edit, column_fill, column_pick, column_control) VALUES (:table_name, :column_name, :column_order, :column_type, :column_length, :column_dec, :column_is_nn, :column_default, :column_check, :column_is_pk, :column_is_fk, :table_name_p, :column_name_p, :column_comment, :column_label, :column_header, :column_tooltip, :column_show, :column_edit, :column_fill, :column_pick, :column_control);"""
  sqls['dml_cu'] = """UPDATE db_columns
  SET column_order=:column_order,
      column_type=:column_type,
      column_length=:column_length,
      column_dec=:column_dec,
      column_is_nn=:column_is_nn,
      column_default=:column_default,
      column_check=:column_check,
      column_is_pk=:column_is_pk,
      column_is_fk=:column_is_fk,
      table_name_p=:table_name_p,
      column_name_p=:column_name_p,
      column_comment=:column_comment
  WHERE table_name=:table_name
    AND column_name=:column_name;"""

  cols = dd({})
  cols['tbl'] = ['table_name', 'table_schema', 'table_type', 'table_comment', 'table_level']
  cols['col'] = ['table_name', 'column_name', 'column_order', 'column_type', 'column_length', 'column_dec', 'column_is_nn', 'column_default', 'column_check', 'column_is_pk', 'column_is_fk', 'table_name_p', 'column_name_p', 'column_comment', 'column_label', 'column_header', 'column_tooltip', 'column_show', 'column_edit', 'column_fill', 'column_pick', 'column_control']
  cols['cols2chkt'] = ['table_schema', 'table_type', 'table_comment']
  cols['cols2chkc'] = ['column_order', 'column_type', 'column_length', 'column_dec', 'column_is_nn', 'column_default', 'column_check', 'column_is_pk', 'column_is_fk', 'table_name_p', 'column_name_p', 'column_comment']
  cols['cols2popc'] = ['column_label', 'column_header', 'column_tooltip', 'column_show', 'column_edit', 'column_fill', 'column_pick', 'column_control']

  vbl_ok2do = False

# postgres
  db_pg = pgdb()
  conn_pg = db_pg.connget()
  crsr_pg = conn_pg.cursor()

# sqllite
  conn_sqll = db_sqll.connect(osp.join(osp.join(moduldir, 'flask_app', 'code', 'procedures'), 'colsx.db'), detect_types=db_sqll.PARSE_COLNAMES|db_sqll.PARSE_DECLTYPES, isolation_level='IMMEDIATE')
  crsr_sqll = conn_sqll.cursor()
  crsr_sqll1 = conn_sqll.cursor()

  crsr_sqll1.execute(sqls.sql_t2d)
  for r in crsr_sqll1:
    try:
      crsr_sqll.execute(sqls.dml_td, {'table_name': r[0]})
      conn_sqll.commit()
#      print('Table "{}" deleted.'.format(r[0]))
    except:
      raise

  crsr_sqll1.execute(sqls.sql_c2d)
  for r in crsr_sqll1:
    try:
      crsr_sqll.execute(sqls.dml_cd, {'table_name': r[0], 'column_name': r[1]})
      conn_sqll.commit()
#      print('  Table "{}"; Column "{}" deleted.'.format(r[0], r[1]))
    except:
      raise
  crsr_sqll1.close()

# sqllite
  tblss = dd({})
# tables
  try:
    crsr_sqll.execute(sqls.sql_ts)
    for r in crsr_sqll:
      tblss[r[0]] = dict(zip(cols.tbl, r))
      tblss[r[0]]['table_cols'] = {}
  except:
    raise

# columns
  try:
    crsr_sqll.execute(sqls.sql_cs)
    for r in crsr_sqll:
      tblss[r[0]]['table_cols'][r[1]] = dict(zip(cols.col, r))
  except:
    raise

# postgres
  tblsp = dd({})
# tables
  try:
    crsr_pg.execute(sqls.sql_tp)
    for r in crsr_pg:
      vcl_tbl = r['table_name']
      tblsp[vcl_tbl] = r
      tblsp[vcl_tbl]['table_cols'] = {}
      if vcl_tbl in tblss:
        for vcl_tblprop in cols.cols2chkt:
          if tblsp[vcl_tbl][vcl_tblprop]!=tblss[vcl_tbl][vcl_tblprop]:
            tblsp[vcl_tbl]['table_iu'] = 'u'
            vbl_ok2do = True
            break
      else:
        tblsp[vcl_tbl]['table_iu'] = 'i'
        vbl_ok2do = True
  except:
    raise

# columns
  try:
    crsr_pg.execute(sqls.sql_cp)
    for r in crsr_pg:
      vcl_tbl = r['table_name']
      vcl_col = r['column_name']
      tblsp[vcl_tbl]['table_cols'][vcl_col] = r
      if vcl_tbl in tblss:
        if vcl_col in tblss[vcl_tbl]['table_cols']:
          for vcl_colprop in cols.cols2chkc:
            if tblsp[vcl_tbl]['table_cols'][vcl_col][vcl_colprop]!=tblss[vcl_tbl].table_cols[vcl_col][vcl_colprop]:
              tblsp[vcl_tbl]['table_cols'][vcl_col]['column_iu'] = 'u'
              vbl_ok2do = True
#              print('{} # {} # {} # p: {} # s: {}'.format(vcl_tbl, vcl_col, vcl_colprop, tblsp[vcl_tbl]['table_cols'][vcl_col][vcl_colprop], tblss[vcl_tbl].table_cols[vcl_col][vcl_colprop]))
              break
        else:
          tblsp[vcl_tbl]['table_cols'][vcl_col]['column_iu'] = 'i'
          vbl_ok2do = True
      else:
        tblsp[vcl_tbl]['table_cols'][vcl_col]['column_iu'] = 'i'
        vbl_ok2do = True
  except:
    raise

# final
# DELETE
  for vcl_tbl, dxl_tbl in sorted(tblss.items()):
    dxl_cols = dxl_tbl.pop('table_cols')
    if vcl_tbl not in tblsp:
      try:
        crsr_sqll.execute(sqls.dml_td, {'table_name': vcl_tbl})
        conn_sqll.commit()
        print('Table "{}" deleted.'.format(vcl_tbl))
      except:
        raise
    else:
      for vcl_col in dxl_cols.keys():
        if vcl_col not in tblsp[vcl_tbl].table_cols:
          try:
            crsr_sqll.execute(sqls.dml_cd, {'table_name': vcl_tbl, 'column_name': vcl_col})
            conn_sqll.commit()
            print('  Table "{}"; Column "{}" deleted.'.format(vcl_tbl, vcl_col))
          except:
            raise

# INSERT/UPDATE
  if vbl_ok2do:
    for vcl_tbl, dxl_tbl in sorted(tblsp.items()):
      vcl_actt = dxl_tbl.pop('table_iu')
      dxl_cols = dxl_tbl.pop('table_cols')
      if vcl_actt=='i':
        try:
          crsr_sqll.execute(sqls.dml_ti, dxl_tbl)
          conn_sqll.commit()
          print('Table "{}" inserted.'.format(vcl_tbl))
          for dxl_col in dxl_cols.values():
            dxl_col.pop('column_iu')
            try:
              crsr_sqll.execute(sqls.dml_ci, dxl_col)
              conn_sqll.commit()
              print('  Table "{}"; Column "{}" inserted.'.format(vcl_tbl, dxl_col['column_name']))
            except:
              raise
        except:
          raise
      else:
        if vcl_actt=='u':
          try:
            crsr_sqll.execute(sqls.dml_tu, dxl_tbl)
            conn_sqll.commit()
          except:
            print('{}'.format(dxl_tbl))
            raise
        for dxl_col in dxl_cols.values():
          vcl_actc = dxl_col.pop('column_iu')
          if vcl_actc:
            if vcl_actc=='i':
              try:
                crsr_sqll.execute(sqls.dml_ci, dxl_col)
                conn_sqll.commit()
                print('  Table "{}"; Column "{}" inserted.'.format(vcl_tbl, dxl_col['column_name']))
              except:
                raise
            else:
              for vcl_colprop in cols.cols2popc:
                dxl_col.pop(vcl_colprop)
              try:
                crsr_sqll.execute(sqls.dml_cu, dxl_col)
                conn_sqll.commit()
                print('  Table "{}"; Column "{}" updated.'.format(vcl_tbl, dxl_col['column_name']))
              except:
                raise
  else:
    print('{}'.format('Nothing to do.'))

  try:
    crsr_pg.close()
    db_pg.connret(conn_pg)
    crsr_sqll.close()
    conn_sqll.close()
  except:
    raise

#= FUNCTION ============================
# tbls_level
#=======================================
def tbls_level():

# sqllite
  vcl_DML1 = """UPDATE db_tables
  SET table_level=:table_level
  WHERE table_name=:table_name
    AND table_level<>:table_level;"""

  vcl_DML2 = """UPDATE db_tables
  SET table_level=:table_level
  WHERE table_type='v'
    AND table_level<>:table_level;"""

  conn = db_sqll.connect(osp.join(osp.join(moduldir, 'flask_app', 'code', 'procedures'), 'colsx.db'), detect_types=db_sqll.PARSE_COLNAMES|db_sqll.PARSE_DECLTYPES, isolation_level='IMMEDIATE')
  crsr = conn.cursor()
  for vcl_Tbl, dxl_Tbl in sorted(mdl.tbls_scr.items(), key=lambda tnd: (tnd[1].ord, tnd[1].sch, tnd[0])):
    try:
      crsr.execute(vcl_DML1, {'table_level':  dxl_Tbl.ord, 'table_name': vcl_Tbl})
      if crsr.rowcount:
        conn.commit()
        print('Table "{}" level changed.'.format(vcl_Tbl))
    except:
      raise
    try:
      crsr.execute(vcl_DML2, {'table_level':  10})
      if crsr.rowcount:
        conn.commit()
        print('Views level changed.')
    except:
      raise

  try:
    for obj in (crsr, conn):
      obj.close()
  except:
    raise

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# main code
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if __name__=='__main__':

  pass

#---------------------------------------
# global variables
#---------------------------------------

#---------------------------------------
# code
#---------------------------------------

  colsx_update()
  tbls_level()
