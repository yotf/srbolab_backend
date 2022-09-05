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
#    print(self.db.tbls)
#    print(self.db.tbls(self.name))
    dxl_tbl = self.db.tbls(self.name)[0]
    self.schema = dxl_tbl['table_schema']
    self.comment = dxl_tbl['table_comment']
    self.type = dxl_tbl['table_type']
    self.cols, self.primarykey = self.db.tbl_cols(self.name)
    self.fnc = dd({})
    for vcl_act in ('d', 'g', 'iu', 'c'):  # d - DELETE; g - SELECT ... (get); iu - INSERT/UPDATE; c - COUNT(*)
      prefix = 'f'
      #TODO, HACK GT
      if(self.name in ['motor', 'korisnik', 'vozilo_sert']):
        prefix = 'f_v'
      self.fnc[vcl_act] = {
                           'name': '{}_{}_{}'.format(prefix, self.name, vcl_act),
                           'fullname': '{}.{}_{}_{}'.format(self.schema, prefix, self.name, vcl_act),
                          }

  #= METHOD ==============================
  # res2dct
  #=======================================
  def res2dct(self, pn_res, pc_res):

    """  Results to dictionary"""

    return {'rcod': pn_res, 'rmsg': pc_res}

  #= METHOD ==============================
  # tbl_get
  #=======================================
  def tbl_get(self, px_rec={}, px_x=None):

    """  Get data; Returns list of all records fetched"""

    conn = self.db.connget()
    crsr = conn.cursor()
    vxl_res = None
    try:
      print('!!! {} - {}'.format(self.fnc.g.fullname, utl.py2json(px_rec)))
      #print('FUNC {}'.format(self.fnc))
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
  def tbl_iu(self, px_rec, px_x=None):

    """  Insert/Update data; Returns new table ID/number of records updated & message"""

    print('INS/UPD {}, {}, {}, {}'.format(self.fnc.iu.fullname, self.fnc, px_rec, px_x))
#    print('>{}<'.format(px_rec))
#    print('>{}<'.format(px_x))
    #TODO, HACK GT, switch month and days, sick
    if(self.fnc.iu.fullname == 'sys.f_v_kalendar_iu' or self.fnc.iu.fullname == 'sys.f_v_raspored_iu'):
      if 'kn_datum' in px_rec:
        oldDate = px_rec['kn_datum']
        px_rec['kn_datum'] = oldDate[3:5]+"."+oldDate[0:2]+"."+oldDate[6:]
    
    conn = self.db.connget()
    crsr = conn.cursor()
    vnl_res = -1
    vcl_res = None
    try:
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

    print('INS/UPD {}, {}'.format(vnl_res, vcl_res))
    return self.res2dct(vnl_res, vcl_res)

  #= METHOD ==============================
  # tbl_insert
  #=======================================
  def tbl_insert(self, px_rec, px_x=None):

    """  Insert data; Returns new tbl_id & message"""
    rez = self.tbl_iu(px_rec, px_x)
    if (rez["rcod"] and rez["rcod"] > 0) or rez["rcod"] == 0:
      self.tbl_ins_change("insert", px_rec, rez["rcod"], px_x)

    return rez

  #= METHOD ==============================
  # tbl_update
  #=======================================
  def tbl_update(self, px_rec, px_x=None):

    """  Update data; Returns number of records updated & message"""
    rez = self.tbl_iu(px_rec, px_x)
    if (rez["rcod"] and rez["rcod"] > 0) or rez["rcod"] == 0:
      self.tbl_ins_change("update", px_rec, rez["rcod"], px_x)

    return rez

  #= METHOD ==============================
  # tbl_copy
  #=======================================
  def tbl_copy(self, px_rec, px_x=None):

    """  Insert data; Returns new tbl_id & message"""

    rez = self.tbl_iu(px_rec, px_x)
    if (rez["rcod"] and rez["rcod"] > 0) or rez["rcod"] == 0:
      self.tbl_ins_change("copy", px_rec, rez["rcod"], px_x)

    return rez


  #= METHOD ==============================
  # tbl_delete
  #=======================================
  def tbl_delete(self, px_rec, px_x=None):

    """  Delete data; Returns number of records deleted & message"""

    #TODO, HACK GT
    del_rec = px_rec
    del_recs = self.tbl_get(px_rec)    
    if del_recs and len(del_recs)>0:
      del_rec = del_recs[0]

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
    finally:
      crsr.close()
      self.db.connret(conn)

    if (vnl_res and vnl_res >= 0):
      self.tbl_ins_change("delete", del_rec, vnl_res, px_x)

    return self.res2dct(vnl_res, vcl_res)


#= METHOD ==============================
  # insert trtack change line
  #=======================================
  def tbl_ins_change(self, oper, px_rec, rcode=-1, px_x=None):

    """  Insert/Update data; Returns new table ID/number of records updated & message"""
    if(px_x and ('kr_id' in px_x)):
      # TODO, HACK GT, to get useraame, should be username = user_service.tbl_get({ "kr_id":
      # user_identity })[0]["kr_username"]
      conn1 = self.db.connget()
      crsr1 = conn1.cursor()
      try:
        crsr1.callproc("sys.f_v_korisnik_g", [utl.py2json(px_x)])
        username = crsr1.fetchall()[0]["kr_username"]
      finally:
        conn1.commit()
        self.db.connret(conn1)

    opis = ""
    for key in px_rec.keys():
      if 'naziv' in key:
        if px_rec[key]:
          opis += " "+px_rec[key]
    if len(opis)>100:
      opis = opis[:99]

    achange = { 'izm_tbl':self.name, 'izm_oper':oper, 'izm_opis':opis.lstrip(), 'izm_user':username}
    #print('TRACK INS {}, {}, {}, {}, {}'.format(oper, rcode, px_rec, px_x, achange))
    conn = self.db.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc("hmlg.f_izmene_i", [utl.py2json(achange)])
      conn.commit()
    #ignore exceptions
    #except:
    #  raise
    finally:
      crsr.close()
      self.db.connret(conn)

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
