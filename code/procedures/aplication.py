#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
import json as js

# site-packages
from box import SBox as dd

# local
from .table import table

#---------------------------------------
# global variables
#---------------------------------------

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= CLASS ===============================
# aplication
#=======================================
class aplication:

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self, po_db, pi_kr_id, pb_disabled=True):

    self.apps = self.applications(po_db, pi_kr_id, pb_disabled)

  #= METHOD ==============================
  # applications
  #=======================================
  def applications(self, po_db, pi_kr_id, pb_disabled=True):

    acts = dd(
              {
               'v': {'label': 'Pregled', 'method': 'tbl_get',},
               'i': {'label': 'Dodavanje', 'method': 'tbl_insert',},
               'u': {'label': 'Izmena', 'method': 'tbl_update',},
               'd': {'label': 'Brisanje', 'method': 'tbl_delete',},
               'c': {'label': 'Kopiranje', 'method': 'tbl_copy',},
               'xx': {'label': 'Akcija {}', 'method': 'tbl_{}',},
              }
             )

    #= FUNCTION ============================
    # form_tables
    #=======================================
    def form_tables(pd_tables, pl_pk=[], pi_Level=0):

      pd_tables['table'] = table(po_db, pd_tables.source)
      pd_tables['parentpk'] = pl_pk
      for dxl_Tables in pd_tables.get('details', []):
        form_tables(dxl_Tables, pd_tables.table.primarykey, pi_Level+1)

      return pd_tables

    apps = dd({})
    for r in po_db.user_forms(pi_kr_id):
      row = dd(r)
      if row.aap_id not in apps:
        apps[row.aap_id] = {'title': row.aap_naziv, 'forms': {}}
      if row.afo_id not in apps[row.aap_id].forms:
        if row.afo_dostupna=='y' or pb_disabled:
          apps[row.aap_id].forms[row.afo_id] = {
                                                'title': row.afo_naziv,
                                                'tables': (js.loads(row.afo_tabele) if row.afo_tabele else {}),
                                                'reports': (js.loads(row.afo_izvestaji) if row.afo_izvestaji else {}),
                                                'enabled': row.afo_dostupna=='y',
                                                'useractions': (js.loads(row.arf_akcije_d) if row.arf_akcije_d else {}),
                                               }
          if apps[row.aap_id].forms[row.afo_id].tables:
            apps[row.aap_id].forms[row.afo_id].tables = form_tables(apps[row.aap_id].forms[row.afo_id].tables)
          if apps[row.aap_id].forms[row.afo_id].enabled:
            if apps[row.aap_id].forms[row.afo_id].tables.actions:
              for vil_ActIdx, vcl_FormAction in enumerate(apps[row.aap_id].forms[row.afo_id].tables.actions):
                if vcl_FormAction in acts:
                  dcl_Act = acts[vcl_FormAction]
                else:
                  dcl_Act = acts.xx
                  dcl_Act.label = dcl_Act.label.format(vcl_FormAction)
                  dcl_Act.method = dcl_Act.method.format(vcl_FormAction)
                dcl_Act['enabled'] = vcl_FormAction in apps[row.aap_id].forms[row.afo_id].useractions.get('actions', [])
                apps[row.aap_id].forms[row.afo_id].tables.actions[vil_ActIdx] = dcl_Act

    return apps.to_dict()

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
