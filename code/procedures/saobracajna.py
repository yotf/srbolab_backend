#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
import os
import os.path as osp
import re

# site-packages
from box import SBox as dd

from . import util as utl
# local
from .cfg import getpgdb, sysdf

#---------------------------------------
# global variables
#---------------------------------------
rexs = dd({
    're0':
    re.compile('[\n]{2,}', re.I),
    're1':
    re.compile('(Najveća dozvoljena)(\n)(Kategorija.+\n)(masa.+\n)', re.I),
    're2':
    re.compile(
        '^(Registarska oznaka|Vlasnik|Ime vlasnika|Adresa vlasnika|Marka|Tip|Godina proizvodnje|Model|Homologacijska oznaka|Broj osovina|Broj šasije|Zapremina motora|Broj motora|Masa|Snaga motora|Nosivost|Odnos snaga/masa|Najveća dozvoljena masa|Kategorija|Pogonsko gorivo|Broj mesta za sedenje|Broj mesta za stajanje):',
        re.I),
})


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= CLASS ===============================
# saobracajna
#=======================================
class saobracajna:

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self, po_db):

    self.db = po_db

  #= METHOD ==============================
  # pdf2txt
  #=======================================
  def pdf2txt(self, pc_pdffile, pc_username):

    reps = dd({})
    reps['pdfdir'] = osp.join(sysdf.reps, 'pdf', pc_username)
    reps['txt'] = osp.join(reps.pdfdir, 'sd.txt')
    reps['pdf'] = osp.join(reps.pdfdir, 'sd.pdf')

    utl.dircheck(reps.pdfdir)
    with open(reps.pdf, 'wb') as f:
      f.write(pc_pdffile)
    utl.filedelete(reps.txt)
    cmd = ['pdftotext', reps.pdf, reps.txt]
    vcl_CmdRes = utl.cmdrun(' '.join(cmd))
    if osp.exists(reps.txt):
      vcl_text = self.txt2txt(reps.txt)
    else:
      reps.pdf = None
      print('{}'.format(vcl_CmdRes))
      print('Izveštaj "{}" ne postoji!'.format(reps.txt))

    return vcl_text

  #= METHOD ==============================
  # txt2txt
  #=======================================
  def txt2txt(self, pc_txtfile):

    with open(pc_txtfile, 'r') as f:
      vcl_txt = f.read()
    vcl_txt = '\n'.join([
        l for l in rexs.re1.sub(r'\1 \4\3', rexs.re0.sub(
            r'\n', vcl_txt)).rstrip().splitlines() if rexs.re2.match(l)
    ])

    return vcl_txt

  #= METHOD ==============================
  # read
  #=======================================
  def read(self, pc_pdffile, pc_username):

    vxl_res = None
    vcl_txt = self.pdf2txt(pc_pdffile, pc_username)
    if vcl_txt:
      conn = self.db.connget()
      crsr = conn.cursor()
      try:
        crsr.callproc('hmlg.f_saobracajna', [vcl_txt])
        vxl_res = crsr.fetchone()
      except Exception as err:
        vxl_res = '{}'.format(err)
      finally:
        crsr.close()
        self.db.connret(conn)

    return vxl_res


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
