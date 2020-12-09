#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
import json as js

# site-packages
import psycopg2
from box import SBox as dd

# local
from . import util as utl

#---------------------------------------
# global variables
#---------------------------------------

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= CLASS ===============================
# table
#=======================================
class table:

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self, po_db, pc_table):

    self.db = po_db
    self.name = pc_table
    self._init()

  #= METHOD ==============================
  # _init
  #=======================================
  def _init(self):

    dxl_tbl = self.db.tbls(self.name)[0]
    self.schema = dxl_tbl['table_schema']
    self.comment = dxl_tbl['table_comment']
    self.type = dxl_tbl['table_type']
    self.cols, self.primarykey = self.db.tbl_cols(self.name)
    self.fnc = dd({})
    for vcl_act in ('d', 'g', 'iu'):  # d - DELETE; g - SELECT ... (get); iu - INSERT/UPDATE
      self.fnc[vcl_act] = {
                           'name': 'f_{}_{}'.format(self.name, vcl_act),
                           'fullname': '{}.f_{}_{}'.format(self.schema, self.name, vcl_act),
                          }

  #= METHOD ==============================
  # res2dct
  #=======================================
  def res2dct(self, pn_res, pc_res):
    """  Results to dictionary"""

    return { 'rcod': pn_res, 'rmsg': pc_res }

  #= METHOD ==============================
  # tbl_get
  #=======================================
  def tbl_get(self, px_rec={}):
    """  Get data; Returns list of all records fetched"""

    conn = self.db.connget()
    crsr = conn.cursor()
    vxl_res = None
    try:
      crsr.callproc(self.fnc.g.fullname, [utl.py2json(px_rec)])
      vxl_res = crsr.fetchall()
    except:
      raise
    finally:
      conn.commit()
      crsr.close()
      self.db.connret(conn)

    return vxl_res

  #= METHOD ==============================
  # tbl_iu
  #=======================================
  def tbl_iu(self, px_rec):

    """  Insert/Update data; Returns new table ID/number of records updated & message"""

    conn = self.db.connget()
    crsr = conn.cursor()
    vnl_res = -1
    vcl_res = None
    try:
#      print('{}'.format(px_rec))
      crsr.callproc(self.fnc.iu.fullname, [utl.py2json(px_rec)])
      vnl_res = crsr.fetchone()[self.fnc.iu.name]
      if vnl_res is None:
        vnl_res = 1
      if vnl_res:
        vcl_res = self.db.connnotices(conn)
        conn.commit()
    except (psycopg2.errors.UniqueViolation, psycopg2.errors.CheckViolation, psycopg2.errors.NotNullViolation, psycopg2.errors.StringDataRightTruncation) as err:
      vcl_res = err.pgerror.splitlines()[0].split(':', 1)[1].strip()
    except:
      raise
    finally:
      crsr.close()
      self.db.connret(conn)

    return self.res2dct(vnl_res, vcl_res)

  #= METHOD ==============================
  # tbl_insert
  #=======================================
  def tbl_insert(self, px_rec):

    """  Insert data; Returns new tbl_id & message"""

    return self.tbl_iu(px_rec)

  #= METHOD ==============================
  # tbl_update
  #=======================================
  def tbl_update(self, px_rec):

    """  Update data; Returns number of records updated & message"""

    return self.tbl_iu(px_rec)

  #= METHOD ==============================
  # tbl_copy
  #=======================================
  def tbl_copy(self, px_rec):

    """  Insert data; Returns new tbl_id & message"""

    return self.tbl_iu(px_rec)

  #= METHOD ==============================
  # tbl_delete
  #=======================================
  def tbl_delete(self, px_rec):

    """  Delete data; Returns number of records deleted & message"""

    conn = self.db.connget()
    crsr = conn.cursor()
    vnl_res = -1
    vcl_res = None
    try:
      crsr.callproc(self.fnc.d.fullname, [utl.py2json(px_rec)])
      vnl_res = crsr.fetchone()[self.fnc.d.name.format(self.name)]
      if vnl_res:
        vcl_res = self.db.connnotices(conn)
        conn.commit()
    except Exception as err:
      vcl_res = err.pgerror.splitlines()[0].split(':', 1)[1].strip()
#      vcl_res = '{}'.format(err)
    finally:
      crsr.close()
      self.db.connret(conn)

    return self.res2dct(vnl_res, vcl_res)

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
