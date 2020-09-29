#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
import os.path as osp
import sqlite3 as sqll

# site-packages
from box import SBox as dd

#---------------------------------------
# global variables
#---------------------------------------

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
    with open(osp.join(osp.dirname(__file__), '.pwd'), 'r') as f:
      vcl_pwd = f.read().strip()
  except FileNotFoundError:
    print('Nema fajla sa lozinkom!')
  except:
    raise

  return vcl_pwd

#= FUNCTION ============================
# getcols
#=======================================
def getcols():

  dxl_tblcols = dd({})
  vcl_colsxf = osp.join(osp.dirname(__file__), 'colsx.db')
  if osp.exists(vcl_colsxf):
    lcl_cols = ['table_name', 'column_name', 'column_order', 'column_type', 'column_length', 'column_dec', 'column_is_nn', 'column_default', 'column_check', 'column_is_pk', 'column_is_fk', 'table_name_p', 'column_name_p', 'column_comment', 'column_label', 'column_header', 'column_tooltip', 'column_show', 'column_edit', 'column_fill', 'column_pick', 'column_control']
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
                                                                   'label':  r.column_label,
                                                                   'header':  r.column_header,
                                                                   'tooltip':  r.column_tooltip,
                                                                   'show':  (r.column_show=='y'),
                                                                   'edit':  (r.column_edit=='y'),
                                                                   'fill':  (r.column_fill=='y'),
                                                                   'pick':  (r.column_pick=='y'),
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

cols = getcols()

#= FUNCTION ============================
# cols4table
#=======================================
def cols4table(pc_table):

  return cols.get(pc_table, {}).get('columns', {})

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
