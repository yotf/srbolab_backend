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

from box import SBox as dd

from table import db, table

#---------------------------------------
# global variables
#---------------------------------------
tbls = dd({})
tbls['emisija'] = {
                   'schema': 'sif',
                   'recordnew': {'em_id': 0, 'em_naziv': '7 (Седам)'},
                   'recorupdate': {'em_id': None, 'em_naziv': '8 (Осам)'},
                   'primarykey': 'em_id',
                  }
tbls['gorivo'] = {
                  'schema': 'sif',
                  'recordnew': {'gr_id': 0, 'gr_naziv': 'Угаљ'},
                  'recorupdate': {'gr_id': None, 'gr_naziv': 'Шљака'},
                  'primarykey': 'gr_id',
                 }
tbls['lokacija'] = {
                   'schema': 'sys',
                   'recordnew': {'lk_id': 0, 'lk_naziv': 'Нови Сад', 'lk_naziv_l': 'Новом Саду', 'lk_ip': '192.168.1.55', 'lk_aktivna': 'D'},
                   'recorupdate': {'lk_id': None, 'lk_naziv': 'Нови Сад', 'lk_naziv_l': 'Новом Саду', 'lk_ip': '192.168.1.66', 'lk_aktivna': 'N'},
                   'primarykey': 'lk_id',
                   }
tbls['organizacija'] = {
                        'schema': 'sif',
                        'recordnew': {'org_id': 0, 'org_naziv': 'ЈКПИ', 'org_napomena': 'Бла, бла, ...'},
                        'recorupdate': {'org_id': None, 'org_naziv': 'ЈКПИ', 'org_napomena': 'Трт мрт'},
                        'primarykey': 'org_id',
                       }
tbls['vozilo_karoserija'] = {
                             'schema': 'sif',
                             'recordnew': {'vzk_id': 0, 'vzk_oznaka': 'XX', 'vzk_naziv': 'Баги'},
                             'recorupdate': {'vzk_id': None, 'vzk_oznaka': 'XX', 'vzk_naziv': 'Кросовер'},
                             'primarykey': 'vzk_id',
                            }
tbls['vozilo_klasa'] = {
                        'schema': 'sif',
                        'recordnew': {'vzkl_id': 0, 'vzkl_oznaka': 'M', 'vzkl_naziv': 'Klasa M'},
                        'recorupdate': {'vzkl_id': None, 'vzkl_oznaka': 'M', 'vzkl_naziv': 'Klasa X'},
                        'primarykey': 'vzkl_id',
                       }
tbls['vozilo_vrsta'] = {
                        'schema': 'sif',
                        'recordnew': {'vzv_id': 0, 'vzv_oznaka': 'A', 'vzv_naziv': 'Тротинети'},
                        'recorupdate': {'vzv_id': None, 'vzv_oznaka': 'A', 'vzv_naziv': 'Ромобили'},
                        'primarykey': 'vzv_id',
                       }
tbls['ag_proizvodjac'] = {
                          'schema': 'sif',
                          'recordnew': {'agp_id': 0, 'agp_naziv': 'NS AUTOGAS', 'agp_napomena': None},
                          'recorupdate': {'agp_id': None, 'agp_naziv': 'NS AUTOGAS', 'agp_napomena': 'Napomena'},
                          'primarykey': 'agp_id',
                         }
tbls['ag_homologacija'] = {
                           'schema': 'sif',
                           'recordnew': {'agh_id': 0, 'agh_oznaka': '123 456 789', 'agh_uredjaj': 'MV'},
                           'recorupdate': {'agh_id': None, 'agh_oznaka': '123 456 789', 'agh_uredjaj': 'RD'},
                           'primarykey': 'agh_id',
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
  tbl = table(td.schema, vcl_tbl)

  #= FUNCTION ============================
  # tbl_get
  #=======================================
  def tbl_get(pc_msg, pi_tbl_id=None):

    print("#####################", pi_tbl_id)
    print('\n# {}'.format(pc_msg))
    res = tbl.tbl_get(pi_tbl_id)
    if res:
      for r in res:
        print('  {}'.format(dict(r)))
    else:
      print('  Nema sloga sa ID-om {}.'.format(vil_tbl_id))

  #= FUNCTION ============================
  # tbl_insert
  #=======================================
  def tbl_insert():

    print('\n# {}'.format('insert new record'))
    dxl_row = td.recordnew
    print('  {}'.format(dxl_row))
    res = res2obj(tbl.tbl_insert(dxl_row))
    vil_tbl_id = res.rcod
    if vil_tbl_id < 0:
      print('  Greška: {}'.format(res.rmsg))
    else:
      print('  New id: {rcod}; {rmsg}'.format(**res))
      # get tbl_id=new tbl_id
      tbl_get('get new record', vil_tbl_id)

    return vil_tbl_id

  #= FUNCTION ============================
  # tbl_update
  #=======================================
  def tbl_update(pi_tbl_id):

    # update tbl_id=new tbl_id
    print('\n# {}'.format('update new record'))
    td.recorupdate[td.primarykey] = pi_tbl_id
    dxl_row = td.recorupdate
    print('  {}'.format(dxl_row))
    res = res2obj(tbl.tbl_update(dxl_row))
    if res.rcod < 0:
      print('  Greška: {}'.format(res.rmsg))
    else:
      print('  Updated records: {rcod}; {rmsg}'.format(**res))
      # get tbl_id=new tbl_id
      tbl_get('get updated new record', pi_tbl_id)

    return res

  #= FUNCTION ============================
  # tbl_delete
  #=======================================
  def tbl_delete(pi_tbl_id):

    # delete tbl_id=new tbl_id
    print('\n# {}'.format('delete new record'))
    res = res2obj(tbl.tbl_delete(pi_tbl_id))
    print('  Deleted records: {rcod}; {rmsg}'.format(**res))
    # get tbl_id=new tbl_id
    tbl_get('get new record', pi_tbl_id)

# table

  print('## {}'.format('Table info'))
  print('  Schema: {}\n  Name: {}\n  Comment: {}\n  Column names: {}\n  Column types: {}\n  Column comments: {}'.format(tbl.schema, tbl.name, tbl.comment, [cd['name'] for cd in tbl.cols], [cd['type'] for cd in tbl.cols], [cd['comment'] for cd in tbl.cols]))
  # get all
  tbl_get('get all')
  # insert ...
  vil_tbl_id = tbl_insert()
  if vil_tbl_id > 0:
    #   update tbl_id=new tbl_id
    res = tbl_update(vil_tbl_id)
    if res.rcod > 0:
      #     delete tbl_id=new tbl_id
      tbl_delete(vil_tbl_id)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# main code
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if __name__ == '__main__':

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
