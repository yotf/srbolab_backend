#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
import os
import re
import sys
import csv
import glob as g
import locale as lc
import os.path as osp
import subprocess as sbp

lc.setlocale(lc.LC_ALL, '')

# site-packages
import xlrd
from box import SBox as dd

sys.path.append(osp.join(osp.dirname(osp.dirname(osp.abspath(__file__))), 'flask_app', 'code'))

# local
from procedures.pgdb import pgdb
#from procedures.cfg import sysdf

#---------------------------------------
# global variables
#---------------------------------------
dirs = dd({})
dirs['wrk'] = osp.dirname(osp.abspath(__file__))
dirs['xlsx'] = osp.join(dirs.wrk, 'data', 'xls')
dirs['acc'] = osp.join(dirs.wrk, 'data', 'acc')
dirs['csv'] = osp.join(dirs.wrk, 'data', 'csv')

typs = dd(
          {
           's': str,
           'i': int,
           'f': float,
           'd': str,
           'b': str,
          }
         )

tbls = dd({})
tbls['vozilo_imp'] = {
                      'colnames': ['vzi_br', 'vzi_rn', 'pr_broj', 'kl_naziv', 'kl_adresa', 'kl_telefon', 'vz_sasija', 'vzpv_naziv', 'vzk_naziv', 'mr_naziv', 'mdt_oznaka', 'mdvr_oznaka', 'mdvz_oznaka', 'md_naziv_k', 'vz_masa_max', 'vzo_nosivost1', 'vzo_nosivost2', 'vzo_nosivost3', 'vzo_nosivost4', 'vz_masa', 'vz_nosivost', 'vz_br_osovina', 'vz_br_tockova', 'vz_motor', 'mt_oznaka', 'mt_cm3', 'mt_kw', 'gr_naziv', 'vz_kw_kg', 'vz_elektro', 'vz_mesta_sedenje', 'vz_mesta_stajanje', 'vz_kmh', 'vz_godina', 'vzo_pneumatik1', 'vzo_pneumatik2', 'vzo_pneumatik3', 'vzo_pneumatik4', 'vz_duzina', 'vz_sirina', 'vz_visina', 'vz_km', 'vz_kuka', 'em_naziv', 'vz_co2', 'vz_napomena', 'vz_primedbe', 'pr_datum', 'kr_ime', 'vz_saobracajna', 'vz_odg_dok', 'vz_coc', 'vz_potvrda_pr', 'org_naziv', 'org_adresa', 'org_id', 'vz_tip_var_ver', 'vz_pneumatici', 'vi_naziv', 'vz_zakljucak', 'vz_prebaceno1', 'vz_prebaceno2', 'vz_br_oso_toc', 'vz_karakter10', 'gr_gas'],
                      'coltypes': ['i', 'i', 's', 's', 's', 's', 's', 's', 's', 's', 's', 's', 's', 's', 'i', 'i', 'i', 'i', 'i', 'i', 'i', 'i', 'i', 's', 's', 'f', 'f', 's', 'f', 'b', 'i', 'i', 'i', 'i', 's', 's', 's', 's', 'i', 'i', 'i', 'i', 'b', 's', 'i', 's', 's', 'd', 's', 'b', 'b', 'b', 'b', 's', 's', 'i', 's', 's', 's', 's', 'b', 'b', 's', 's', 's'],
                     }
tbls['vozilo_imp_gas'] = {
                          'colnames': ['vzg_br', 'vzg_rn', 'vzgi_broj', 'vzpv_oznaka_bt', 'vzpv_oznaka', 'mr_naziv_bt', 'mr_naziv', 'vvt_bt', 'vvt', 'md_naziv_k_bt', 'md_naziv_k', 'vz_sasija_bt', 'vz_sasija', 'vz_masa_max_bt', 'vz_masa_max', 'vz_masa_bt', 'vz_masa', 'mt_cm3_bt', 'mt_cm3', 'mt_kw_bt', 'mt_kw', 'gr_naziv_bt', 'gr_naziv', 'vz_mesta_sedenje_bt', 'vz_mesta_sedenje', 'vz_mesta_stajanje_bt', 'vz_mesta_stajanje', 'vz_motor_bt', 'vz_motor', 'mt_oznaka_bt', 'mt_oznaka', 'vz_br_osovina_bt', 'vz_br_osovina', 'vzk_oznaka_bt', 'vzk_oznaka', 'vz_max_brzina_bt', 'vz_max_brzina', 'vzo_pneumatik_bt', 'vzo_pneumatik', 'kl_naziv', 'kl_iadresa', 'agp_naziv_rz', 'agh_oznaka_rz', 'vzgu_broj_rz', 'agp_naziv_rd', 'agh_oznaka_rd', 'vzgu_broj_rd', 'agp_naziv_mv', 'agh_oznaka_mv', 'vzgu_broj_mv', 'vzgi_su_broj', 'vzgi_su_datum', 'vzgi_su_rok', 'org_naziv', 'vzgi_potvrda_rok', 'kr_ime', 'vzgi_potvrda_datum', 'vzgi_potvrda_broj', 'vzgi_zakljucak', 'lk_naziv_l', 'vz_reg'],
                          'coltypes': ['i', 'i', 's', 's', 's', 's', 's', 's', 's', 's', 's', 's', 's', 'i', 'i', 'i', 'i', 'f', 'f', 'f', 'f', 's', 's', 'i', 'i', 'i', 'i', 's', 's', 's', 's', 'i', 'i', 's', 's', 'i', 'i', 's', 's', 's', 's', 's', 's', 's', 's', 's', 's', 's', 's', 's', 's', 'd', 'd', 's', 'd', 's', 'd', 's', 's', 's', 's' ],
                         }
tbls['vozilo_imp_gu'] = {
                         'colnames': ['vzgu_br', 'vzgu_rn', 'agu_id', 'agu_oznaka', 'agp_naziv', 'agh_oznaka'],
                         'coltypes': ['i', 'i', 'i', 's', 's', 's'],
                        }

rexs = dd(
          {
           'a': re.compile(u'_x000d_', re.I),
           'lat': re.compile(u'^[^АБВГДЂЕЖЗИЈКЛЉМНЊОПРСТЋУФХЦЧЏШ]+$', re.I),
           'cir': re.compile(u'^[^A-ZŠĐČĆŽ]+$', re.I),
           'ms': re.compile(u'[ ]{2,}', re.I),
           'n1': re.compile(u'(D\.|O\.|SZR|MILENIJ)', re.I),
           'n2': re.compile(u'IVANA', re.I),
           'vzpv1': re.compile(u'^(M1)( - )(Путничко возило)(/)(G)$', re.I),
           'vzpv2': re.compile(u'([^ ])(-)', re.I),
           'gr': re.compile(u'^(Бензин|Бензин/КПГ|Бензин/ТНГ|Дизел)$', re.I),
           'gas': re.compile(u'(КПГ|ТНГ)', re.I),
           'gasfu': re.compile(u'FABRI.KI', re.I),
           'gasnu': re.compile(u'NAKNAD.+ UGRAD', re.I),
          }
         )

rexc = dd(
          {
           'kl_naziv': [
                        [u'x', re.compile(u'^AC MILENIJUM.*$', re.I), u'AUTO CENTAR MILENIJUM DOO BEOGRAD'],
                        [u'x', re.compile(u'^.*HERTNER.*$', re.I), u'HERTNER AUTO DOO BEOGRAD'],
                        [u'x', re.compile(u'^.*KRLE.*PLUS.*$', re.I), u'KRLE ŠPED PLUS'],
                        [u'x', re.compile(u'^.*TIDUO.*$', re.I), u'TIDUOAUTO'],
                        [u'x', re.compile(u'^.*URO.*CAR.*$', re.I), u'UROŠEVIĆ CARS DOO'],
                        [u'x', re.compile(u'^MILANO.+AUTO.+$', re.I), u'MILANO-AUTO 2005 DOO, ŠABAC'],
                        [u'r', u'NICIFOROVIC', u'NIĆIFOROVIĆ'],
                        [u'r', u'ДУКУЋ', u'ДУКИЋ'],
                        [u'r', u'ПЕДРАГ', u'ПРЕДРАГ'],
                        [u'x', re.compile(u'(IC)( |$)', re.I), u'IĆ'],
                        [u'x', re.compile(u'^(.+)( )(.+(УЋ|ИЋ|SKI|IĆ|КА))$', re.I), r'\3\2\1'],
                       ],
           'kl_adresa': [
                         [u'x', re.compile(u'(,)([^ ])', re.I), r'\1 \2'],
                         [u'r', u'6Х', u'6X'],
                         [u'x', re.compile(u'(ВРТЛАРСКА 59)(.+)', re.I), r'\1, ЗЕМУН'],
                         [u'x', re.compile(u'(ПРИЧИНОВИЋ)$', re.I), r'\1, ШАБАЦ'],
                         [u'x', re.compile(u'^(КНЕЗА МИХАИЛА 30).*$', re.I), r'\1, БЕОГРАД'],
                         [u'x', re.compile(u'^(ДУНАВСКИ|DUNAVSKI)([ ]+)(КЕЈ|KEJ) .*$', re.I), u'ДУНАВСКИ КЕЈ 9, БЕОГРАД'],
                         [u'x', re.compile(u'^(ВЛАДИМИРА ПОПОВИЋА 38-40).*$', re.I), r'\1, БЕОГРАД'],
                         [u'x', re.compile(u'(LJUMOVI|SREJOVI|MIHAILOVI|GRULOVI|VASI)(CA)', re.I), r'\1ĆA'],
                         [u'x', re.compile(u'(A.[ ]*)(RAJSA)', re.I), r'ARČIBALDA \2'],
                         [u'x', re.compile(u'(Т.[ ]*)(ПАВЛОВ)', re.I), r'ТЕОДОРА \2'],
                         [u'x', re.compile(u'([ ]+)(,)', re.I), r'\2'],
                         [u'x', re.compile(u'(,|\.)([^ ])', re.I), r'\1 \2'],
                         [u'x', re.compile(u'([0]+)([1-9]+)', re.I), r'\2'],
                         [u'r', u'DUSAN', u'DUŠAN'],
                         [u'r', u'KALUDERICA', u'KALUĐERICA'],
                         [u'r', u'VINCA', u'VINČA'],
                         [u'r', u'LESTANE', u'LEŠTANE'],
                         [u'r', u'ZIVORAD', u'ŽIVORAD'],
                         [u'r', u'SABAC', u'ŠABAC'],
                         [u'r', u'SREMCICA', u'SREMČICA'],
                         [u'r', u'CUKARICA', u'SREMČICA'],
                         [u'r', u'CUKARICA', u'ČUKARICA'],
                         [u'r', u'ZIVANICEVA', u'ŽIVANIĆEVA'],
                         [u'r', u'MOSTANICA', u'MOŠTANICA'],
                         [u'r', u'SARCEVICA', u'ŠARČEVIĆA'],
                         [u'r', u'ЈЕРКОБИ', u'ЈЕРКОВИ'],
                         [u'x', u'ЈЕРКОБИ', u'ЈЕРКОВИ'],
                         [u'x', re.compile(u'(dr|др)(\.)', re.I), r'\1'],
                        ],
           'kl_telefon': [
                          [u'x', re.compile(u'^([-]+)', re.I), u''],
                         ],
           'mr_naziv': [
                        [u'x', re.compile(u'^MERCEDES.*$', re.I), u'MERCEDES-BENZ'],
                        [u'x', re.compile(u'^M$', re.I), u'VOLKSWAGEN, VW'],
                        [u'x', re.compile(u'^(SCHMITZ)(.*)$', re.I), r'\1'],
                       ],
           'md_naziv_k': [
                          [u'x', re.compile(u'(A|320|530|1|F)( )(4|D|ER|650)', re.I), r'\1\3'],
                          [u'x', re.compile(u'(X)(1|3|4|5|6)([ ]*)(|X|S)(DRIVE)([ ]*)([0-9]{2}D)', re.I), r'\1\2 \4\5 \7'],
                          [u'x', re.compile(u'^COMPAS$', re.I), u'COMPASS'],
                          [u'x', re.compile(u'^CEED$', re.I), u'CEE''D'],
                          [u'x', re.compile(u'^(A|B|C|E|S)([0-9]{3})(| CDI)$', re.I), r'\1 \2\3'],
                          [u'x', re.compile(u'^(RAV)([ ]+)(4)$', re.I), r'\1\3'],
                          [u'x', re.compile(u'^(C|S|V)([ ]*)([0-9]{2})$', re.I), r'\1\3'],
                          [u'x', re.compile(u'([0-9]{3})(CDI)', re.I), r'\1 \2'],
                          [u'x', re.compile(u'(-[A-Z])$', re.I), u''],
                          [u'x', re.compile(u'^([0-9]{3})([A-Z])$', re.I), r'\1 \2'],
                          [u'x', re.compile(u'(;)([^ ])', re.I), r'\1 \2'],
                          [u'x', re.compile(u'^([0-9]{3})([ ]+)([A-Z])$', re.I), r'\1\3'],
                          [u'x', re.compile(u'(TCSON|TUCON)', re.I), u'TUCSON'],
                          [u'r', u'I X 35', u'IX35'],
                          [u'r', u'IX35,LM', u'IX35, LM'],
                          [u'r', u'AN 650', u'AN650'],
                          [u'r', u'BOXPT', u'BOXER'],
                          [u'r', u'TGX 18440', u'TGX 18.440'],
                          [u'r', u'X5 XDRIVE50I', u'X5 XDRIVE 50I'],
                          [u'r', u'GLC 250D 4MATIC', u'GLC 250 D 4MATIC'],
                          [u'r', u'G- CABRIO', u'G-CABRIO'],
                          [u'x', re.compile(u'(X[0-9])([ ]{1,})(DRIVE)', re.I), r'\1 X\3'],
                          [u'x', re.compile(u'(TRANSIT)(.+)(TOURNEO)', re.I), r'\1 \3'],
                          [u'x', re.compile(u'(LANCIA)([^ ]+)', re.I), r'\1 \2'],
                          [u'x', re.compile(u'(TGA)([^ ]+)', re.I), r'\1 \2'],
                          [u'x', re.compile(u'(COMPRESSOR|KOPRESSOR)', re.I), u'KOMPRESSOR'],
                          [u'x', re.compile(u'(XC)([ ]+)([0-9]{2})', re.I), r'\1\3'],
                          [u'x', re.compile(u'(ML)([0-9]{3})(.+)', re.I), r'\1 \2\3'],
                          [u'x', re.compile(u'(4X2)(BL)', re.I), r'\1 \2'],
                         ],
           'mdt_oznaka': [
                          [u'x', re.compile(u'([ ]+)(MONOCAB)', re.I), r'/\2'],
                          [u'x', re.compile(u'([^/])(MONOCAB)', re.I), r'\1/\2'],
                          [u'x', re.compile(u'^AHM0N0CAB$', re.I), u'A-H/MONOCAB'],
                          [u'x', re.compile(u'^ULK-C/X$', re.I), u'UKL-C/X'],
                          [u'x', re.compile(u'^COMBOC-VAN$', re.I), u'COMBO-C-VAN'],
                          [u'x', re.compile(u'^(204|245)(X|G)$', re.I), r'\1 \2'],
                          [u'x', re.compile(u'^(2|P|S)([\*]{4,6})$', re.I), r'\1*****'],
                          [u'x', re.compile(u'^(MONOCAB)( B)$', re.I), r'\1'],
                          [u'x', re.compile(u'^(A-H)$', re.I), r'\1/MONOCAB'],
                         ],
           'mdvr_oznaka': [
                           [u'x', re.compile(u'^(MONOCAB)$', re.I), u'BE11'],
                           [u'r', u'?', u''],
                           [u'r', u'KSP90H', u'KSP90(H)'],
                           [u'r', u'CLA21W', u'CLA21(W)'],
                           [u'r', u'ZWE186H', u'ZWE186(H)'],
                          ],
           'mdvz_oznaka': [
                           [u'x', re.compile(u'^(BE11)(.+)$', re.I), r'\2'],
                           [u'r', u'?', u''],
                          ],
           'mto_oznaka': [
                          [u'x', re.compile(u'[ ]+', re.I), u''],
                          [u'x', re.compile(u'(1CD)(-)(FTV)+', re.I), r'\1\3'],
                          [u'x', re.compile(u'^(188A500)$', re.I), u'188A5000'],
                         ],
           'vzo_pneumatik': [
                             [u'x', re.compile(u'([ ]{1,})(R|Z)', re.I), r'\2'],
                             [u'x', re.compile(u'^(195|205|215)(/)(50|55|65)(R1)$', re.I), r'\1\2\3\46'],
                             [u'r', u'/*', u'/'],
                             [u'x', re.compile(u'(/)([ ]+)', re.I), r'\1'],
                             [u'r', u'.', u','],
                             [u'r', u'R158', u'R15'],
                             [u'r', u'RZR', u'ZR'],
                             [u'r', u'225/50R17225/45R1', u'225/50R17']
                            ],
          }
         )

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= FUNCTION ============================
# coltypes
#=======================================
def coltypes(pc_Tbl):

  return [t for t in zip(tbls[pc_Tbl].colnames, tbls[pc_Tbl].coltypes, [typs.get(t, str) for t in tbls[pc_Tbl].coltypes])]

#= FUNCTION ============================
# acc2csv
#=======================================
def acc2csv():

  lcl_AccTbls = ['Mala uverenja', 'Multiventil_Homologacija', 'Reduktor_Homologacija', 'Rezervoar_Homologacija']
  lcl_CSVFls = ['{}-sl-data-gas', '{}-sl-data-gu-mv', '{}-sl-data-gu-rd', '{}-sl-data-gu-rz']

  lcl_AccFls = g.glob(osp.join(dirs.acc, '[0-9][0-9][0-9]-sl-data-gas.mdb'))
  for vcl_AccFl in sorted(lcl_AccFls):
#    cmdb = [sysdf.java, '-jar', '/home/share/bin/jar/access2csv.jar', '"{}"'.format(vcl_AccFl)]
    cmdb = ['java -jar', '/home/share/bin/jar/access2csv.jar', '"{}"'.format(vcl_AccFl)]
    vcl_Idx = osp.basename(vcl_AccFl).split('-', 1)[0]
    for vil_TblNo, vcl_Tbl in enumerate(lcl_AccTbls):
      vcl_CSVFl = '{}.csv'.format(osp.join(dirs.csv, lcl_CSVFls[vil_TblNo].format(vcl_Idx)))
      if not osp.exists(vcl_CSVFl):
        cmd = cmdb+['"{}"'.format(vcl_Tbl)]
        try:
          oxl_Cmd = sbp.Popen(' '.join(cmd), stdout=sbp.PIPE, stderr=sbp.PIPE, shell=True, universal_newlines=True)
        except:
          raise
        else:
          vcl_CmdOut, vcl_CmdErr = oxl_Cmd.communicate()
          if vcl_CmdOut and not vcl_CmdErr:
            print('"{}" => "{}"'.format(vcl_Tbl, osp.basename(vcl_CSVFl)))
            with open(vcl_CSVFl, 'w') as f:
              f.write(vcl_CmdOut)

#= FUNCTION ============================
#  srpski
#=======================================
def srpski():

  lcl_LatDbl = [u'lj,nj,dž,dj', 'lJ,nJ,dŽ,dJ']
  vcl_CirDbl = u'љ,њ,џ,ђ'

  vcl_LatL = u'a,b,v,g,d,đ,e,ž,z,i,j,k,l,m,n,o,p,r,s,t,ć,u,f,h,c,č,š'
  vcl_CirL = u'а,б,в,г,д,ђ,е,ж,з,и,ј,к,л,м,н,о,п,р,с,т,ћ,у,ф,х,ц,ч,ш'

  lcl_Lat = []
  lcl_Cir = []

  for vcl_LatDbl in lcl_LatDbl:
    for vcl_Lat, vcl_Cir in zip(vcl_LatDbl.split(','), vcl_CirDbl.split(',')):
      lcl_Lat.append(vcl_Lat)
      lcl_Cir.append(vcl_Cir)
      lcl_Lat.append(vcl_Lat.swapcase())
      lcl_Cir.append(vcl_Cir.swapcase())

  for vcl_Lat, vcl_Cir in zip(vcl_LatL.split(','), vcl_CirL.split(',')):
    lcl_Lat.append(vcl_Lat)
    lcl_Cir.append(vcl_Cir)
    lcl_Lat.append(vcl_Lat.upper())
    lcl_Cir.append(vcl_Cir.upper())

  return dd({'lat': lcl_Lat, 'cir': lcl_Cir})

srconv = srpski()

#= FUNCTION ============================
#  lat2cir
#=======================================
def lat2cir(pc_StrIn, pb_2Cir=True):

  vcl_StrOut = pc_StrIn
  if pc_StrIn and pc_StrIn.strip():
    ltl_Cnv = (zip(srconv.lat, srconv.cir) if pb_2Cir else zip(srconv.cir, srconv.lat))
    for vcl_LtrFrom, vcl_LtrTo in ltl_Cnv:
      if vcl_LtrFrom in vcl_StrOut:
        vcl_StrOut = vcl_StrOut.replace(vcl_LtrFrom, vcl_LtrTo)

  return vcl_StrOut

#= FUNCTION ============================
# islat
#=======================================
def islat(pc_str):

  return (True if rexs.lat.match(pc_str) else False)

#= FUNCTION ============================
# iscir
#=======================================
def iscir(pc_str):

  return (True if rexs.cir.match(pc_str) else False)

#= FUNCTION ============================
# fix_str
#=======================================
def fix_str(pl_rexp, pc_text, pc_null=None):

  vcl_text = (pc_text.upper() if pc_text else pc_null);
  if vcl_text:
    vil_arrlen = len(pl_rexp);
    for lxl_rexp in pl_rexp:
      if lxl_rexp[0]=='x':
        if lxl_rexp[1].search(vcl_text):
          vcl_text = lxl_rexp[1].sub(lxl_rexp[2], vcl_text)
      elif lxl_rexp[0]=='r':
        if lxl_rexp[1] in vcl_text:
          vcl_text = vcl_text.replace(lxl_rexp[1], lxl_rexp[2])
      else:
        pass
    vcl_text = (None if vcl_text=='' else rexs.ms.sub(' ', vcl_text))

  return vcl_text;

#= FUNCTION ============================
# fix_kl_adresa
#=======================================
def fix_kl_adresa(pc_text):

  lll_rexp = rexc.kl_adresa

  try:
    vcl_text = fix_str(lll_rexp, pc_text.upper().strip())
  except:
    vcl_text = pc_text

  if vcl_text:
#    lcl_f = ['DUSAN', 'KALUDERICA', 'VINCA', 'LESTANE', 'ZIVORAD', 'SABAC', 'SREMCICA', 'CUKARICA', 'ZIVANICEVA', 'MOSTANICA', 'SARCEVICA', 'ЈЕРКОБИ']
#    lcl_t = ['DUŠAN', 'KALUĐERICA', 'VINČA', 'LEŠTANE', 'ŽIVORAD', 'ŠABAC', 'SREMČICA', 'ČUKARICA', 'ŽIVANIĆEVA', 'MOŠTANICA', 'ŠARČEVIĆA', 'ЈЕРКОВИ']

#    for vcl_f, vcl_t in zip(lcl_f, lcl_t):
#      vcl_text = vcl_text.replace(vcl_f, vcl_t)
    if islat(vcl_text):
      vcl_text = lat2cir(vcl_text)

  return vcl_text

#= FUNCTION ============================
# fix_kl_naziv
#=======================================
def fix_kl_naziv(pc_text):

  lll_rexp = rexc.kl_naziv

  try:
    vcl_text = fix_str(lll_rexp, pc_text.upper().strip().replace('\n', ' '))
  except:
    vcl_text = pc_text

  if not iscir(vcl_text) and (len(vcl_text.split())==2 and not rexs.n1.search(vcl_text) or (len(vcl_text.split())==3 and rexs.n2.search(vcl_text))):
    vcl_text = lat2cir(vcl_text)

  return vcl_text

#= FUNCTION ============================
# fix_kl_telefon
#=======================================
def fix_kl_telefon(pc_text):

  lll_rexp = rexc.kl_telefon

  try:
    vcl_text = fix_str(lll_rexp, pc_text.upper().strip())
  except:
    vcl_text = pc_text

  return vcl_text

#= FUNCTION ============================
# fix_mr_naziv
#=======================================
def fix_mr_naziv(pc_text):

  lll_rexp = rexc.mr_naziv

  try:
    vcl_text = fix_str(lll_rexp, pc_text.upper().strip())
  except:
    vcl_text = pc_text

  return vcl_text

#= FUNCTION ============================
# fix_md_naziv_k
#=======================================
def fix_md_naziv_k(pc_text):

  lll_rexp = rexc.md_naziv_k

  try:
    vcl_text = fix_str(lll_rexp, pc_text.upper().strip())
  except:
    vcl_text = pc_text

  return vcl_text

#= FUNCTION ============================
# fix_mdt_oznaka
#=======================================
def fix_mdt_oznaka(pc_text):

  lll_rexp = rexc.mdt_oznaka

  try:
    vcl_text = fix_str(lll_rexp, pc_text.upper().strip())
  except:
    vcl_text = pc_text

  return vcl_text

#= FUNCTION ============================
# fix_mdvr_oznaka
#=======================================
def fix_mdvr_oznaka(pc_text):

  lll_rexp = rexc.mdvr_oznaka

  try:
    vcl_text = fix_str(lll_rexp, pc_text.upper().strip())
  except:
    vcl_text = pc_text

  return vcl_text

#= FUNCTION ============================
# fix_mdvz_oznaka
#=======================================
def fix_mdvz_oznaka(pc_text):

  lll_rexp = rexc.mdvz_oznaka

  try:
    vcl_text = fix_str(lll_rexp, pc_text.upper().strip())
  except:
    vcl_text = pc_text

  return vcl_text

#= FUNCTION ============================
# fix_mto_oznaka
#=======================================
def fix_mto_oznaka(pc_text):

  lll_rexp = rexc.mto_oznaka

  try:
    vcl_text = fix_str(lll_rexp, pc_text.upper().strip())
  except:
    vcl_text = pc_text

  return vcl_text

#= FUNCTION ============================
# fix_vzo_pneumatik
#=======================================
def fix_vzo_pneumatik(pc_text):

  lll_rexp = rexc.vzo_pneumatik

  try:
    vcl_text = fix_str(lll_rexp, pc_text.upper().strip())
  except:
    vcl_text = pc_text

  return vcl_text

#= FUNCTION ============================
# sert_check_rules
#=======================================
def sert_check_rules():

  """
    m - mandatory
    o - optional
    f - forbiden
"""
  """
    21 - broj osovina
      15-18 - nosivost po osovinama
      34-37 - pneumatici po osovinama
"""
  vcl_XlsxFl = osp.join(dirs.wrk, 'sl-data-check.xlsx')
  vol_XlsWbk = xlrd.open_workbook(vcl_XlsxFl)
  vol_XlsSht = vol_XlsWbk.sheet_by_index(0)
  vil_ColFirst, vil_ColLast = (0, vol_XlsSht.ncols)
  vil_RowFirst, vil_RowLast = (0, vol_XlsSht.nrows)
  vil_RowCnt = 0
  ddl_vzkat = dd({})
  for vil_RowNo in range(vil_RowFirst, vil_RowLast, 1):
    lxl_Row = vol_XlsSht.row_values(vil_RowNo, 0)
    if vil_RowNo==0:
      lcl_vzkats = lxl_Row[2:]
      for vcl_vzkat in lcl_vzkats:
        ddl_vzkat[vcl_vzkat] = {u'm': [], u'o': [], u'f': []}
    else:
      for vil_idx, vcl_c in enumerate(lxl_Row[2:]):
        if vcl_c==u'!':
          ddl_vzkat[lcl_vzkats[vil_idx]][u'm'].append(int(lxl_Row[0]))
        elif vcl_c==u'+':
          ddl_vzkat[lcl_vzkats[vil_idx]][u'o'].append(int(lxl_Row[0]))
        elif vcl_c==u'-':
          ddl_vzkat[lcl_vzkats[vil_idx]][u'f'].append(int(lxl_Row[0]))
        else:
          pass

  return ddl_vzkat

vzkat = sert_check_rules()

#= FUNCTION ============================
# row_fix0
#=======================================
def row_fix0(pl_cols, pl_row):

  for vil_ColIdx, (vcl_ColName, vcl_ColType, oxl_ColType) in enumerate(pl_cols):
    vxl_ColVal = pl_row[vil_ColIdx]
    if vil_ColIdx>=2:
      if vcl_ColType in ('i', 'f'):
        if vcl_ColType=='f':
          if ',' in vxl_ColVal:
            vxl_ColVal = vxl_ColVal.replace(',', '.')
        if vcl_ColName in ('vz_duzina', 'vz_sirina', 'vz_visina'):
          vxl_ColVal = vxl_ColVal.split('-')[-1]
        try:
          vxl_ColVal = oxl_ColType(vxl_ColVal)
          if vcl_ColName in ('vzo_nosivost1', 'vzo_nosivost2', 'vzo_nosivost3', 'vzo_nosivost4') and vxl_ColVal==87:
            vxl_ColVal = 870
          if not vxl_ColVal:
            vxl_ColVal = None
        except:
          vxl_ColVal = None
      elif vcl_ColType=='d':
        try:
          vxl_ColVal = u'{:04d}-{:02d}-{:02d}'.format(*xlrd.xldate_as_tuple(vxl_ColVal, vol_XlsWbk.datemode)[:3])
        except:
          vxl_ColVal = None
      elif vcl_ColType=='b':
        if vcl_ColName in ('vz_elektro', 'vz_kuka'):
          if isinstance(vxl_ColVal, oxl_ColType):
            vxl_ColVal = u'n'
          else:
            vxl_ColVal = (u'd' if (vxl_ColVal and vxl_ColVal.upper() in (u'ДА', u'DA')) else u'n')
        elif vcl_ColName in ('vz_saobracajna', 'vz_odg_dok', 'vz_coc', 'vz_potvrda_pr', 'vz_prebaceno1', 'vz_prebaceno2'):
          vxl_ColVal = ('d' if vxl_ColVal else 'n')
        else:
          pass
      else:
        if vxl_ColVal:
          vxl_ColVal = vxl_ColVal.strip().rstrip(u'-/')
        if not vxl_ColVal:
          vxl_ColVal = None
        else:
          if rexs.a.search(vxl_ColVal):
            vxl_ColVal = rexs.a.sub(u'', vxl_ColVal)
          if vcl_ColName=='vz_sasija' and 'O' in vxl_ColVal:
            vxl_ColVal = vxl_ColVal.replace('O', '0')
          elif vcl_ColName in ('gr_naziv',):
            if vxl_ColVal==u'Бензи':
              vxl_ColVal = u'Бензин'
            if not rexs.gr.match(vxl_ColVal):
              vxl_ColVal = None
            if vxl_ColVal and rexs.gas.search(vxl_ColVal):
              if rexs.gasfu.search(pl_row[58]):
                pl_row[-1] = u'f'
              elif rexs.gasnu.search(pl_row[58]):
                pl_row[-1] = u'n'
              else:
                pl_row[-1] = u'?'
          elif vcl_ColName in ('vzpv_naziv',):
            if rexs.vzpv1.match(vxl_ColVal):
              vxl_ColVal = rexs.vzpv1.sub(r'\1\5\2\3', vxl_ColVal)
            if rexs.vzpv2.search(vxl_ColVal):
              vxl_ColVal = rexs.vzpv2.sub(r'\1 \2', vxl_ColVal)
          elif vcl_ColName in ('kl_naziv', 'kl_adresa', 'vz_sasija', 'mr_naziv', 'mdt_oznaka', 'mdvr_oznaka', 'mdvz_oznaka', 'md_naziv_k', 'mt_oznaka', 'vzo_pneumatik1', 'vzo_pneumatik2', 'vzo_pneumatik3', 'vzo_pneumatik4', 'vz_tip_var_ver', 'vz_pneumatici', 'vz_karakter10'):
            vxl_ColVal = vxl_ColVal.upper()
          elif vcl_ColName in ('vz_napomena', 'vz_primedbe', 'vz_zakljucak'):
            vxl_ColVal = rexs.ms.sub(u' ', vxl_ColVal).strip()
          if vxl_ColVal is not None and not vxl_ColVal.strip():
            vxl_ColVal = None
      pl_row[vil_ColIdx] = vxl_ColVal

  return pl_row

#= FUNCTION ============================
# row_fix1
#=======================================
def row_fix1(pl_row):

  for vxl_Idx, vof_Fnc in zip([3, 4, 5, 9, 10, 11, 12, 13, 24, [34, 35, 36, 37]], [fix_kl_naziv, fix_kl_adresa, fix_kl_telefon, fix_mr_naziv, fix_mdt_oznaka, fix_mdvr_oznaka, fix_mdvz_oznaka, fix_md_naziv_k, fix_mto_oznaka, fix_vzo_pneumatik]):
    if type(vxl_Idx)==list:
      for vil_Idx1 in vxl_Idx:
        pl_row[vil_Idx1] = vof_Fnc(pl_row[vil_Idx1])
    else:
      pl_row[vxl_Idx] = vof_Fnc(pl_row[vxl_Idx])

  return pl_row

#= FUNCTION ============================
# row_check
#=======================================
def row_check(pl_cols, pl_row):

  vbl_sert = True
  row = dd(dict(zip([c[0] for c in pl_cols], pl_row)))
  if row.vzpv_naziv:
    vcl_vzpv_oznaka = row.vzpv_naziv.split(u'-')[0].strip()
    if vcl_vzpv_oznaka[0]==u'M':
      if vcl_vzpv_oznaka in (u'M2', 'M3'):
        vcl_vzpv_oznaka = u'M23'
      else:
        vcl_vzpv_oznaka = u'M1x'
    else:
      vcl_vzpv_oznaka = vcl_vzpv_oznaka[0]
    vzkatr = vzkat.get(vcl_vzpv_oznaka, {})
    """
    21 - broj osovina
      15-18 - nosivost po osovinama
      34-37 - pneumatici po osovinama
"""
    if vzkatr:
      vzkatrm = vzkatr.m[:]
      vzkatro = vzkatr.o[:]
      vzkatrf = vzkatr.f[:]
      vil_vz_osovina = (int(pl_row[21]) if (pl_row[21] and int(pl_row[21])<=4) else 0)
      if vil_vz_osovina:
        for vil_col in range(4)[vil_vz_osovina:]:
          try:
            vzkatrm.remove(vil_col+15)
            vzkatrm.remove(vil_col+34)
          except:
            pass
        if vbl_sert:
          for vil_col in vzkatrm:
            if not pl_row[vil_col]:
              vbl_sert = False
              break
        if vbl_sert:
          for vil_col in vzkatrf:
            if pl_row[vil_col]:
              vbl_sert = False
              break
      else:
        vbl_sert = False
  else:
    vbl_sert = False

  return vbl_sert

#= FUNCTION ============================
# vozilo_imp
#=======================================
def vozilo_imp(pb_db=True):

  lcl_vz_sasija = []
  lcl_XlsxFls = g.glob(osp.join(dirs.xlsx, '[0-9][0-9][0-9]-sl-data.xlsx'))
  if lcl_XlsxFls:
    vcl_Tbl = 'vozilo_imp'
    vcl_TblR = 'vozilo_imp_raw'
    cols = coltypes(vcl_Tbl)
    vcl_IIx = 'INSERT INTO _t.{} ({}) VALUES ({});'
    vcl_II = vcl_IIx.format(vcl_Tbl, ', '.join([t[0] for t in cols]), ', '.join(['%s']*len(cols)))
    vcl_DF = 'DELETE FROM _t.{} t WHERE t.vzi_br=%s;'.format(vcl_Tbl)
    vcl_IIR = vcl_IIx.format(vcl_TblR, ', '.join([t[0] for t in cols]), ', '.join(['%s']*len(cols)))
    vcl_DFR = 'DELETE FROM _t.{} t WHERE t.vzi_br=%s;'.format(vcl_TblR)

    if pb_db:
      db = pgdb()
      conn = db.connget()
      crsr = conn.cursor()
      print('    INSERT INTO _t.{} ...'.format(vcl_Tbl))
    for vcl_XlsxFl in sorted(lcl_XlsxFls):
      vil_Idx = int(osp.basename(vcl_XlsxFl).split('-', 1)[0])
      vol_XlsWbk = xlrd.open_workbook(vcl_XlsxFl)
      vol_XlsSht = vol_XlsWbk.sheet_by_index(0)
      vil_ColFirst, vil_ColLast = (0, vol_XlsSht.ncols)
      vil_RowFirst, vil_RowLast = (1, vol_XlsSht.nrows)
      vil_RowTot = vil_RowLast-vil_RowFirst
      if pb_db:
        print('      Inserting from "{}" ...'.format(osp.basename(vcl_XlsxFl)), end=' ')
      if pb_db:
        try:
          crsr.execute(vcl_DFR, [vil_Idx])
          conn.commit()
        except:
          raise
        try:
          crsr.execute(vcl_DF, [vil_Idx])
          conn.commit()
        except:
          raise
      vil_RowCnt = 0
      for vil_RowNo in range(vil_RowFirst, vil_RowLast, 1):
        lxl_Row = [vil_Idx, vil_RowNo]+vol_XlsSht.row_values(vil_RowNo, 0)+['#']
        if lxl_Row[6] not in lcl_vz_sasija:
          lcl_vz_sasija.append(lxl_Row[6])
          lxl_Row = row_fix0(cols, lxl_Row)
          if pb_db:
            try:
              crsr.execute(vcl_IIR, lxl_Row)
            except:
              print(lxl_Row)
              raise
          vbl_sert = row_check(cols, lxl_Row)
          if vbl_sert:
            lxl_Row = row_fix1(lxl_Row)
            if not pb_db:
              pass
            if pb_db:
              try:
                crsr.execute(vcl_II, lxl_Row)
                vil_RowCnt += 1
              except:
                print(lxl_Row)
                raise
      print('total = {:4d} (100%); good = {:4d} ({:0.2f}%); bad = {:4d} ({:0.2f}%) rows. Done.'.format(vil_RowTot, vil_RowCnt, vil_RowCnt/vil_RowTot*100, vil_RowTot-vil_RowCnt, 100-vil_RowCnt/vil_RowTot*100))
      if pb_db:
        conn.commit()
    if pb_db:
      crsr.close()
      db.connret(conn)

#= FUNCTION ============================
# vozilo_imp_gas
#=======================================
def vozilo_imp_gas():

  lcl_CSVFls = g.glob(osp.join(dirs.csv, '[0-9][0-9][0-9]-sl-data-gas.csv'))
  if lcl_CSVFls:
    vcl_Tbl = 'vozilo_imp_gas'
    cols = coltypes(vcl_Tbl)
    vcl_II = 'INSERT INTO _t.{} ({}) VALUES ({});'
    vcl_II = vcl_II.format(vcl_Tbl, ', '.join([t[0] for t in cols]), ', '.join(['%s']*len(cols)))
    vcl_DF = 'DELETE FROM _t.{} t WHERE t.vzg_br=%s;'.format(vcl_Tbl)

    db = pgdb()
    conn = db.connget()
    crsr = conn.cursor()
    print('    INSERT INTO _t.{} ...'.format(vcl_Tbl))
    for vcl_CSVFl in sorted(lcl_CSVFls):
      vil_Idx = int(osp.basename(vcl_CSVFl).split('-', 1)[0])
      print('      Inserting from "{}" ...'.format(osp.basename(vcl_CSVFl)), end=' ')
      try:
        crsr.execute(vcl_DF, [vil_Idx])
        conn.commit()
      except:
        raise
      with open(vcl_CSVFl, 'r') as f:
        csvrdr = csv.reader(f)
        vil_RowNo = 0
        vil_RowCnt = 0
        for lxl_Row in csvrdr:
          vil_RowNo += 1
          lxl_Row = [vil_Idx, vil_RowNo]+lxl_Row
          for vil_ColIdx, (vcl_ColName, vcl_ColType, oxl_ColType) in enumerate(cols):
            if vil_ColIdx>=2:
              vxl_ColVal = lxl_Row[vil_ColIdx].strip()
              if vcl_ColType in ('i', 'f'):
                try:
                  vxl_ColVal = oxl_ColType(vxl_ColVal)
                  if not vxl_ColVal:
                    vxl_ColVal = None
                except:
                  vxl_ColVal = None
              elif vcl_ColType=='d':
                vxl_ColVal = lxl_Row[vil_ColIdx].strip('.')
                lcl_Date = vxl_ColVal.split('.')
                try:
                  vxl_ColVal = '{}-{}-{}'.format(*reversed(lcl_Date))
                except:
                  vxl_ColVal = None
              elif vcl_ColType=='b':
                pass
              else:
                vxl_ColVal = vxl_ColVal.rstrip(u'-/')
                if not vxl_ColVal:
                  vxl_ColVal = None
                else:
                  if vcl_ColName in ('mr_naziv_bt', 'mr_naziv', 'vvt_bt', 'vvt', 'md_naziv_k_bt', 'md_naziv_k', 'vz_sasija_bt', 'vz_sasija', 'vz_motor_bt', 'vz_motor', 'mt_oznaka_bt', 'mt_oznaka', 'vzo_pneumatik_bt', 'vzo_pneumatik', 'kl_naziv', 'kl_iadresa', 'agp_naziv_rz', 'agh_oznaka_rz', 'vzgu_broj_rz', 'agp_naziv_rd', 'agh_oznaka_rd', 'vzgu_broj_rd', 'agp_naziv_mv', 'agh_oznaka_mv', 'vzgu_broj_mv', 'vz_reg'):
                    vxl_ColVal = vxl_ColVal.upper()
                  elif vcl_ColName in ('mdvr_oznaka',):
                    if '\n' in vxl_ColVal:
                      vxl_ColVal = vxl_ColVal.split('\n', 1)[0]
              lxl_Row[vil_ColIdx] = vxl_ColVal
          try:
            crsr.execute(vcl_II, lxl_Row)
            vil_RowCnt += 1
          except:
            raise
        print('{}/{} rows. Done.'.format(vil_RowCnt, vil_RowNo))
        conn.commit()
    crsr.close()
    db.connret(conn)

#= FUNCTION ============================
# vozilo_imp_gu
#=======================================
def vozilo_imp_gu():

  lcl_CSVFls = g.glob(osp.join(dirs.csv, '[0-9][0-9][0-9]-sl-data-gu-[mr][vdz].csv'))
  if lcl_CSVFls:

    agu = {
           'mv': 10,
           'rd': 20,
           'rz': 30,
          }

    vcl_Tbl = 'vozilo_imp_gu'
    cols = coltypes(vcl_Tbl)
    vcl_II = 'INSERT INTO _t.{} ({}) VALUES ({});'
    vcl_II = vcl_II.format(vcl_Tbl, ', '.join([t[0] for t in cols]), ', '.join(['%s']*len(cols)))
    vcl_DF = 'DELETE FROM _t.{} t WHERE t.vzgu_br=%s;'.format(vcl_Tbl)

    db = pgdb()
    conn = db.connget()
    crsr = conn.cursor()
    print('    INSERT INTO _t.{} ...'.format(vcl_Tbl))
    vil_IdxC = -1
    for vcl_CSVFl in sorted(lcl_CSVFls):
      vil_Idx = int(osp.basename(vcl_CSVFl).split('-', 1)[0])
      vcl_Gu = osp.basename(vcl_CSVFl).rsplit('-', 1)[-1].split('.')[0]
      vil_Gu = agu[vcl_Gu]
      print('      Inserting from "{}" ...'.format(osp.basename(vcl_CSVFl)), end=' ')
      if vil_IdxC!=vil_Idx:
        vil_IdxC = vil_Idx
        try:
          crsr.execute(vcl_DF, [vil_Idx])
          conn.commit()
        except:
          raise
      with open(vcl_CSVFl, 'r') as f:
        csvrdr = csv.reader(f)
        vil_RowNo = 0
        vil_RowCnt = 0
        for lxl_Row in csvrdr:
          vil_RowNo += 1
          lxl_Row = [vil_Idx, vil_RowNo, vil_Gu, vcl_Gu]+lxl_Row[1:]
          for vil_ColIdx, (vcl_ColName, vcl_ColType, oxl_ColType) in enumerate(cols):
            if vil_ColIdx>=4:
              vxl_ColVal = lxl_Row[vil_ColIdx].strip()
              if vcl_ColType in ('i', 'f'):
                try:
                  vxl_ColVal = oxl_ColType(vxl_ColVal)
                  if not vxl_ColVal:
                    vxl_ColVal = None
                except:
                  vxl_ColVal = None
              elif vcl_ColType=='d':
                vxl_ColVal = lxl_Row[vil_ColIdx].strip('.')
                lcl_Date = vxl_ColVal.split('.')
                try:
                  vxl_ColVal = '{}-{}-{}'.format(*reversed(lcl_Date))
                except:
                  vxl_ColVal = None
              elif vcl_ColType=='b':
                pass
              else:
                vxl_ColVal = vxl_ColVal.rstrip(u'-/')
                if not vxl_ColVal:
                  vxl_ColVal = None
                else:
                  if vcl_ColName in ('agp_naziv', 'agh_oznaka'):
                    vxl_ColVal = vxl_ColVal.upper()
              lxl_Row[vil_ColIdx] = vxl_ColVal
          try:
            crsr.execute(vcl_II, lxl_Row)
            vil_RowCnt += 1
          except:
            raise
        print('{}/{} rows. Done.'.format(vil_RowCnt, vil_RowNo))
        conn.commit()
    crsr.close()
    db.connret(conn)

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

  vozilo_imp()
  acc2csv()
  vozilo_imp_gas()
  vozilo_imp_gu()
