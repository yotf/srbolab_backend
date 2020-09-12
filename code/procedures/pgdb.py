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

#---------------------------------------
# global variables
#---------------------------------------
mdir = osp.dirname(str(__import__(__name__)).split(' ')[-1].strip("'<>"))

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
  def __init__(self, pc_password=None, pc_user='postgres', pc_host='localhost', pn_port=5432, pc_dbname='srbolab'):

    if pc_password:
      vcl_pwd = pc_password
    else:
      vcl_pwd = self.getpwd()
    self.dsn = 'user={} password={} host={} port={} dbname={}'.format(pc_user, vcl_pwd, pc_host, pn_port, pc_dbname)
    self.ccpool()

  #= METHOD ==============================
  # __del__
  #=======================================
  def __del__(self):

    """  Close connection pool"""

    if self.cpool:
      self.cpool.closeall()

  #= METHOD ==============================
  # getpwd
  #=======================================
  def getpwd(self):

    """  Get password from file"""

    vcl_pwd = None
    try:
      with open(osp.join(mdir, '.pwd'), 'r') as f:
        vcl_pwd = f.read().strip()
    except:
      print('Nema fajla sa lozinkom!')
      raise

    return vcl_pwd

  #= METHOD ==============================
  # ccpool
  #=======================================
  def ccpool(self):

    """  Create connection pool"""

    try:
      self.cpool = psycopg2.pool.SimpleConnectionPool(1, 20, self.dsn, cursor_factory=psycopg2.extras.RealDictCursor)
    except (Exception, psycopg2.DatabaseError) as error:
      print('Error while connecting to PostgreSQL', error)

  #= METHOD ==============================
  # connget
  #=======================================
  def connget(self):

    """  Get connection from connection pool"""

    return self.cpool.getconn()

  #= METHOD ==============================
  # connret
  #=======================================
  def connret(self, po_conn):

    """  Return connection to connection pool"""

    self.cpool.putconn(po_conn)

  #= METHOD ==============================
  # connntc
  #=======================================
  def connntc(self, po_conn):

    """  Return connection notice"""

    return po_conn.notices[-1].split(':', 1)[1].strip()

  #= METHOD ==============================
  # connntcs
  #=======================================
  def connntcs(self, po_conn):

    """  Return connection notices"""

    return po_conn.notices

  #= METHOD ==============================
  # tbl_cols_arr
  #=======================================
  def tbl_cols_arr(self, pc_schema, pc_table):

    """  Get column names/types for table in schema"""

    conn = self.connget()
    crsr = conn.cursor()
    lcl_col_nt = []
    try:
      crsr.callproc('f_tbl_cols_nt_arr', [pc_schema, pc_table])
      vcl_res = crsr.fetchone()['f_tbl_cols_nt_arr']
      lcl_col_nt = [s.split(',') for s in  vcl_res.split('#')]
    except:
      raise
    finally:
      crsr.close()
      self.connret(conn)

    return lcl_col_nt

  #= METHOD ==============================
  # tbls
  #=======================================
  def tbls(self, pc_schema=None):

    """  Get tables"""

    conn = self.connget()
    crsr = conn.cursor()
    vcl_sql = """SELECT t.tbl_name,
       t.sch_name
  FROM public.f_tbls(%s) t;"""
    try:
      crsr.execute(vcl_sql, [pc_schema])
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
    vnl_rc = 0
    vcl_sql = """SELECT COUNT(*) AS rc
  FROM {}.{};""".format(pc_schema, pc_table)
    try:
      crsr.execute(vcl_sql, [pc_schema])
      vnl_rc = crsr.fetchone()['rc']
    except:
      raise
    finally:
      crsr.close()
      self.connret(conn)

    return vnl_rc

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
