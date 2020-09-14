#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports __future__
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#from __future__ import print_function
#from __future__ import division
#from __future__ import unicode_literals
#from __future__ import absolute_import

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import json as js
from table import db, table
from box import SBox as dd

#---------------------------------------
# global variables
#---------------------------------------
tbls = dd({})
tbls['emisija'] = {
                   'sch': 'sif',
                   'rn': {'em_id': 0, 'em_naziv': '7 (Седам)'},
                   'ru': {'em_id': None, 'em_naziv': '8 (Осам)'},
                   'pk': 'em_id',
                  }
tbls['gorivo'] = {
                  'sch': 'sif',
                  'rn': {'gr_id': 0, 'gr_naziv': 'Угаљ'},
                  'ru': {'gr_id': None, 'gr_naziv': 'Шљака'},
                  'pk': 'gr_id',
                 }
tbls['lokacija'] = {
                    'sch': 'sys',
                    'rn': {'lk_id': 0, 'lk_naziv': 'Нови Сад', 'lk_naziv_l': 'Новом Саду', 'lk_ip': '192.168.1.55', 'lk_aktivna': 'D'},
                    'ru': {'lk_id': None, 'lk_naziv': 'Нови Сад', 'lk_naziv_l': 'Новом Саду', 'lk_ip': '192.168.1.66', 'lk_aktivna': 'N'},
                    'pk': 'lk_id',
                   }
tbls['organizacija'] = {
                        'sch': 'sif',
                        'rn': {'org_id': 0, 'org_naziv': 'ЈКПИ', 'org_napomena': 'Бла, бла, ...'},
                        'ru': {'org_id': None, 'org_naziv': 'ЈКПИ', 'org_napomena': 'Трт мрт'},
                        'pk': 'org_id',
                       }
tbls['vozilo_karoserija'] = {
                             'sch': 'sif',
                             'rn': {'vzk_id': 0, 'vzk_oznaka': 'XX', 'vzk_naziv': 'Баги'},
                             'ru': {'vzk_id': None, 'vzk_oznaka': 'XX', 'vzk_naziv': 'Кросовер'},
                             'pk': 'vzk_id',
                            }
tbls['vozilo_klasa'] = {
                        'sch': 'sif',
                        'rn': {'vzkl_id': 0, 'vzkl_oznaka': 'M', 'vzkl_naziv': 'Klasa M'},
                        'ru': {'vzkl_id': None, 'vzkl_oznaka': 'M', 'vzkl_naziv': 'Klasa X'},
                        'pk': 'vzkl_id',
                       }
tbls['vozilo_vrsta'] = {
                        'sch': 'sif',
                        'rn': {'vzv_id': 0, 'vzv_oznaka': 'A', 'vzv_naziv': 'Тротинети'},
                        'ru': {'vzv_id': None, 'vzv_oznaka': 'A', 'vzv_naziv': 'Ромобили'},
                        'pk': 'vzv_id',
                       }
tbls['ag_proizvodjac'] = {
                          'sch': 'sif',
                          'rn': {'agp_id': 0, 'agp_naziv': 'NS AUTOGAS', 'agp_napomena': None},
                          'ru': {'agp_id': None, 'agp_naziv': 'NS AUTOGAS', 'agp_napomena': 'Napomena'},
                          'pk': 'agp_id',
                         }
tbls['ag_homologacija'] = {
                           'sch': 'sif',
                           'rn': {'agh_id': 0, 'agh_oznaka': '123 456 789', 'agh_uredjaj': 'MV'},
                           'ru': {'agh_id': None, 'agh_oznaka': '123 456 789', 'agh_uredjaj': 'RD'},
                           'pk': 'agh_id',
                          }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= FUNCTION ============================
# res2obj
#=======================================
def res2obj(pd_res):

  return dd(pd_res)

#= FUNCTION ============================
# t00
#=======================================
def t00(pc_tbl):

  vcl_tbl = pc_tbl.lower()
  if vcl_tbl not in tbls:
    return

  td = tbls[vcl_tbl]
  t = table(td.sch, vcl_tbl)

  #= FUNCTION ============================
  # tbl_g
  #=======================================
  def tbl_g(pc_msg, pn_t_id=None):

    print('\n# {}'.format(pc_msg))
    res = t.tbl_g(pn_t_id)
    if res:
      for r in res:
        print('  {}'.format(dict(r)))
    else:
      print('  Nema sloga sa ID-om {}.'.format(vnl_t_id))

  #= FUNCTION ============================
  # tbl_i
  #=======================================
  def tbl_i():

    print('\n# {}'.format('insert new record'))
    dxl_row = td.rn
    print('  {}'.format(dxl_row))
    res = res2obj(t.tbl_i(dxl_row))
    vnl_t_id = res.rcod
    if vnl_t_id<0:
      print('  Greška: {}'.format(res.rmsg))
    else:
      print('  New id: {rcod}; {rmsg}'.format(**res))
      # get tbl_id=new tbl_id
      tbl_g('get new record', vnl_t_id)

    return vnl_t_id

  #= FUNCTION ============================
  # tbl_u
  #=======================================
  def tbl_u(pn_t_id):

    # update tbl_id=new tbl_id
    print('\n# {}'.format('update new record'))
    td.ru[td.pk] = pn_t_id
    dxl_row = td.ru
    print('  {}'.format(dxl_row))
    res = res2obj(t.tbl_u(dxl_row))
    if res.rcod<0:
      print('  Greška: {}'.format(res.rmsg))
    else:
      print('  Updated records: {rcod}; {rmsg}'.format(**res))
      # get tbl_id=new tbl_id
      tbl_g('get updated new record', pn_t_id)

    return res

  #= FUNCTION ============================
  # tbl_d
  #=======================================
  def tbl_d(pn_t_id):

    # delete tbl_id=new tbl_id
    print('\n# {}'.format('delete new record'))
    res = res2obj(t.tbl_d(pn_t_id))
    print('  Deleted records: {rcod}; {rmsg}'.format(**res))
    # get tbl_id=new tbl_id
    tbl_g('get new record', pn_t_id)

# table
  print('## {}'.format('Table info'))
  print('  Schema: {}\n  Name: {}\n  Column names: {}\n  Column types: {}'.format(t.schema, t.name, t.colsl, [t.colsd[c]['typ'] for c in t.colsl]))
# get all
  tbl_g('get all')
# insert ...
  vnl_t_id = tbl_i()
  if vnl_t_id>0:
#   update tbl_id=new tbl_id
    res = tbl_u(vnl_t_id)
    if res.rcod>0:
#     delete tbl_id=new tbl_id
      tbl_d(vnl_t_id)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# main code
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if __name__=='__main__':

  pass

#---------------------------------------
# global variables
#---------------------------------------

  lcg_tbls = [
              'emisija',
              'gorivo',
              'lokacija',
              'organizacija',
              'vozilo_karoserija',
              'vozilo_klasa',
              'vozilo_vrsta',
              'ag_proizvodjac',
              'ag_homologacija',
             ]

#---------------------------------------
# code
#---------------------------------------

  try:
    for vcg_tbl in lcg_tbls[-2:]:
#    t00(lcg_tbls[7])
      t00(vcg_tbl)
      print()
  except IndexError:
    print('List index out of range.')
