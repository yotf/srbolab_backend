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

#---------------------------------------
# global variables
#---------------------------------------

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= FUNCTION ============================
# form
#=======================================
def form(po_db, pi_afo_id):

  if pi_afo_id==430:
    return predmeti(po_db)
  elif pi_afo_id==420:
    return vozila(po_db)
  else:
    return None

#= CLASS ===============================
# predmeti
#=======================================
class predmeti:

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self, po_db):

    self.db = po_db
    self._init()

  #= METHOD ==============================
  # _init
  #=======================================
  def _init(self):

    self.col_fnc = {
                    'kl_naziv': {
                                 'fnc': 'hmlg.f_klijent_g',
                                 'cols': ['kl_naziv'],
                                 'chars': 3,
                                 'table': {
                                           'name': 'klijent',
                                           'cols': [],
                                          },
                                },
                    'vz_sasija': {
                                  'fnc': 'sif.f_c_marka_oznaka',
                                  'cols': ['text'],
                                  'chars': 3,
                                 },
                    'mr_naziv': {
                                 'fnc': 'sif.f_marka_g',
                                 'cols': ['mr_naziv'],
                                 'chars': 1,
                                 'table': {
                                           'name': 'marka',
                                           'cols': [],
                                          },
                               },
                    'md_naziv_k': {
                                   'fnc': 'sif.f_marka_g',
                                   'cols': ['mr_id', 'md_naziv_k'],
                                   'chars': 1,
                                   'table': {
                                             'name': 'model',
                                             'cols': [],
                                            },
                                  },
                    'vzpv_oznaka': {
                                    'fnc': 'sif.f_vozilo_podvrsta_g',
                                    'cols': ['vzpv_oznaka'],
                                    'chars': 1,
                                   },
                    'vzk_oznaka': {
                                  'fnc': 'sif.f_v_vzpv_vzk_g',
                                  'cols': ['vzpv_id', 'vzk_oznaka'],
                                  'chars': 1,
                                  },
                    'vzdo_oznaka': {
                                    'fnc': 'sif.sif.f_v_vzv_vzdo_g',
                                    'cols': ['vzv_id', 'vzdo_oznaka'],
                                    'chars': 1,
                                   },
                    'vzkl_oznaka': {
                                    'fnc': 'sif.f_v_vzpv_vzkl_g',
                                    'cols': ['vzpv_id', 'vzkl_naziv'],
                                    'chars': 1,
                                   },
                    'mdt_oznaka': {
                                   'fnc': 'sif.f_model_tip_g',
                                   'cols': ['mdt_oznaka'],
                                   'chars': 1,
                                   'fnc1': 'sif.f_c_marka_model_tip_var_ver',
                                   'cols1': ['text', 'mr_id', 'md_id', 'mdt_id', 'mdvr_id', 'mdvz_id', 'mt_id',],
                                   'chars1': 3,
                                   'table': {
                                             'name': 'model_tip',
                                             'cols': [],
                                            },
                              },
                    'mdvr_oznaka': {
                                    'fnc': 'sif.f_model_varijanta_g',
                                    'cols': ['mdvr_oznaka'],
                                    'chars': 1,
                                    'fnc1': 'sif.f_c_marka_model_tip_var_ver',
                                    'cols1': ['text', 'mr_id', 'md_id', 'mdt_id', 'mdvr_id', 'mdvz_id', 'mt_id',],
                                    'chars1': 3,
                                    'table': {
                                              'name': 'model_varijanta',
                                              'cols': [],
                                             },
                                   },
                    'mdvz_oznaka': {
                                    'fnc': 'sif.f_model_verzija_g',
                                    'cols': ['mdvz_oznaka'],
                                    'chars': 1,
                                    'fnc1': 'sif.f_c_marka_model_tip_var_ver',
                                    'cols1': ['text', 'mr_id', 'md_id', 'mdt_id', 'mdvr_id', 'mdvz_id', 'mt_id',],
                                    'chars': 3,
                                    'table': {
                                              'name': 'model_verzija',
                                              'cols': [],
                                             },
                                   },
                    'mt_oznaka': {
                                  'fnc': 'sif.f_model_verzija_g',
                                  'cols': ['mt_oznaka'],
                                  'chars': 1,
                                  'fnc1': 'sif.f_c_marka_model_tip_var_ver_motor',
                                  'cols1': ['text', 'mr_id', 'md_id', 'mdt_id', 'mdvr_id', 'mdvz_id', 'mt_id',],
                                  'chars': 3,
                                  'table': {
                                            'name': 'motor',
                                            'cols': [],
                                           },
                                 },
                    'gr_naziv': {
                                 'fnc': 'sif.f_gorivo_g',
                                 'cols': ['gr_naziv'],
                                 'chars': 1,
                                },
                    'em_naziv': {
                                 'fnc': 'sif.f_emisija_g',
                                 'cols': ['em_naziv'],
                                 'chars': 1,
                                },
                   }
    for vcl_col, dcl_col in self.col_fnc.items():
      vcl_table = dcl_col.get('table', None)
      if vcl_table:
        self.col_fnc[vcl_col]['table']['cols'] = [{'name': dc['name'], 'isnotnull': dc['isnotnull']} for dc in self.db.tbl_cols(self.col_fnc[vcl_col]['table']['name'])[0]]

  #= METHOD ==============================
  # res2dct
  #=======================================
  def res2dct(self, pn_res, pc_res):

    """  Results to dictionary"""

    return { 'rcod': pn_res, 'rmsg': pc_res }

  #= METHOD ==============================
  # prm2dct
  #=======================================
  def prm2dct(self, px_rec):

    """  Parameters to dict"""

    try:
      px_rec.get('~')
    except AttributeError:
      px_rec = js.loads(px_rec)

    return px_rec

  #= METHOD ==============================
  # prm2json
  #=======================================
  def prm2json(self, pd_row):

    """  Parameters to json"""

    return js.dumps(pd_row)

  #= METHOD ==============================
  # data_get
  #=======================================
  def data_get(self, pc_fnc, px_rec):

    """  Get data; Returns list of all records fetched"""

    conn = self.db.connget()
    crsr = conn.cursor()
    vxl_res = None
    try:
      crsr.callproc(pc_fnc, [self.prm2json(px_rec)])
      vxl_res = crsr.fetchall()
    except:
      raise
    finally:
      conn.commit()
      crsr.close()
      self.db.connret(conn)

    return vxl_res

  #= METHOD ==============================
  # data_ins
  #=======================================
  def data_ins(self, pc_fnc, px_rec):

    """  Insert data; Returns new tbl_id & message"""

    conn = self.db.connget()
    crsr = conn.cursor()
    vnl_res = -1
    vcl_res = None
    vcl_fnc = (pc_fnc.split('.', 1)[1] if '.' in pc_fnc else pc_fnc)
    try:
      crsr.callproc(pc_fnc, [self.prm2json(px_rec)])
      vnl_res = crsr.fetchone()[vcl_fnc]
      if vnl_res:
        vcl_res = self.db.connnotices(conn)
        conn.commit()
    except (psycopg2.errors.UniqueViolation, psycopg2.errors.CheckViolation) as err:
      vcl_res = err.pgerror.splitlines()[0].split(':', 1)[1].strip()
    except:
      raise
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
