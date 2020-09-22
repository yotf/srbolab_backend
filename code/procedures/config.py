#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import sys
import os
import os.path as osp
import sqlite3 as sqll

from box import SBox as dd

#---------------------------------------
# global variables
#---------------------------------------
globalv = dd({})
globalv['moduldir'] = osp.abspath(osp.dirname(str(__import__(__name__)).split(' ')[-1].strip("'<>")))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= METHOD ==============================
# getpwd
#=======================================
def getpwd():

  """  Get password from file"""

  vcl_pwd = None
  try:
    with open(osp.join(globalv.moduldir, '.pwd'), 'r') as f:
      vcl_pwd = f.read().strip()
  except:
    print('Nema fajla sa lozinkom!')
    raise

  return vcl_pwd

#= FUNCTION ============================
# colsx
#=======================================
def colsx():

  dxl_tblcols = dd({})
  vcl_colsxf = osp.join(globalv.moduldir, 'colsx.db')
  if osp.exists(vcl_colsxf):
    lcl_cols = ['table_name', 'column_name', 'column_order', 'column_type', 'column_length', 'column_dec', 'column_is_nn', 'column_default', 'column_check', 'column_is_pk', 'column_is_fk', 'table_name_p', 'column_name_p', 'column_comment', 'column_label', 'column_header', 'column_tooltip', 'column_show', 'column_edit', 'column_control']
    vcl_sql = """SELECT c.{}
    FROM db_columns c
    ORDER BY c.table_name, c.column_order;""".format(',\n       c.'.join(lcl_cols))
    try:
      conn = sqll.connect(vcl_colsxf, detect_types=sqll.PARSE_COLNAMES|sqll.PARSE_DECLTYPES, isolation_level='IMMEDIATE')
      crsr = conn.cursor()
      try:
        crsr.execute(vcl_sql)
        for r in crsr:
          r = dd(dict(zip(lcl_cols, r)))
          if r.table_name not in dxl_tblcols:
            dxl_tblcols[r.table_name] = {
                                         'columns': {}
                                        }
          if r.column_name not in dxl_tblcols[r.table_name]['columns']:
            dxl_tblcols[r.table_name]['columns'][r.column_name] = {
                                                                   'order': r.column_order,
                                                                   'comment':  r.column_comment,
                                                                   'label':  r.column_label,
                                                                   'header':  r.column_header,
                                                                   'tooltip':  r.column_tooltip,
                                                                   'show':  (r.column_show=='y'),
                                                                   'edit':  (r.column_edit=='y'),
                                                                   'control':  r.column_control,
                                                                  }
      except:
        raise
      finally:
        crsr.close()
        conn.close()
    except:
      raise
  else:
    print('Nema fajla sa kolonama!')

  return dxl_tblcols

#= FUNCTION ============================
# _colsx
#=======================================
def _colsx():

  dxl_tblcols = dd({})
  vcl_colsxf = osp.join(globalv.moduldir, 'colsx.txt')
  if osp.exists(vcl_colsxf):
    try:
      with open(vcl_colsxf, 'r') as fr:
        for vcl_ln in fr:
          lcl_ln = vcl_ln.strip('\n\r').split('\t')
          vcl_tbl = lcl_ln[1]
          vcl_col = lcl_ln[2]
          if vcl_tbl not in dxl_tblcols:
            dxl_tblcols[vcl_tbl] = {
                                    'schema': lcl_ln[0],
                                    'columns': {},
                                   }
          if vcl_col not in dxl_tblcols[vcl_tbl]['columns']:
            dxl_tblcols[vcl_tbl]['columns'][vcl_col] = {
                                                        'order': int(lcl_ln[3]),
                                                        'comment':  lcl_ln[4],
                                                        'label':  lcl_ln[5],
                                                        'header':  (lcl_ln[6] if lcl_ln[6] else None),
                                                        'tooltip':  lcl_ln[7],
                                                        'show':  (lcl_ln[8]=='Y'),
                                                       }
    except:
      raise
  else:
    print('Nema fajla sa kolonama!')

  return dxl_tblcols

globalv['pgpwd'] = getpwd()
globalv['colsx'] = colsx()

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
