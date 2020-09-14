#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import json as js
import psycopg2
from box import SBox as dd
from pgdb import pgdb

#---------------------------------------
# global variables
#---------------------------------------
db = pgdb()

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
  def __init__(self, pc_schema, pc_table):

    self.schema = pc_schema
    self.name = pc_table
    self.colsl, self.colsd = db.tbl_cols(self.schema, self.name)
    self.fnc = dd({})
    for vcl_act in ('d', 'g', 'iu'):
      self.fnc[vcl_act] = {
                           'n': 'f_{}_{}'.format(self.name, vcl_act),
                           'sn': '{}.f_{}_{}'.format(self.schema, self.name, vcl_act),
                          }

  #= METHOD ==============================
  # res2dct
  #=======================================
  def res2dct(self, pn_res, pc_res):

    return {'rcod': pn_res, 'rmsg': pc_res}

  #= METHOD ==============================
  # prm2json
  #=======================================
  def prm2json(self, pd_row):

    return js.dumps(pd_row)

  #= METHOD ==============================
  # tbl_g
  #=======================================
  def tbl_g(self, *px_prms):

    """  Get data; Returns json object"""

    conn = db.connget()
    crsr = conn.cursor()
    vxl_res = None
    try:
      crsr.callproc(self.fnc.g.sn, list(px_prms))
      vxl_res = crsr.fetchall()
    except:
      raise
    finally:
      conn.commit()
      crsr.close()
      db.connret(conn)

    return vxl_res

  #= METHOD ==============================
  # tbl_iu
  #=======================================
  def tbl_iu(self, pi_iu, px_rec):

    """  Insert/Update data; Returns new tbl_id/number of records updated & message"""

    conn = db.connget()
    crsr = conn.cursor()
    vnl_res = -1
    vcl_res = None
    try:
      crsr.callproc(self.fnc.iu.sn, [pi_iu, self.prm2json(px_rec)])
      vnl_res = crsr.fetchone()[self.fnc.iu.n]
      if vnl_res:
        vcl_res = db.connntc(conn)
        conn.commit()
    except (psycopg2.errors.UniqueViolation, psycopg2.errors.CheckViolation) as err:
      vcl_res = err.pgerror.splitlines()[0].split(':', 1)[1].strip()
    except:
      raise
    finally:
      crsr.close()
      db.connret(conn)

    return self.res2dct(vnl_res, vcl_res)

  #= METHOD ==============================
  # tbl_i
  #=======================================
  def tbl_i(self, px_rec):

    """  Insert data; Returns new tbl_id & message"""

    return self.tbl_iu(0, px_rec)

  #= METHOD ==============================
  # tbl_u
  #=======================================
  def tbl_u(self, px_rec):

    """  Update data; Returns number of records updated & message"""

    return self.tbl_iu(1, px_rec)

  #= METHOD ==============================
  # tbl_d
  #=======================================
  def tbl_d(self, *pl_prms):

    """  Delete data; Returns number of records deleted & message"""

    conn = db.connget()
    crsr = conn.cursor()
    vnl_res = -1
    vcl_res = None
    try:
      crsr.callproc(self.fnc.d.sn, list(pl_prms))
      vnl_res = crsr.fetchone()[self.fnc.d.n.format(self.name)]
      if vnl_res:
        vcl_res = db.connntc(conn)
        conn.commit()
    except Exception as err:
      vcl_res = '{}'.format(err)
    finally:
      crsr.close()
      db.connret(conn)

    return self.res2dct(vnl_res, vcl_res)

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
