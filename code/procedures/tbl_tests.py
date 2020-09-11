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
                   'rn': '{"em_id": 0, "em_naziv": "7 (Седам)"}',
                   'ru': '{{"em_id": {}, "em_naziv": "8 (Осам)"}}',
                  }
tbls['gorivo'] = {
                  'sch': 'sif',
                  'rn': '{"gr_id": 0, "gr_naziv": "Угаљ"}',
                  'ru': '{{"gr_id": {}, "gr_naziv": "Шљака"}}',
                 }
tbls['lokacija'] = {
                    'sch': 'sys',
                    'rn': '{"lk_id": 0, "lk_naziv": "Нови Сад", "lk_naziv_l": "Новом Саду", "lk_ip": "192.168.1.55", "lk_aktivna": "D"}',
                    'ru': '{{"lk_id": {}, "lk_naziv": "Нови Сад", "lk_naziv_l": "Новом Саду", "lk_ip": "192.168.1.66", "lk_aktivna": "N"}}',
                   }
tbls['organizacija'] = {
                        'sch': 'sif',
                        'rn': '{"org_id": 0, "org_naziv": "ЈКПИ", "org_napomena": "Бла, бла, ..."}',
                        'ru': '{{"org_id": {}, "org_naziv": "ЈКПИ", "org_napomena": "Трт мрт"}}',
                       }
tbls['vozilo_karoserija'] = {
                             'sch': 'sif',
                             'rn': '{"vzk_id": 0, "vzk_oznaka": "XX", "vzk_naziv": "Баги"}',
                             'ru': '{{"vzk_id": {}, "vzk_oznaka": "XX", "vzk_naziv": "Кросовер"}}',
                            }
tbls['vozilo_klasa'] = {
                        'sch': 'sif',
                        'rn': '{"vzkl_id": 0, "vzkl_oznaka": "M", "vzkl_naziv": "Klasa M"}',
                        'ru': '{{"vzkl_id": {}, "vzkl_oznaka": "M", "vzkl_naziv": "Klasa X"}}',
                       }
tbls['vozilo_vrsta'] = {
                        'sch': 'sif',
                        'rn': '{"vzv_id": 0, "vzv_oznaka": "A", "vzv_naziv": "Тротинети"}',
                        'ru': '{{"vzv_id": {}, "vzv_oznaka": "A", "vzv_naziv": "Ромобили"}}',
                       }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= FUNCTION ============================
# res2dct
#=======================================
def res2dct(pj_res):

  return dd(js.loads(pj_res))

#= FUNCTION ============================
# t00
#=======================================
def t00(pc_tbl):

  vcl_tbl = pc_tbl.lower()
  if vcl_tbl in tbls:
    td = tbls[vcl_tbl]
    t = table(td.sch, vcl_tbl)
    print('## {}'.format('Table info'))
    print('  Schema: {}\n  Name: {}\n  Column names: {}\n  Column types: {}'.format(t.schema, t.name, t.col_names, t.col_types))

#   get all
    print('\n# {}'.format('get all'))
    res = t.tbl_g()
    for r in js.loads(res):
      print('  {}'.format(r))

#   insert ...
    print('\n# {}'.format('insert new record'))
    vcl_json = td.rn
    print('  {}'.format(vcl_json))
    res = res2dct(t.tbl_i(vcl_json))
    vnl_t_id = res.rcod
    if vnl_t_id<0:
      print('  Greška: {}'.format(res.rmsg))
    else:
      print('  New id: {rcod}; {rmsg}'.format(**res))
#     get tbl_id=new tbl_id
      print('# {}'.format('get new record'))
      res = t.tbl_g(vnl_t_id)
      for r in js.loads(res):
        print('  {}'.format(r))

#     update tbl_id=new tbl_id
      print('\n# {}'.format('update new record'))
      vcl_json = td.ru.format(vnl_t_id)
      print('  {}'.format(vcl_json))
      res = res2dct(t.tbl_u(vcl_json))
      if res.rcod<0:
        print('  Greška: {}'.format(res.rmsg))
      else:
        print('  Updated records: {rcod}; {rmsg}'.format(**res))
#       get tbl_id=new tbl_id
        print('# {}'.format('get updated new record'))
        res = t.tbl_g(vnl_t_id)
        for r in js.loads(res):
          print('  {}'.format(r))

#       delete tbl_id=new tbl_id
        print('\n# {}'.format('delete new record'))
        res = res2dct(t.tbl_d(vnl_t_id))
        print('  Deleted records: {rcod}; {rmsg}'.format(**res))
#       get tbl_id=new tbl_id
        print('# {}'.format('get new record'))
        res = t.tbl_g(vnl_t_id)
        if js.loads(res):
          for r in js.loads(res):
            print('  {}'.format(r))
        else:
          print('  Nema sloga sa ID-om {}.'.format(vnl_t_id))

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
             ]

#---------------------------------------
# code
#---------------------------------------

  try:
    for vcg_tbl in lcg_tbls:
#    t00(lcg_tbls[7])
      t00(vcg_tbl)
      print()
  except IndexError:
    print('List index out of range.')
