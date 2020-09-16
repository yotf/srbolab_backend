#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import os.path as osp
import psycopg2
import psycopg2.extras
from psycopg2 import pool

from procedures.config import globalv

#---------------------------------------
# global variables
#---------------------------------------
#mdir = osp.abspath(osp.dirname(str(__import__(__name__)).split(' ')[-1].strip("'<>")))


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
      vcl_pwd = self.getpwd()
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
  # getpwd
  #=======================================
  def getpwd(self):
    """  Get password from file"""

    #    vcl_pwd = None
    #    try:
    #      with open(osp.join(mdir, '.pwd'), 'r') as f:
    #        vcl_pwd = f.read().strip()
    #    except:
    #      print('Nema fajla sa lozinkom!')
    #      raise

    #    return vcl_pwd
    return globalv.pgpwd

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
  # col_default
  #=======================================
  def col_default(self, pc_col_default, pc_col_type):

    vxl_col_default = None
    if pc_col_default:
      if pc_col_type == 'c':
        vxl_col_default = pc_col_default
      elif pc_col_type == 'i':
        vxl_col_default = int(pc_col_default)
      elif pc_col_type == 'n':
        vxl_col_default = float(pc_col_default)
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
        vxl_col_checkconst = [int(n) for n in pc_col_checkconst.split(',')]
      elif pc_col_type == 'n':
        vxl_col_checkconst = [float(n) for n in pc_col_checkconst.split(',')]
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
  def tbl_cols(self, pc_schema, pc_table):
    """  Get columns for table in schema"""

    conn = self.connget()
    crsr = conn.cursor()

    lcl_cols = []
    try:
      crsr.callproc('public.f_tbl_cols', [pc_schema, pc_table])
      for rec in crsr:
        lcl_cols.append({
            'order':
            rec['col_ord'],
            'name':
            rec['col_name'],
            'type':
            rec['col_type'][0],
            'length':
            rec['col_length'],
            'decimal':
            rec['col_dec'],
            'isnotnull': (rec['col_is_nn'] == 'Y'),
            'default':
            self.col_default(rec['col_default'], rec['col_type'][0]),
            'checkconst':
            self.col_checkconst(rec['col_check'], rec['col_type'][0]),
            'isprimarykey': (rec['col_is_pk'] == 'Y'),
            'isforeignkey': (rec['col_is_fk'] == 'Y'),
            'comment':
            rec['col_comment'],
            'header':
            globalv.colsx.get(pc_table, {}).get('columns', {}).get(
                rec['col_name'], {}).get('header',
                                         rec['col_name'].split('_', 1)[1]),
            'show':
            globalv.colsx.get(pc_table, {}).get('columns', {}).get(
                rec['col_name'], {}).get('show',
                                         not rec['col_name'].startswith('id_')),
        })
    except:
      raise
    finally:
      crsr.close()
      self.connret(conn)

    return lcl_cols

  #= METHOD ==============================
  # tbls
  #=======================================
  def tbls(self, pc_table=None, pc_schema=None):
    """  Get tables"""

    conn = self.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc('public.f_tbls', [pc_table, pc_schema])
      dcl_tbls = crsr.fetchall()
    except:
      raise
    finally:
      crsr.close()
      self.connret(conn)

    return dcl_tbls

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
