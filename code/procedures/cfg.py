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
from config import DATA_PATH, ASSETS_PATH, FRONTEND_IMGS_PATH, DB_PASSWORD

#---------------------------------------
# global variables
#---------------------------------------

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= FUNCTION ============================
# getdirfile
#=======================================
def getdirfile(pi_sdf_id=0):

  """  Get system dirs & files"""

  dcl_sdf = dd(
               {
                'data': DATA_PATH,
                'assets': ASSETS_PATH,
                'reps': osp.join(ASSETS_PATH, 'reports'),
                'imgs': osp.join(DATA_PATH, 'images'),
                'docs': osp.join(DATA_PATH, 'documnents'),
                'ocr': osp.join(DATA_PATH, 'ocr'),
                'pdf': osp.join(DATA_PATH, 'reports', 'pdf'),
               }
              )

  return dcl_sdf

#= FUNCTION ============================
# getpgdb
#=======================================
def getpgdb(pc_password=None, pc_user='postgres', pc_host='localhost', pn_port=5432, pc_dbname='srbolab'):

  """  Get postgres database parameters"""

  dxl_pgdbprms = dd(
                    {
                     'host': pc_host, 
                     'port': str(pn_port), 
                     'database': pc_dbname, 
                     'user': pc_user, 
                     'password': getpwd()
                    }
                   )

  return dxl_pgdbprms

#= FUNCTION ============================
# getpwd
#=======================================
def getpwd():

  """  Get password from file"""

  return DB_PASSWORD

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
            dxl_tblcols[r.table_name] = { 'columns': {} }
          if r.column_name not in dxl_tblcols[r.table_name]['columns']:
            dxl_tblcols[r.table_name]['columns'][r.column_name] = {
                                                                   'label': r.column_label,
                                                                   'header': r.column_header,
                                                                   'tooltip': r.column_tooltip,
                                                                   'show': (r.column_show=='y'),
                                                                   'edit': (r.column_edit=='y'),
                                                                   'fill': (r.column_fill=='y'),
                                                                   'pick': (r.column_pick=='y'),
                                                                   'control': r.column_control,
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
sysdf = getdirfile()


#= FUNCTION ============================
# cols4table
#=======================================
def cols4table(pc_table):

  return cols.get(pc_table, {}).get('columns', {})

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# main code
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if __name__ == '__main__':

  pass

#---------------------------------------
# global variables
#---------------------------------------
#---------------------------------------
# code
#---------------------------------------
