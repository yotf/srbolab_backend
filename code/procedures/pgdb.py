#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
import os.path as osp

# site-packages
import psycopg2
import psycopg2.extras
from psycopg2 import pool

from . import util as utl
# local
from .cfg import cols4table, getpwd

#---------------------------------------
# global variables
#---------------------------------------


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= CLASS ===============================
# pgdb
#=======================================
class pgdb:

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self,
               pc_password=None,
               pc_user='postgres',
               pc_host='localhost',
               pn_port=5432,
               pc_dbname='srbolab'):

    if pc_password:
      vcl_pwd = pc_password
    else:
      vcl_pwd = getpwd()
    self.dsn = 'user={} password={} host={} port={} dbname={}'.format(
        pc_user, vcl_pwd, pc_host, pn_port, pc_dbname)
    self.createconnpool()

  #= METHOD ==============================
  # __del__
  #=======================================
  def __del__(self):
    """  Close connection pool"""

    if self.connpool:
      self.connpool.closeall()

  #= METHOD ==============================
  # createconnpool
  #=======================================
  def createconnpool(self):
    """  Create connection pool"""

    try:
      self.connpool = psycopg2.pool.SimpleConnectionPool(
          1, 20, self.dsn, cursor_factory=psycopg2.extras.RealDictCursor)
    except (Exception, psycopg2.DatabaseError) as error:
      print('Error while connecting to PostgreSQL', error)

  #= METHOD ==============================
  # connget
  #=======================================
  def connget(self):
    """  Get connection from connection pool"""

    return self.connpool.getconn()

  #= METHOD ==============================
  # connret
  #=======================================
  def connret(self, po_conn):
    """  Return connection to connection pool"""

    self.connpool.putconn(po_conn)

  #= METHOD ==============================
  # connnotices
  #=======================================
  def connnotices(self, po_conn):
    """  Return connection notice"""

    vcl_notice = ''
    if po_conn.notices:
      vcl_notice = po_conn.notices[-1].split(':', 1)[1].strip()
    po_conn.notices = []

    return vcl_notice

  #= METHOD ==============================
  # tbls
  #=======================================
  def tbls(self, pc_table=None):
    """  Get tables"""

    ldl_tbls = []
    conn = self.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc('public.f_tbls', [pc_table])
      ldl_tbls = crsr.fetchall()
    except:
      raise
    finally:
      crsr.close()
      self.connret(conn)

    return ldl_tbls

  #= METHOD ==============================
  # col_default
  #=======================================
  def col_default(self, pc_col_default, pc_col_type):

    vxl_col_default = pc_col_default
    if pc_col_default:
      if pc_col_type == 'c':
        pass
      elif pc_col_type == 'i':
        vxl_col_default = int(vxl_col_default)
      elif pc_col_type == 'n':
        vxl_col_default = float(vxl_col_default)
      elif pc_col_type == 'd':
        pass
      elif pc_col_type == 't':
        pass
      else:
        pass

    return vxl_col_default

  #= METHOD ==============================
  # col_checkconst
  #=======================================
  def col_checkconst(self, pc_col_checkconst, pc_col_type):

    vxl_col_checkconst = None
    if pc_col_checkconst:
      if pc_col_type == 'c':
        vxl_col_checkconst = pc_col_checkconst.split(',')
      elif pc_col_type == 'i':
        vxl_col_checkconst = [(n) for n in pc_col_checkconst.split(',')]
      elif pc_col_type == 'n':
        vxl_col_checkconst = [(n) for n in pc_col_checkconst.split(',')]
      elif pc_col_type == 'd':
        pass
      elif pc_col_type == 't':
        pass
      else:
        pass

    return vxl_col_checkconst

  #= METHOD ==============================
  # tbl_cols
  #=======================================
  def tbl_cols(self, pc_table):
    """  Get columns for table in schema"""

    conn = self.connget()
    crsr = conn.cursor()

    lcl_cols = []
    lcl_pk_cols = []
    try:
      crsr.callproc('public.f_tbl_cols', [pc_table])
      dxl_cols = cols4table(pc_table)
      for rec in crsr:
        vcl_col_name = rec['column_name']
        if rec['column_type'] == 'text':
          if 'datum' in vcl_col_name:
            vcl_col_type = 'd'
          else:
            vcl_col_type = 'c'
        elif rec['column_type'] == 'double precision':
          vcl_col_type = 'n'
        else:
          vcl_col_type = rec['column_type'][0]
        if rec['column_is_pk'] == 'Y':
          lcl_pk_cols.append(vcl_col_name)
        lcl_cols.append({
            'name':
            vcl_col_name,
            'order':
            rec['column_order'],
            'type':
            vcl_col_type,
            'length':
            rec['column_length'],
            'decimal':
            rec['column_dec'],
            'isnotnull': (rec['column_is_nn'] == 'Y'),
            'default':
            self.col_default(rec['column_default'], vcl_col_type),
            'checkconst':
            self.col_checkconst(rec['column_check'], vcl_col_type),
            'isprimarykey': (rec['column_is_pk'] == 'Y'),
            'isforeignkey': (rec['column_is_fk'] == 'Y'),
            'comment':
            rec['column_comment'],
            'parenttable':
            rec['table_name_p'],
            'parentcolumn':
            rec['column_name_p'],
            'label':
            dxl_cols.get(vcl_col_name, {}).get('label', rec['column_comment']),
            'tooltip':
            dxl_cols.get(vcl_col_name, {}).get('tooltip',
                                               rec['column_comment']),
            'header':
            dxl_cols.get(vcl_col_name, {}).get('header',
                                               vcl_col_name.split('_', 1)[1]),
            'show':
            dxl_cols.get(vcl_col_name,
                         {}).get('show', not vcl_col_name.endswith('_id')),
            'edit':
            dxl_cols.get(vcl_col_name,
                         {}).get('edit', not vcl_col_name.endswith('_id')),
            'fill':
            dxl_cols.get(vcl_col_name,
                         {}).get('fill', not vcl_col_name.endswith('_id')),
            'pick':
            dxl_cols.get(vcl_col_name, {}).get('pick', False),
            'control':
            dxl_cols.get(vcl_col_name, {}).get('control', 'text'),
        })
    except:
      raise
    finally:
      crsr.close()
      self.connret(conn)

    return (lcl_cols, lcl_pk_cols)

  #= METHOD ==============================
  # tbl_rec_cnt
  #=======================================
  def tbl_rec_cnt(self, pc_schema, pc_table):
    """  Get table record count"""

    conn = self.connget()
    crsr = conn.cursor()
    vil_reccount = 0
    vcl_sql = """SELECT COUNT(*) AS rc
  FROM {}.{};""".format(pc_schema, pc_table)
    try:
      crsr.execute(vcl_sql, [pc_schema])
      vil_reccount = crsr.fetchone()['rc']
    except:
      raise
    finally:
      crsr.close()
      self.connret(conn)

    return vil_reccount

  #= METHOD ==============================
  # user_forms
  #=======================================
  def user_forms(self, pi_kr_id):
    """  Get application forms for user"""

    ldl_apps = []
    conn = self.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc('public.f_app', [pi_kr_id])
      ldl_apps = crsr.fetchall()
    except:
      raise
    finally:
      crsr.close()
      self.connret(conn)

    return ldl_apps

  #= METHOD ==============================
  # user_login
  #=======================================
  def user_login(self, px_rec={}):
    """  Get application forms for user"""

    vil_kr_id = -900
    conn = self.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc('adm.f_adm_login', [utl.py2json(px_rec)])
      vil_kr_id = crsr.fetchone()['f_adm_login']
      """
      vil_kr_id:
         >=0 -- ok
         -100 -- invalid username or password
         -200 -- user is not active
         -900 -- unknown error
      """

    except:
      raise
    finally:
      crsr.close()
      self.connret(conn)

    return vil_kr_id


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
