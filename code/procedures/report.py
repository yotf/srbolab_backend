#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
import os
import os.path as osp
import locale as lc

# site-packages
from reportlab.platypus import SimpleDocTemplate, PageBreak, Spacer, Paragraph, Image, Table, TableStyle
from reportlab.lib import colors
from reportlab.pdfgen import canvas
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.pagesizes import A4, portrait
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT, TA_JUSTIFY

from box import SBox as dd
from datetime import datetime as dtdt

# local
from .pgdb import pgdb
from . import util as utl
from .cfg import getpgdb, sysdf

#---------------------------------------
# setings
#---------------------------------------
lc.setlocale(lc.LC_ALL, '')

#---------------------------------------
# global variables
#---------------------------------------
db = pgdb()

imgs = dd(
          {
           u'sl1': osp.join(sysdf.reps, u'srbolab-logo.png'),
           u'abs1': osp.join(sysdf.reps, u'abs-logo.png'),
          }
         )

fnts = dd(
          {
           u's6': 6,
           u's7': 7,
           u's8': 8,
           u's9': 9,
           u's10': 10,
           u's11': 11,
           u's12': 12,
           u's14': 14,
          }
         )

fntn = dd(
          {
           u'tahoma': 'Tahoma',
           u'tahomab': 'Tahoma Bold',
           u'tahomai': 'Tahoma Italic',
           u'tahomabi': 'Tahoma Bold Italic',
           u'verdana': 'Verdana',
           u'verdanab': 'Verdana Bold',
           u'verdanai': 'Verdana Italic',
           u'verdanabi': 'Verdana Bold Italic',
           u'consolas': 'Consolas',
           u'consolasb': 'Consolas Bold',
           u'consolasi': 'Consolas Italic',
           u'consolabi': 'Consolas Bold Italic',
           u'couriernew': 'Courier New',
           u'couriernewb': 'Courier New Bold',
           u'couriernewi': 'Courier New Italic',
           u'couriernewbi': 'Courier New Bold Italic',
          }
         )

lts = dd(
         {
          u't025': 0.5,
          u't05': 0.5,
          u't075': 0.75,
          u't1': 1,
          u't125': 1.25,
          u't15': 1.5,
          u't175': 1.75,
         }
        )

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= FUNCTION ============================
# nvl
#=======================================
def nvl(px_cval, px_nval=u''):

  return (px_nval if px_cval is None else px_cval)

#= FUNCTION ============================
# regfonts
#=======================================
def regfonts():

  """  Register .ttf fonts"""

  dcl_Fonts = {
               'Tahoma': 'tahoma.ttf',
               'Tahoma Bold': 'tahomabd.ttf',
               'Tahoma Italic': 'tahomai.ttf',
               'Tahoma Bold Italic': 'tahomabdi.ttf',
               'Verdana': 'verdana.ttf',
               'Verdana Bold': 'verdanab.ttf',
               'Verdana Italic': 'verdanai.ttf',
               'Verdana Bold Italic': 'verdanaz.ttf',
               'Courier New': 'cour.ttf',
               'Courier New Bold': 'courbd.ttf',
               'Courier New Italic': 'couri.ttf',
               'Courier New Bold Italic': 'courbi.ttf',
               'Consolas': 'consola.ttf',
               'Consolas Bold': 'consolab.ttf',
               'Consolas Italic': 'consolai.ttf',
               'Consolas Bold Italic': 'consolaz.ttf',
              }
  for vcl_FntNme, vcl_FntFle in dcl_Fonts.items():
    print(sysdf)
    print(sysdf.assets)
    print("ASSETS")
    pdfmetrics.registerFont(TTFont(vcl_FntNme, osp.join( sysdf.assets, 'reports', 'fonts', vcl_FntFle)))

regfonts()

#= FUNCTION ============================
# tbl_ttl
#=======================================
def tbl_ttl(pc_text):

  oxl_table = Table([[Paragraph(pc_text, pss.acfb)]], hAlign='CENTER')
  oxl_table.setStyle(tss.alng)

  return oxl_table

#= FUNCTION ============================
# tbl_txt
#=======================================
def tbl_txt(pc_text):

  oxl_table = Table([[Paragraph(pc_text, pss.alfn)]], hAlign='LEFT')
  oxl_table.setStyle(tss.alng)

  return oxl_table

#= CLASS ===============================
#  Data
#=======================================
class Data():

  #= METHOD ==============================
  #  __init__
  #=======================================
  def __init__(self):

    self.fir = dd(self.fir())
    self.cd = dtdt.date(dtdt.today()).strftime('%d.%m.%Y')

  #= METHOD ==============================
  #  dget
  #=======================================
  def dget(self, pc_Rep, pd_Pars):

    pars = dd(pd_Pars)
    vcl_Rep = pc_Rep.lower()
    if vcl_Rep=='potvrda':
        self.h = [dd(row) for row in self.potvrda_h(pars.pr_id)]
        self.b = [dd(row) for row in self.potvrda_b(pars.pr_id)]
        self.f = [dd(row) for row in self.potvrda_f(pars.pr_id)]
    elif vcl_Rep.startswith('zapisnik'):
        self.pr = dd(self.predmet_b(pars.pr_id))
    elif vcl_Rep=='neusaglasenost':
        self.pr = dd(self.predmet_b(pars.pr_id))
    elif vcl_Rep=='raspored':
      self.rsp = [dd(row) for row in self.raspored(pars.kn_datum)]

  #= METHOD ==============================
  # fir
  #=======================================
  def fir(self, pi_fir_id=10):

    conn = db.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc('public.f_firma', [pi_fir_id])
      vxl_res = crsr.fetchall()[0]
    except:
      raise
    finally:
      crsr.close()
      db.connret(conn)

    return vxl_res

  #= METHOD ==============================
  # raspored
  #=======================================
  def raspored(self, pc_kn_datum):

    conn = db.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc('sys.f_r_raspored', [pc_kn_datum])
      vxl_res = crsr.fetchall()
    except:
      raise
    finally:
      crsr.close()
      db.connret(conn)

    return vxl_res

  #= METHOD ==============================
  # predmet_b
  #=======================================
  def predmet_b(self, pi_pr_id):

    conn = db.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc('hmlg.f_r_predmet', [pi_pr_id])
      vxl_res = crsr.fetchall()[0]
    except:
      raise
    finally:
      crsr.close()
      db.connret(conn)

    return vxl_res

  #= METHOD ==============================
  # potvrda_h
  #=======================================
  def potvrda_h(self, pi_pr_id):

    conn = db.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc('hmlg.f_r_potvrda_h', [pi_pr_id])
      vxl_res = crsr.fetchall()
      print('{}'.format(vxl_res))
    except:
      raise
    finally:
      crsr.close()
      db.connret(conn)

    return vxl_res

  #= METHOD ==============================
  # potvrda_b
  #=======================================
  def potvrda_b(self, pi_pr_id):

    conn = db.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc('hmlg.f_r_potvrda_b', [pi_pr_id])
      vxl_res = crsr.fetchall()
    except:
      raise
    finally:
      crsr.close()
      db.connret(conn)

    return vxl_res

  #= METHOD ==============================
  # potvrda_f
  #=======================================
  def potvrda_f(self, pi_pr_id):

    conn = db.connget()
    crsr = conn.cursor()
    try:
      crsr.callproc('hmlg.f_r_potvrda_f', [pi_pr_id])
      vxl_res = crsr.fetchall()
    except:
      raise
    finally:
      crsr.close()
      db.connret(conn)

    return vxl_res

data = Data()

#= CLASS ===============================
#  ParagStyles
#=======================================
class ParagStyles():

  #= METHOD ==============================
  #  __init__
  #=======================================
  def __init__(self, pi_FontSize=10, pc_FntName='Tahoma'):

    self.fntnm = pc_FntName
    self.fntnmb = u'{} Bold'.format(pc_FntName)
    self.fntsz = pi_FontSize

  @property
  #= PROPERTY ============================
  #  acfn
  #=======================================
  def acfn(self):

    return ParagraphStyle(name='acfn', fontName=self.fntnm, fontSize=self.fntsz, alignment=TA_CENTER)

  @property
  #= PROPERTY ============================
  #  alfn
  #=======================================
  def alfn(self):

    return ParagraphStyle(name='alfn', fontName=self.fntnm, fontSize=self.fntsz, alignment=TA_LEFT)

  @property
  #= PROPERTY ============================
  #  arfn
  #=======================================
  def arfn(self):

    return ParagraphStyle(name='arfn', fontName=self.fntnm, fontSize=self.fntsz, alignment=TA_RIGHT)

  @property
  #= PROPERTY ============================
  #  acfb
  #=======================================
  def acfb(self):

    return ParagraphStyle(name='acfb', fontName=self.fntnmb, fontSize=self.fntsz, alignment=TA_CENTER)

  @property
  #= PROPERTY ============================
  #  alfb
  #=======================================
  def alfb(self):

    return ParagraphStyle(name='alfb', fontName=self.fntnmb, fontSize=self.fntsz, alignment=TA_LEFT)

  @property
  #= PROPERTY ============================
  #  arfb
  #=======================================
  def arfb(self):

    return ParagraphStyle(name='arfb', fontName=self.fntnmb, fontSize=self.fntsz, alignment=TA_RIGHT)

pss = ParagStyles(fnts.s10)

#= CLASS ===============================
#  TblStyles
#=======================================
class TblStyles:

  #= METHOD ==============================
  #  __init__
  #=======================================
  def __init__(self, *args, **kwargs):

    pass

  @property
  #= PROPERTY ============================
  #  dflt
  #=======================================
  def dflt(self):

    return TableStyle(
                      [
                       ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
                       ('BOTTOMPADDING', (0, 0), (-1, -1), 1),
                       ('TOPPADDING', (0, 0), (-1, -1), 1),
                       ('LEFTPADDING', (0, 0), (-1, -1), 3),
                       ('RIGHTPADDING', (0, 0), (-1, -1), 3),
                      ]
                     )

  #= METHOD ==============================
  #  addgrid
  #=======================================
  def addgrid(self, po_ts):

    oxl_ts = po_ts
    oxl_ts.add('INNERGRID', (0, 0), (-1, -1), lts.t05, colors.black),
    oxl_ts.add('BOX', (0, 0), (-1, -1), lts.t05, colors.black),

    return oxl_ts

  @property
  #= PROPERTY ============================
  #  alng
  #=======================================
  def alng(self):

    oxl_ts = self.dflt
    oxl_ts.add('ALIGN', (0, 0), (-1, -1), 'LEFT')

    return oxl_ts

  @property
  #= PROPERTY ============================
  #  acng
  #=======================================
  def acng(self):

    oxl_ts = self.dflt
    oxl_ts.add('ALIGN', (0, 0), (-1, -1), 'CENTER')

    return oxl_ts

  @property
  #= PROPERTY ============================
  #  arng
  #=======================================
  def arng(self):

    oxl_ts = self.dflt
    oxl_ts.add('ALIGN', (0, 0), (-1, -1), 'RIGHT')

    return oxl_ts

  @property
  #= PROPERTY ============================
  #  alg
  #=======================================
  def alg(self):

    return self.addgrid(self.alng)

  @property
  #= PROPERTY ============================
  #  acg
  #=======================================
  def acg(self):

    return self.addgrid(self.acng)

  @property
  #= PROPERTY ============================
  #  arg
  #=======================================
  def arg(self):

    return self.addgrid(self.arng)

tss = TblStyles()

#= CLASS ===============================
# SimpleDocTemplateNP
#=======================================
class SimpleDocTemplateNP(SimpleDocTemplate):

  """SimpleDocTemplate with frame with no padding"""

  #= METHOD ==============================
  # addPageTemplates
  #=======================================
  def addPageTemplates(self, pageTemplates):

    if pageTemplates:
      oxl_fme = pageTemplates[0].frames[0]
      oxl_fme._leftPadding=0
      oxl_fme._rightPadding=0
      oxl_fme._topPadding=0
      oxl_fme._bottomPadding=0
      oxl_fme._geom()
    SimpleDocTemplate.addPageTemplates(self, pageTemplates)

#= CLASS ===============================
#  HdFtCanvas
#=======================================
class HdFtCanvas(canvas.Canvas):

  #= METHOD ==============================
  #  __init__
  #=======================================
  def __init__(self, *args, **kwargs):

    canvas.Canvas.__init__(self, *args, **kwargs)
    self.pages = []
    self.width, self.height = self._pagesize

  #= METHOD ==============================
  #  showPage
  #=======================================
  def showPage(self):

    self.pages.append(dict(self.__dict__))
    self._startPage()

  #= METHOD ==============================
  #  save
  #=======================================
  def save(self):

    vil_pg_cnt = len(self.pages)
    for oxl_page in self.pages:
      self.__dict__.update(oxl_page)
      self.drawHeaderFooter(vil_pg_cnt)
      canvas.Canvas.showPage(self)
    canvas.Canvas.save(self)

  #= METHOD ==============================
  #  drawHeaderFooter
  #=======================================
  def drawHeaderFooter(self, pi_pg_cnt):

    self.saveState()

    oxl_img = Image(imgs.sl1, kind='proportional')
    oxl_img.drawHeight = 10*mm
    oxl_img.drawWidth = 37*mm
    oxl_img.hAlign = 'CENTER'

    vcl_text = ' '.join(
                        [
                         '{}<br/>'.format(data.fir.fir_naziv),
                         data.fir.fir_adresa_sediste,
                         'telefon: {}'.format(data.fir.fir_tel1),
                         'mail: {}'.format(data.fir.fir_mail)
                        ]
                       )
    oxl_pr = Paragraph(vcl_text, pss.acfn)

    lll_data = [[oxl_img, oxl_pr]]
    oxl_table = Table(lll_data, colWidths=[40*mm, 150*mm], hAlign='LEFT')
    oxl_table.setStyle(tss.acg)
    oxl_table.wrapOn(self, 0, 0)
    oxl_table.drawOn(self, 10*mm, A4[1]-20*mm+1)

    lll_dataf = [[Paragraph('Strana {} od {}'.format(self._pageNumber, pi_pg_cnt), pss.arfn)]]
    oxl_tablef = Table(lll_dataf, colWidths=[190*mm], hAlign='LEFT')
    oxl_ts = tss.arng
    oxl_ts.add('LINEABOVE', (0, 0), (-1, -1), lts.t05, colors.black)
    oxl_tablef.setStyle(oxl_ts)
    oxl_tablef.wrapOn(self, 0, 0)
    oxl_tablef.drawOn(self, 10*mm, 4*mm)

#= CLASS ===============================
#  HdFtCanvasZap
#=======================================
class HdFtCanvasZap(canvas.Canvas):

  #= METHOD ==============================
  #  __init__
  #=======================================
  def __init__(self, *args, **kwargs):

    canvas.Canvas.__init__(self, *args, **kwargs)
    self.pages = []
    self.width, self.height = self._pagesize

  #= METHOD ==============================
  #  showPage
  #=======================================
  def showPage(self):

    self.pages.append(dict(self.__dict__))
    self._startPage()

  #= METHOD ==============================
  #  save
  #=======================================
  def save(self):

    vil_pg_cnt = len(self.pages)
    for oxl_page in self.pages:
      self.__dict__.update(oxl_page)
      self.drawHeaderFooter(vil_pg_cnt)
      canvas.Canvas.showPage(self)
    canvas.Canvas.save(self)

  #= METHOD ==============================
  #  drawHeaderFooter
  #=======================================
  def drawHeaderFooter(self, pi_pg_cnt):

    self.saveState()

    oxl_img = Image(imgs.sl1, kind='proportional')
    oxl_img.drawHeight = 10*mm
    oxl_img.drawWidth = 37*mm
    oxl_img.hAlign = 'CENTER'

    vcl_text = ' '.join(
                        [
                         '{}<br/>'.format(data.fir.fir_naziv),
                         data.fir.fir_adresa_sediste,
                         'telefon: {}'.format(data.fir.fir_tel1),
                         'mail: {}'.format(data.fir.fir_mail)
                        ]
                       )
    oxl_pr = Paragraph(vcl_text, pss.acfn)

    lll_datah = [[oxl_img, oxl_pr]]
    oxl_tableh = Table(lll_datah, colWidths=[40*mm, 150*mm], hAlign='LEFT')
    oxl_tableh.setStyle(tss.acg)
    oxl_tableh.wrapOn(self, 0, 0)
    oxl_tableh.drawOn(self, 10*mm, A4[1]-20*mm+1)

    if self._pageNumber==pi_pg_cnt:
      oxl_tables = zap.tbl_sgn
      oxl_tables.wrapOn(self, 0, 0)
      oxl_tables.drawOn(self, 10*mm, A4[1]-280*mm)

    lll_dataf = [[Paragraph('Strana {} od {}'.format(self._pageNumber, pi_pg_cnt), pss.arfn)]]
    oxl_tablef = Table(lll_dataf, colWidths=[190*mm], hAlign='LEFT')
    oxl_ts = tss.arng
    oxl_ts.add('LINEABOVE', (0, 0), (-1, -1), lts.t05, colors.black)
    oxl_tablef.setStyle(oxl_ts)
    oxl_tablef.wrapOn(self, 0, 0)
    oxl_tablef.drawOn(self, 10*mm, 4*mm)

    self.restoreState()

#= CLASS ===============================
#  HdFtCanvasPot
#=======================================
class HdFtCanvasPot(canvas.Canvas):

  #= METHOD ==============================
  #  __init__
  #=======================================
  def __init__(self, *args, **kwargs):

    canvas.Canvas.__init__(self, *args, **kwargs)
    self.pages = []
    self.width, self.height = self._pagesize

  #= METHOD ==============================
  #  showPage
  #=======================================
  def showPage(self):

    self.pages.append(dict(self.__dict__))
    self._startPage()

  #= METHOD ==============================
  #  save
  #=======================================
  def save(self):

    vil_pg_cnt = len(self.pages)
    for oxl_page in self.pages:
      self.__dict__.update(oxl_page)
      self.drawWatermark(vil_pg_cnt)
      canvas.Canvas.showPage(self)
    canvas.Canvas.save(self)

  #= METHOD ==============================
  #  drawWatermark
  #=======================================
  def drawWatermark(self, pi_pg_cnt):

    self.saveState()

    vcl_WMText1 = 'NEZVANI??NA'
    vcl_WMText2 = 'VERZIJA'
    self.setFont('Tahoma', 100)
    self.setStrokeColor((0, 0, 0))
    self.setFillColor(colors.Color(255, 255, 255, alpha=0.1))
    self.setLineWidth(0.5)
    oxl_txt = self.beginText()
    oxl_txt.setTextRenderMode(2)
    self._code.append(oxl_txt.getCode())
    self.rotate(45)
    self.drawCentredString(180*mm, 25*mm, vcl_WMText1)

    oxl_txt = self.beginText()
    oxl_txt.setTextRenderMode(2)
    self._code.append(oxl_txt.getCode())
    self.drawCentredString(180*mm, -10*mm, vcl_WMText2)

    self.restoreState()

#= CLASS ===============================
# potvrda
#=======================================
class potvrda(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(
               self,
               pi_PrId,
               pc_PdfFile,
               pb_Test=False,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10*mm,
               pn_bottomMargin=10*mm,
               pn_leftMargin=10*mm,
               pn_rightMargin=10*mm
              ):

    SimpleDocTemplate.__init__(
                               self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin
                              )

    data.dget(self.__class__.__name__, dd({'pr_id': pi_PrId}))
    self.test = pb_Test
    self.Title = u'IZVOD IZ BAZE O TEHNI??KIM KARAKTERISTIKAMA VOZILA'
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()

  #= METHOD ==============================
  # data_fir
  #=======================================
  def data_fir(self):

    vcl_text = '<br/>'.join(
                            [
                             data.fir.fir_naziv,
                             data.fir.fir_adresa_sediste,
                             data.fir.fir_opis,
                             'telefon: {}'.format(data.fir.fir_tel1),
                             'mail: {}'.format(data.fir.fir_mail)
                            ]
                           )
    oxl_pr = Paragraph(vcl_text, pss.alfb)

    return oxl_pr

  #= METHOD ==============================
  # img_sl
  #=======================================
  def img_sl(self):

    oxl_img = Image(imgs.sl1, kind='proportional')
    oxl_img.drawHeight = 30*mm
    oxl_img.drawWidth = 115*mm
    oxl_img.hAlign = 'CENTER'

    return oxl_img

  #= METHOD ==============================
  # tbl_fir
  #=======================================
  def tbl_fir(self):

    oxl_img = self.img_sl()
    oxl_pr = self.data_fir()
    oxl_table = Table([[oxl_img, oxl_pr]], colWidths=[115*mm, 75*mm], hAlign='LEFT')
    oxl_table.setStyle(tss.alg)

    return oxl_table

  #= METHOD ==============================
  # tbl_h
  #=======================================
  def tbl_h(self):

    lll_data = []
    for vil_row, oxl_row in enumerate(data.h):
      lll_data.append([Paragraph(nvl(oxl_row.h_lbl), pss.alfn), Paragraph(nvl(oxl_row.h_val), pss.alfn)])
    oxl_table = Table(lll_data, colWidths=[50*mm, 65*mm], hAlign='LEFT')
    oxl_table.setStyle(tss.alg)

    return oxl_table

  #= METHOD ==============================
  # tbl_b
  #=======================================
  def tbl_b(self):

    lll_data = []
    for vil_row, oxl_row in enumerate(data.b):
      lll_data.append(
                      [
                       Paragraph(nvl(oxl_row.tis_lbl_coc), pss.acfn),
                       Paragraph(nvl(oxl_row.tis_lbl_drvlc), pss.acfn),
                       Paragraph(nvl(oxl_row.tis_desc), pss.alfn),
                       Paragraph(nvl(oxl_row.tis_value), pss.alfn),
                      ]
                     )

    oxl_table = Table(lll_data, colWidths=[11*mm, 15*mm, 100*mm, 64*mm], hAlign='LEFT')
    oxl_table.setStyle(tss.alg)

    return oxl_table

  #= METHOD ==============================
  # tbl_f
  #=======================================
  def tbl_f(self):

    lll_data = []
    for vil_row, oxl_row in enumerate(data.f):
      lll_data.append([Paragraph(nvl(oxl_row.vz_sert_lbl), pss.alfn), Paragraph(nvl(oxl_row.vz_sert), pss.alfn)])
    oxl_table = Table(lll_data, colWidths=[80*mm, 110*mm], hAlign='LEFT')
    oxl_table.setStyle(tss.alg)

    return oxl_table

  #= METHOD ==============================
  # tbl_ftr
  #=======================================
  def tbl_ftr(self):

    lll_data = []
    lll_data.append([Paragraph(u'POTVR??UJEMO DA JE OVO VOZILO PROIZVEDENO U SKLADU SA EEC/ECE REGULATIVIMA', pss.alfb)])
    lll_data.append([Paragraph(u'Ovaj dokument se izdaje (bez pregleda vozila) na osnovu saobra??ajne dozvole i va??i bez pe??ata i potpisa', pss.alfn)])

    oxl_table = Table(lll_data, hAlign='LEFT')
    oxl_table.setStyle(tss.alng)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    self.DocElm.append(Spacer(0*mm, 0*mm))
    self.DocElm.append(self.tbl_fir())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(self.tbl_h())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(self.tbl_b())

    self.DocElm.append(self.tbl_f())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(self.tbl_ftr())

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    if self.test:
      self.build(self.DocElm, canvasmaker=HdFtCanvasPot)
    else:
      self.build(self.DocElm)

#= CLASS ===============================
# zapisnici
#=======================================
class zapisnici():

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self):

    pass

  @property
  #= PROPERTY ============================
  # tbl_zbr
  #=======================================
  def tbl_zbr(self):

    lll_data = []
    lll_data = [[Paragraph(u'Broj:', pss.acfn), Paragraph(nvl(data.pr.pr_broj), pss.acfn)]]
    oxl_table = Table(lll_data, colWidths=[20*mm, 40*mm], hAlign='CENTER')
    oxl_ts = tss.acng
    oxl_ts.add('LINEBELOW', (1, 0), (1, 0), lts.t05, colors.black)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  @property
  #= PROPERTY ============================
  # tbl_zkl
  #=======================================
  def tbl_zkl(self):

    lll_data = []
    lll_data.append([Paragraph(u'Podnosilac zahteva:', pss.alfn), Paragraph(nvl(data.pr.kl_naziv), pss.alfn)])
    lll_data.append([Paragraph(u'Adresa:', pss.alfn), Paragraph(nvl(data.pr.kl_adresa), pss.alfn)])
    lll_data.append([Paragraph(u'Kontakt:', pss.alfn), Paragraph(nvl(data.pr.kl_telefon), pss.alfn)])
    oxl_table = Table(lll_data, colWidths=[35*mm, 150*mm], hAlign='LEFT')
    oxl_ts = tss.acng
    oxl_ts.add('LINEBELOW', (1, 0), (1, -1), lts.t05, colors.black)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # tbl_zvd
  #=======================================
  def tbl_zvd(self, pc_zap):

    lcl_vzdok = nvl(data.pr.pvd_oznaka).split(u'/')
    lcl_vzdokx = [u'']*4
    for vcl_vzdok in lcl_vzdok:
      if vcl_vzdok==u'SD':
        lcl_vzdokx[0] = u'x'
      elif vcl_vzdok==u'OD':
        lcl_vzdokx[1] = u'x'
      elif vcl_vzdok==u'COC':
        lcl_vzdokx[2] = u'x'
      elif vcl_vzdok==u'PP':
        lcl_vzdokx[3] = u'x'

    lcl_extra = [u'']*4
    if pc_zap==u'M1':
      lcl_extra = [u'STAKLA:', u'PR. PLO??ICA (VW):', u'GORIVO:', u'AC:']
    elif pc_zap==u'M2M3':
      lcl_extra = [u'', u'', u'STAKLA:', u'GORIVO:']
    elif pc_zap==u'L':
      lcl_extra = [u'', u'', u'', u'GORIVO:']
    elif pc_zap==u'N1':
      lcl_extra = [u'', u'STAKLA:', u'PR. PLO??ICA (VW):', u'GORIVO:']
    elif pc_zap==u'N2N3':
      lcl_extra = [u'', u'', u'STAKLA:', u'GORIVO:']
      
    lll_data = [
                [u'Dostavljena dokumentacija', u'', u'', u'', u''],
                [lcl_vzdokx[0], u'Saobra??ajna dozvola', u'', lcl_extra[0], u''],
                [lcl_vzdokx[1], u'Odgovaraju??i dokument', u'', lcl_extra[1], u''],
                [lcl_vzdokx[2], u'COC dokument', u'', lcl_extra[2], u''],
                [lcl_vzdokx[3], u'Potvrda pr. proizvo??a??a', u'', lcl_extra[3], u''],
               ]

    lll_dataf = []
    for lcl_row in lll_data:
      lll_dataf.append(
                       [
                        Paragraph(lcl_row[0], pss.acfn),
                        Paragraph(lcl_row[1], pss.alfn),
                        Paragraph(lcl_row[2], pss.alfn),
                        Paragraph(lcl_row[3], pss.arfn),
                        Paragraph(lcl_row[4], pss.acfn),
                       ]
                      )
    oxl_table = Table(lll_dataf, colWidths=[7*mm, 48*mm, 90*mm, 38*mm, 7*mm], hAlign='LEFT')

    oxl_ts = tss.alng
    oxl_ts.add('BOX', (0, 0), (-1, -1), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, 0), (1, -1), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, 0), (1, 0), lts.t05, colors.black)
    oxl_ts.add('INNERGRID', (0, 1), (1, -1), lts.t05, colors.black),
    oxl_ts.add('SPAN', (0, 0), (1, 0))
    oxl_ts.add('SPAN', (2, 0), (2, -1))
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # tbl_hmlgo
  #=======================================
  def tbl_hmlgo(self, pc_zap=u'*'):

    if pc_zap==u'O':
      lll_data = [
                  [u'Zadnje poziciono svetlo', u'', u'Zadnji katadiopteri', u'', u'Bo??ni katadiopteri', u''],
                  [u'Zadnje stop svetlo', u'', u'Zadnje gabaritno svetlo', u'', u'Pneumatici', u''],
                  [u'Zadnji pokaziva?? pravca', u'', u'Prednje gabaritno svetlo', u'', u'', u''],
                  [u'Svetla registarske tablice', u'', u'Bo??na poziciona svetla', u'', u'', u''],
                 ]
    else:
      lll_data = [
                  [u'Prednje glavno svetlo', u'', u'Zadnji pokaziva?? pravca', u'', u'Zadnje gabaritno svetlo', u''],
                  [u'Prednje poziciono svetlo', u'', u'Svetla registarske tablice', u'', u'Bo??na poziciona svetla', u''],
                  [u'Prednje svetlo za maglu', u'', u'Zadnji katadiopteri', u'', u'Bo??ni katadiopteri', u''],
                  [u'Prednji pokaziva?? pravca', u'', u'Svetla za vo??nju u nazad', u'', u'Sigurnosni pojasevi', u''],
                  [u'Dnevno svetlo za vo??nju', u'', u'Sv. za vo??nju pri skretanju', u'', u'Sigurnosna stakla', u''],
                  [u'Zadnje poziciono svetlo', u'', u'Zadnja svetla za maglu', u'', u'Retrovizori', u''],
                  [u'Zadnje stop svetlo', u'', u'Parkirno svetlo', u'', u'Vu??ni ure??aj', u''],
                  [u'Pomo??no stop svetlo', u'', u'Prednje gabaritno svetlo', u'', u'Pneumatici', u''],
                  [u'', u'', u'', u'', u'', u''],
                 ]
    lll_data.insert(0, [u'KONTROLISANJE HOMOLOGACIONIH OZNAKA', u'', u'', u'', u'', u''])
    lll_data.append(['x = ure??aj-sistem postoji na vozilu,', u'', u'- = ure??aj-sistem ne postoji na vozilu,', u'', u'N/P = nije primenljivo', u''])
    vil_rows = len(lll_data)
    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append(
                       [
                        Paragraph(lcl_row[0], (pss.acfb if vil_row==0 else pss.alfn)),
                        Paragraph(lcl_row[1], pss.acfn),
                        Paragraph(lcl_row[2], (pss.acfn if vil_row==vil_rows else pss.alfn)),
                        Paragraph(lcl_row[3], pss.alfn),
                        Paragraph(lcl_row[4], (pss.acfn if vil_row==vil_rows else pss.alfn)),
                        Paragraph(lcl_row[5], pss.alfn),
                       ]
                      )
    oxl_table = Table(lll_dataf, rowHeights=[5*mm]*len(lll_data), colWidths=[56*mm, 7*mm, 56*mm, 8*mm, 55*mm, 8*mm], hAlign='LEFT')

    oxl_ts = tss.alng
    oxl_ts.add('ALIGN', (0, 0), (-1, 0), 'CENTER')
    oxl_ts.add('ALIGN', (0, -1), (-1, -1), 'CENTER')
    oxl_ts.add('INNERGRID', (0, 0), (-1, -2), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, 1), (-1, -1), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, -1), (-1, -1), lts.t05, colors.black)
    oxl_ts.add('SPAN', (0, 0), (-1, 0))
    oxl_ts.add('SPAN', (0, -1), (1, -1))
    oxl_ts.add('SPAN', (2, -1), (3, -1))
    oxl_ts.add('SPAN', (4, -1), (-1, -1))
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # tbl_vzdata
  #=======================================
  def tbl_vzdata(self, pc_zap=u'*'):

    lll_data = []
    lll_data.append([u'0.10.', u'(E)', u'Identifikaciona oznaka (VIN)', data.pr.vz_sasija, u''])
    if pc_zap!=u'O':
      lll_data.append([u'21', u'(P)', u'Oznaka motora', data.pr.mto_oznaka, u''])
    lll_data.append([u'0.1.', u'(D.1)', u'Marka (komercijalni naziv proizvo??a??a)', data.pr.mr_naziv, u''])
    lll_data.append([u'0.2.1.', u'(D.3)', u'Komercijalna oznaka', data.pr.md_naziv_k, u''])
    lll_data.append([u'0.4', u'(J)', u'Vrsta', data.pr.vz_kategorija, u''])
    lll_data.append([u'38.', u'(J.1)', u'Oznaka oblika karoserije', data.pr.vz_vzk, u''])
    lll_data.append([u'0.2.', u'(D.2)', u'Tip / Varijanta / Verzija', data.pr.vz_mdtvv, u''])
    lll_data.append([u'16.', u'(F.1)', u'Najve??a dozvoljena masa [kg]', data.pr.vz_masa_max, u''])
    lll_data.append([u'16.2.', u'(N)', u'Najve??e dozvolj. oso. optere??enje [kg]', data.pr.vz_os_nosivost, u''])
    lll_data.append([u'1.', u'(L)', u'Broj osovina i to??kova', data.pr.vz_os_broj, u''])
    if pc_zap!=u'O':
      lll_data.append([u'42.', u'(S.1)', u'Broj mesta za sedenje', data.pr.vz_mesta_sedenje, u''])
    lll_data.append([u'35.', u'', u'Pneumatici', data.pr.vz_os_pneumatici, u''])
    lll_data.append([u'Ure??aj za spajanje vu??nog i priklju??nog vozila (da/ne)', u'', u'', data.pr.vz_kuka, u''])
    lll_data.append([u'O??itana kilometra??a', u'', u'', data.pr.vz_km, u''])

    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append(
                       [
                        Paragraph(lcl_row[0], (pss.acfn if vil_row<12 else pss.alfn)),
                        Paragraph(lcl_row[1], pss.acfn),
                        Paragraph(lcl_row[2], pss.alfn),
                        Paragraph(lcl_row[3], pss.alfn),
                        Paragraph(lcl_row[4], pss.acfn),
                       ]
                      )
    oxl_table = Table(lll_dataf, colWidths=[13*mm, 13*mm, 63*mm, 94*mm, 7*mm], hAlign='LEFT')

    oxl_ts = tss.alg
    oxl_ts.add('ALIGN', (0, 1), (0, -1), 'CENTER')
    oxl_ts.add('ALIGN', (3, 1), (3, -1), 'RIGHT')
    oxl_ts.add('SPAN', (0, -2), (2, -2))
    oxl_ts.add('SPAN', (0, -1), (2, -1))
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  @property
  #= PROPERTY ============================
  # tbl_text
  #=======================================
  def tbl_text(self):

    lll_data = []
    lll_data.append([Paragraph(u'', pss.alfn)])
    oxl_table = Table(lll_data, rowHeights=[25*mm], colWidths=[190*mm], hAlign='LEFT')
    oxl_ts = tss.alng
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  @property
  #= PROPERTY ============================
  # tbl_sgn
  #=======================================
  def tbl_sgn(self):

    lll_data = []
    lll_data.append([Paragraph(u'Datum', pss.acfn), Paragraph(u'', pss.alfn), Paragraph(u'Kontrolor', pss.acfn)])
    lll_data.append([Paragraph(data.cd, pss.acfn), Paragraph(u'', pss.acfn), Paragraph(u'', pss.acfn)])
    lll_data.append([Paragraph(u'', pss.acfn), Paragraph(u'', pss.acfn), Paragraph(u'{} {}'.format(data.pr.kr_ime, data.pr.kr_prezime), pss.acfn)])
    oxl_table = Table(lll_data, rowHeights=[5*mm, 10*mm, 5*mm], colWidths=[63*mm, 64*mm, 63*mm], hAlign='LEFT')
    oxl_ts = tss.acng
    oxl_ts.add('LINEBELOW', (0, 1), (0, 1), lts.t05, colors.black)
    oxl_ts.add('LINEBELOW', (2, 1), (2, 1), lts.t05, colors.black)
    oxl_ts.add('VALIGN', (0, 1), (0, 1), 'BOTTOM')
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  @property
  #= METHOD ==============================
  # zap_tbl_ppv_data_ftr
  #=======================================
  def zap_tbl_ppv_data_ftr(self):

    return [
            ['', u'x = ure??aj/sistem postoji na vozilu,', u'- = ure??aj/sistem ne postoji na vozilu', u'', u''],
            ['', u'&nbsp;'*15+u'N/P = nije primenljivo,', u'&nbsp;'*15+u'* = obavezna homologacija', u'', u''],
           ]

  #= METHOD ==============================
  # zap_tbl_ppv_data_bdy
  #=======================================
  def zap_tbl_ppv_data_bdy(self, pl_data):

    lll_dataf = []
    for vil_row, lcl_row in enumerate(pl_data):
      lll_dataf.append(
                       [
                        Paragraph(lcl_row[0], (pss.acfb if vil_row==0 else pss.arfn)),
                        Paragraph(lcl_row[1], pss.alfn),
                        Paragraph(lcl_row[2], pss.alfn),
                        Paragraph(lcl_row[3], pss.alfn),
                        Paragraph(lcl_row[4], pss.acfn),
                       ]
                      )

    return lll_dataf

  #= METHOD ==============================
  # zap_tbl_ppv_ts
  #=======================================
  def zap_tbl_ppv_ts(self, pl_data):

    oxl_ts = tss.alng
    oxl_ts.add('ALIGN', (0, 1), (0, -3), 'RIGHT')
    oxl_ts.add('ALIGN', (1, 1), (-1, -1), 'LEFT')
    oxl_ts.add('BOX', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, -2), (-1, -1), lts.t05, colors.black)
    oxl_ts.add('INNERGRID', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('SPAN', (0, 0), (-1, 0))
    lil_l1 = [i for i, l in enumerate(pl_data[:-2]+['99']) if l[0] and l[0].isdigit()]
    lil_l2 = [i-1 for i in lil_l1][1:]
    for til_rows in [e for e in zip(lil_l1[:-1], lil_l2) if e[0]!=e[1]]:
      for vil_col in range(2):
        oxl_ts.add('SPAN', (vil_col, til_rows[0]), (vil_col, til_rows[1]))

    return oxl_ts

zap = zapisnici()

#= CLASS ===============================
# zapisnik_m1
#=======================================
class zapisnik_m1(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(
               self,
               pi_PrId,
               pc_PdfFile,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10*mm,
               pn_bottomMargin=10*mm,
               pn_leftMargin=10*mm,
               pn_rightMargin=10*mm
              ):

    SimpleDocTemplate.__init__(
                               self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin
                              )

    data.dget(self.__class__.__name__, dd({'pr_id': pi_PrId}))
    self.Title = u'ZAPISNIK O ISPITIVANJU VOZILA VRSTE M1'
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()

  #= METHOD ==============================
  # tbl_ppv
  #=======================================
  def tbl_ppv(self):

    lll_data = [
                ['KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'', u''],
                ['1', u'ure??aji za upravlj. - sistem za upravljanje', u'komanda na levoj strani', u'', u'*'],
                ['2', u'ure??aji za zaustavljanje vozila - ko??ni sistem', u'radna', u'', u'*'],
                ['', u'', u'pomo??na', u'', u'*'],
                ['', u'', u'parkirna', u'', u'*'],
                ['', u'', u'ABS (ako ima)', u'', u'*'],
                ['3', u'ure??aji za osvetljavanje puta', u'svetlosno i svetlosno signalni ure??aji', u'', u'*'],
                ['', u'', u'ure??aji za ozna??avanje vozila', u'', u'*'],
                ['', u'', u'ure??aji za davanje svetlosnih znakova', u'', u'*'],
                ['4', u'ure??aji koji omogu??uju normalnu vidljivost', u'retrovizori spoljni oba i unutra??nji', u'', u'*'],
                ['', u'', u'stakla i zatamnjena stakla', u'', u'*'],
                ['', u'', u'ure??aj za brisanje', u'', u''],
                ['', u'', u'ure??aj za kva??enje', u'', u''],
                ['5', u'ure??aj za davanje zvu??nih znakova', u'', u'', u'*'],
                ['6', u'ure??aji za kontrolu i davanje znakova', u'brzinomer sa odometrom', u'', u''],
                ['', u'', u'plavo kontrolno svetlo za dugo svetlo', u'', u''],
                ['', u'', u'svetlosni ili zvu??ni znak za pokazivanje pravca', u'', u''],
                ['7', u'ure??aji za odvo??enje i regulisanje izduvnih gasova', u'katalizator', u'', u'*'],
                ['', u'', u'ne u desnu stranu i u gabaritima izduva', u'', u''],
                ['8', u'ure??aji za spajanje vu??nog i priklju??nog vozila', u'rastavljen ne sme da prema??i gabarit', u'', u'*'],
                ['9', u'ure??aj za kretanje vozila u nazad', u'', u'', u''],
                ['10', u'ure??aji za oslanjanje', u'bez kontakta to??kova i karoserije', u'', u''],
                ['11', u'ure??aji za kretanje', u'pneumatici jednaki po osovinama', u'', u''],
                ['12', u'elektro ure??aji i instalacija', u'', u'', u''],
                ['13', u'pogonski ure??aj', u'', u'', u''],
                ['14', u'ure??aj za prenos snage', u'bar jedna ruka na upravlja??u', u'', u''],
                ['15', u'delovi vozila od posebnog zna??aja za bezbednost saobra??aja', u'op??ta konstrukcija', u'', u'*'],
                ['', u'', u'VIN', u'', u''],
                ['', u'', u'otvor goriva ne u kabini i prostoru za putnike', u'', u''],
                ['', u'', u'istureni delovi, ukrasi bez o??trih ivica', u'', u''],
                ['', u'', u'reklamne table u gabaritima', u'', u''],
                ['', u'', u'prostor za tablicu', u'', u''],
                ['', u'', u'unutra??nja rasveta', u'', u''],
                ['', u'', u'dvostepene brave', u'', u''],
                ['', u'', u'blatobrani iznad svih to??kova u ??irini to??ka', u'', u''],
                ['', u'', u'branik najmanje napred najistureniji', u'', u''],
                ['', u'', u'pojasevi za sva mesta', u'', u'*'],
                ['', u'', u'priklju??ak za vu??u neispravnog vozula', u'', u'*'],
                ['16', u'Ure??aj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
               ]
    lll_data.extend(zap.zap_tbl_ppv_data_ftr)
    lll_dataf = zap.zap_tbl_ppv_data_bdy(lll_data)
    oxl_table = Table(lll_dataf, colWidths=[9*mm, 78*mm, 81*mm, 15*mm, 7*mm], hAlign='LEFT')
    oxl_ts = zap.zap_tbl_ppv_ts(lll_data)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0*mm, 35*mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zvd(u'M1'))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_vzdata())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_hmlgo())

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0*mm, 15*mm))
    self.DocElm.append(self.tbl_ppv())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HdFtCanvasZap)

#= CLASS ===============================
# zapisnik_m2m3
#=======================================
class zapisnik_m2m3(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(
               self,
               pi_PrId,
               pc_PdfFile,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10*mm,
               pn_bottomMargin=10*mm,
               pn_leftMargin=10*mm,
               pn_rightMargin=10*mm
              ):

    SimpleDocTemplate.__init__(
                               self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin
                              )

    data.dget(self.__class__.__name__, dd({'pr_id': pi_PrId}))
    self.Title = u'ZAPISNIK O ISPITIVANJU VOZILA VRSTE M2-M3'
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()

  #= METHOD ==============================
  # tbl_ppv
  #=======================================
  def tbl_ppv(self):

    lll_data = [
                ['KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'', u''],
                ['1', u'ure??aji za upravlj. - sistem za upravljanje', u'komanda na levoj strani', u'', u'*'],
                ['2', u'ure??aji za zaustavljanje vozila - ko??ni sistem', u'radna', u'', u'*'],
                ['', u'', u'pomo??na', u'', u'*'],
                ['', u'', u'parkirna', u'', u'*'],
                ['', u'', u'ABS (ako ima)', u'', u'*'],
                ['', u'', u'uspora??', u'', u'*'],
                ['3', u'ure??aji za osvetljavanje puta', u'svetlosno i svetlosno signalni ure??aji', u'', u'*'],
                ['', u'', u'ure??aji za ozna??avanje vozila', u'', u'*'],
                ['', u'', u'ure??aji za davanje svetlosnih znakova', u'', u'*'],
                ['4', u'ure??aji koji omogu??uju normalnu vidljivost', u'retrovizori spoljni oba i unutra??nji', u'', u'*'],
                ['', u'', u'stakla i zatamnjena stakla', u'', u'*'],
                ['', u'', u'ure??aj za brisanje', u'', u''],
                ['', u'', u'ure??aj za kva??enje', u'', u''],
                ['5', u'ure??aj za davanje zvu??nih znakova', u'uklju??uju??i i signal pri kretanju unazad', u'', u''],
                ['6', u'ure??aji za kontrolu i davanje znakova', u'brzinomer sa odometrom', u'', u''],
                ['', u'', u'indikator pritiska u sistemu za radno ko??enje', u'', u''],
                ['', u'', u'digitalni tahograf', u'', u''],
                ['', u'', u'plavo kontrolno svetlo za dugo svetlo', u'', u''],
                ['', u'', u'ograni??ava?? brzine do 100 km/H', u'', u'*'],
                ['', u'', u'svetlosni signal za kontrolu zatvorenih vrata (kl I/II)', u'', u''],
                ['', u'', u'ure??aj za dav. i prim. znakova od putnika (kl I/II)', u'', u''],
                ['', u'', u'svetlosni ili zvu??ni znak za pokazivanje pravca', u'', u''],
                ['7', u'ure??aji za odvo??enje i regulisanje izduvnih gasova', u'katalizator', u'', u'*'],
                ['', u'', u'ne u desnu stranu i u gabaritima izduva', u'', u''],
                ['8', u'ure??aji za spajanje vu??nog i priklju??nog vozila', u'rastavljen ne sme da prema??i gabarit', u'', u'*'],
                ['9', u'ure??aj za kretanje vozila u nazad', u'', u'', u''],
                ['10', u'ure??aji za oslanjanje', u'bez kontakta to??kova i karoserije', u'', u''],
                ['11', u'ure??aji za kretanje', u'pneumatici jednaki po osovinama', u'', u''],
                ['12', u'elektro ure??aji i instalacija', u'prekida?? svih strujnih kola osim taho. i bezb. ure??a', u'', u''],
                ['13', u'pogonski ure??aj', u'nije mogu??e povre??ivanje voza??a i putnika', u'', u''],
                ['14', u'ure??aj za prenos snage', u'bar jedna ruka na upravlja??u', u'', u''],
                ['15', u'delovi vozila od posebnog zna??aja za bezbednost saobra??aja', u'op??ta konstrukcija', u'', u'*'],
                ['', u'', u'VIN', u'', u''],
                ['', u'', u'otvor goriva ne u kabini i prostoru za putnike', u'', u''],
                ['', u'', u'istureni delovi, ukrasi bez o??trih ivica', u'', u''],
                ['', u'', u'reklamne table u gabaritima', u'', u''],
                ['', u'', u'prostor za tablicu', u'', u''],
                ['', u'', u'slobodna povr??ina za stajanje putnika', u'', u''],
                ['', u'', u'pri??vr????enost alata, pribora, ure??aja i opreme', u'', u''],
                ['', u'', u'izlaz u slu??aju opasnosti (na krovu i vrata)', u'', u''],
                ['', u'', u'ure??aj za provetravanje', u'', u''],
                ['', u'', u'unutra??nja rasveta', u'', u''],
                ['', u'', u'dvostepene brave', u'', u''],
                ['', u'', u'blatobrani iznad svih to??kova u ??irini to??ka', u'', u''],
                ['', u'', u'branik najmanje napred najistureniji', u'', u''],
                ['', u'', u'pojasevi za sva mesta', u'', u'*'],
                ['', u'', u'putni??ki prost. obezbe??en od prodora ??tetnih gasova', u'', u''],
                ['', u'', u'priklju??ak za vu??u neispravnog vozila', u'', u'*'],
                ['16', u'Ure??aj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
               ]
    lll_data.extend(zap.zap_tbl_ppv_data_ftr)
    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append(
                       [
                        Paragraph(lcl_row[0], (pss.acfb if vil_row==0 else pss.arfn)),
                        Paragraph(lcl_row[1], pss.alfn),
                        Paragraph(lcl_row[2], pss.alfn),
                        Paragraph(lcl_row[3], pss.alfn),
                        Paragraph(lcl_row[4], pss.alfn),
                       ]
                      )
    oxl_table = Table(lll_dataf, rowHeights=[4*mm]*len(lll_dataf), colWidths=[9*mm, 75*mm, 84*mm, 15*mm, 7*mm], hAlign='LEFT')
    oxl_ts = zap.zap_tbl_ppv_ts(lll_data)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0*mm, 35*mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zvd(u'M2M3'))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_vzdata())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_hmlgo())

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0*mm, 15*mm))
    self.DocElm.append(self.tbl_ppv())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HdFtCanvasZap)

#= CLASS ===============================
# zapisnik_l
#=======================================
class zapisnik_l(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(
               self,
               pi_PrId,
               pc_PdfFile,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10*mm,
               pn_bottomMargin=10*mm,
               pn_leftMargin=10*mm,
               pn_rightMargin=10*mm
              ):

    SimpleDocTemplate.__init__(
                               self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin
                              )

    data.dget(self.__class__.__name__, dd({'pr_id': pi_PrId}))
    self.Title = u'ZAPISNIK O ISPITIVANJU VOZILA VRSTE L'
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()

  #= METHOD ==============================
  # tbl_ppv
  #=======================================
  def tbl_ppv(self):

    lll_data = [
                ['KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'', u''],
                ['1', u'ure??aji za upravlj. - sistem za upravljanje', u'komanda na levoj strani', u'', u'*'],
                ['2', u'ure??aji za zaustavljanje vozila - ko??ni sistem', u'radna', u'', u'*'],
                ['', u'', u'pomo??na (L5 i L7 m>1t)', u'', u'*'],
                ['', u'', u'parkirna L7', u'', u'*'],
                ['3', u'svetlosno i svetlosno signalni ure??aji', u'ure??aji za osvetljavanje puta', u'', u'*'],
                ['', u'', u'ure??aji za ozna??avanje vozila', u'', u'*'],
                ['', u'', u'ure??aji za davanje svetlosnih znakova', u'', u'*'],
                ['4', u'ure??aji koji omogu??uju normalnu vidljivost', u'retrovizori', u'', u'*'],
                ['', u'', u'stakla i zatamnjena stakla', u'', u'*'],
                ['', u'', u'ure??aj za brisanje', u'', u''],
                ['', u'', u'ure??aj za kva??enje', u'', u''],
                ['5', u'ure??aj za davanje zvu??nih znakova', u'', u'', u'*'],
                ['6', u'ure??aji za kontrolu i davanje znakova', u'brzinomer sa odometrom', u'', u''],
                ['', u'', u'plavo kontrolno svetlo za dugo svetlo', u'', u''],
                ['', u'', u'svetlosni ili zvu??ni znak za pokazivanje pravca', u'', u''],
                ['7', u'ure??aji za odvo??enje i regulisanje izduvnih gasova', u'katalizator', u'', u'*'],
                ['8', u'ure??aji za spajanje vu??nog i priklju??nog vozila', u'rastavljen ne sme da prema??i gabarit', u'', u'*'],
                ['9', u'ure??aj za kretanje vozila u nazad', u'', u'', u''],
                ['10', u'ure??aji za oslanjanje', u'bez kontakta to??kova i karoserije', u'', u''],
                ['11', u'ure??aji za kretanje', u'pneumatici jednaki po osovinama', u'', u''],
                ['12', u'elektro ure??aji i instalacija', u'', u'', u''],
                ['13', u'pogonski ure??aj', u'', u'', u''],
                ['14', u'ure??aj za prenos snage', u'bar jedna ruka na upravlja??u', u'', u''],
                ['15', u'delovi vozila od posebnog zna??aja za bezbednost saobra??aja', u'op??ta konstrukcija', u'', u'*'],
                ['', u'', u'VIN', u'', u''],
                ['', u'', u'otvor goriva ne u kabini i prostoru za putnike', u'', u''],
                ['', u'', u'istureni delovi, ukrasi bez o??trih ivica', u'', u''],
                ['', u'', u'reklamne table u gabaritima', u'', u''],
                ['', u'', u'pri??vr????enost pribora, alata i opreme', u'', u''],
                ['', u'', u'prostor za tablicu', u'', u''],
                ['', u'', u'blatobrani iznad svih to??kova u ??irini to??ka', u'', u''],
                ['16', u'Ure??aj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
               ]
    lll_data.extend(zap.zap_tbl_ppv_data_ftr)
    lll_dataf = zap.zap_tbl_ppv_data_bdy(lll_data)
    oxl_table = Table(lll_dataf, colWidths=[9*mm, 78*mm, 81*mm, 15*mm, 7*mm], hAlign='LEFT')
    oxl_ts = zap.zap_tbl_ppv_ts(lll_data)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0*mm, 35*mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zvd(u'L'))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_vzdata())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_hmlgo())

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0*mm, 15*mm))
    self.DocElm.append(self.tbl_ppv())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HdFtCanvasZap)

#= CLASS ===============================
# zapisnik_n1
#=======================================
class zapisnik_n1(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(
               self,
               pi_PrId,
               pc_PdfFile,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10*mm,
               pn_bottomMargin=10*mm,
               pn_leftMargin=10*mm,
               pn_rightMargin=10*mm
              ):

    SimpleDocTemplate.__init__(
                               self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin
                              )

    data.dget(self.__class__.__name__, dd({'pr_id': pi_PrId}))
    self.Title = u'ZAPISNIK O ISPITIVANJU VOZILA VRSTE N1'
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()

  #= METHOD ==============================
  # tbl_ppv
  #=======================================
  def tbl_ppv(self):

    lll_data = [
                ['KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'', u''],
                ['1', u'ure??aji za upravlj. - sistem za upravljanje', u'komanda na levoj strani', u'', u'*'],
                ['2', u'ure??aji za zaustavljanje vozila - ko??ni sistem', u'radna', u'', u'*'],
                ['', u'', u'pomo??na', u'', u'*'],
                ['', u'', u'parkirna', u'', u'*'],
                ['', u'', u'ABS (ako ima)', u'', u'*'],
                ['3', u'ure??aji za osvetljavanje puta', u'svetlosno i svetlosno signalni ure??aji', u'', u'*'],
                ['', u'', u'ure??aji za ozna??avanje vozila', u'', u'*'],
                ['', u'', u'ure??aji za davanje svetlosnih znakova', u'', u'*'],
                ['4', u'ure??aji koji omogu??uju normalnu vidljivost', u'retrovizori spoljni oba i unutra??nji', u'', u'*'],
                ['', u'', u'stakla i zatamnjena stakla', u'', u'*'],
                ['', u'', u'ure??aj za brisanje', u'', u''],
                ['', u'', u'ure??aj za kva??enje', u'', u''],
                ['5', u'ure??aj za davanje zvu??nih znakova', u'', u'', u'*'],
                ['6', u'ure??aji za kontrolu i davanje znakova', u'brzinomer sa odometrom', u'', u''],
                ['', u'', u'plavo kontrolno svetlo za dugo svetlo', u'', u''],
                ['', u'', u'svetlosni ili zvu??ni znak za pokazivanje pravca', u'', u''],
                ['7', u'ure??aji za odvo??enje i regulisanje izduvnih gasova', u'katalizator', u'', u'*'],
                ['', u'', u'ne u desnu stranu i u gabaritima izduva', u'', u''],
                ['8', u'ure??aji za spajanje vu??nog i priklju??nog vozila', u'rastavljen ne sme da prema??i gabarit', u'', u'*'],
                ['9', u'ure??aj za kretanje vozila u nazad', u'', u'', u''],
                ['10', u'ure??aji za oslanjanje', u'bez kontakta to??kova i karoserije', u'', u''],
                ['11', u'ure??aji za kretanje', u'pneumatici jednaki po osovinama', u'', u''],
                ['12', u'elektro ure??aji i instalacija', u'', u'', u''],
                ['13', u'pogonski ure??aj', u'', u'', u''],
                ['14', u'ure??aj za prenos snage', u'bar jedna ruka na upravlja??u', u'', u''],
                ['15', u'delovi vozila od posebnog zna??aja za bezbednost saobra??aja', u'op??ta konstrukcija', u'', u'*'],
                ['', u'', u'VIN', u'', u''],
                ['', u'', u'otvor goriva ne u kabini i prostoru za putnike', u'', u''],
                ['', u'', u'istureni delovi, ukrasi bez o??trih ivica', u'', u''],
                ['', u'', u'reklamne table u gabaritima', u'', u''],
                ['', u'', u'prostor za tablicu', u'', u''],
                ['', u'', u'unutra??nja rasveta', u'', u''],
                ['', u'', u'dvostepene brave', u'', u''],
                ['', u'', u'blatobrani iznad svih to??kova u ??irini to??ka (osim kipera)', u'', u''],
                ['', u'', u'branik najmanje napred najistureniji', u'', u''],
                ['', u'', u'pojasevi za sva mesta', u'', u'*'],
                ['', u'', u'priklju??ak za vu??u neispravnog vozula', u'', u'*'],
                ['', u'', u'ispunjenost standarda ISO 27956:2009 (za BB)', u'', u'*'],
                ['16', u'Ure??aj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
               ]
    lll_data.extend(zap.zap_tbl_ppv_data_ftr)
    lll_dataf = zap.zap_tbl_ppv_data_bdy(lll_data)
    oxl_table = Table(lll_dataf, colWidths=[9*mm, 78*mm, 81*mm, 15*mm, 7*mm], hAlign='LEFT')
    oxl_ts = zap.zap_tbl_ppv_ts(lll_data)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0*mm, 35*mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zvd(u'N1'))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_vzdata())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_hmlgo())

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0*mm, 15*mm))
    self.DocElm.append(self.tbl_ppv())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HdFtCanvasZap)

#= CLASS ===============================
# zapisnik_n2n3
#=======================================
class zapisnik_n2n3(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(
               self,
               pi_PrId,
               pc_PdfFile,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10*mm,
               pn_bottomMargin=10*mm,
               pn_leftMargin=10*mm,
               pn_rightMargin=10*mm
              ):

    SimpleDocTemplate.__init__(
                               self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin
                              )

    data.dget(self.__class__.__name__, dd({'pr_id': pi_PrId}))
    self.Title = u'ZAPISNIK O ISPITIVANJU VOZILA VRSTE N2-N3'
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()

  #= METHOD ==============================
  # tbl_ppv
  #=======================================
  def tbl_ppv(self):

    lll_data = [
                ['KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'', u''],
                ['1', u'ure??aji za upravlj. - sistem za upravljanje', u'komanda na levoj strani', u'', u'*'],
                ['2', u'ure??aji za zaustavljanje vozila - ko??ni sistem', u'radna', u'', u'*'],
                ['', u'', u'pomo??na', u'', u'*'],
                ['', u'', u'parkirna', u'', u'*'],
                ['', u'', u'ABS (ako ima)', u'', u'*'],
                ['', u'', u'uspora??', u'', u'*'],
                ['3', u'ure??aji za osvetljavanje puta', u'svetlosno i svetlosno signalni ure??aji', u'', u'*'],
                ['', u'', u'ure??aji za ozna??avanje vozila', u'', u'*'],
                ['', u'', u'ure??aji za davanje svetlosnih znakova', u'', u'*'],
                ['4', u'ure??aji koji omogu??uju normalnu vidljivost', u'retrovizori spoljni oba i unutra??nji', u'', u'*'],
                ['', u'', u'stakla i zatamnjena stakla', u'', u'*'],
                ['', u'', u'ure??aj za brisanje', u'', u''],
                ['', u'', u'ure??aj za kva??enje', u'', u''],
                ['5', u'ure??aj za davanje zvu??nih znakova', u'uklju??uju??i i signal pri kretanju unazad', u'', u''],
                ['6', u'ure??aji za kontrolu i davanje znakova', u'brzinomer sa odometrom', u'', u''],
                ['', u'', u'indikator pritiska u sistemu za radno ko??enje', u'', u''],
                ['', u'', u'digitalni tahograf', u'', u''],
                ['', u'', u'plavo kontrolno svetlo za dugo svetlo', u'', u''],
                ['', u'', u'ograni??ava?? brzine do 100 (90) km/h', u'', u'*'],
                ['', u'', u'svetlosni ili zvu??ni znak za pokazivanje pravca', u'', u''],
                ['7', u'ure??aji za odvo??enje i regulisanje izduvnih gasova', u'katalizator', u'', u'*'],
                ['', u'', u'ne u desnu stranu i u gabaritima izduva', u'', u''],
                ['8', u'ure??aji za spajanje vu??nog i priklju??nog vozila', u'rastavljen ne sme da prema??i gabarit', u'', u'*'],
                ['9', u'ure??aj za kretanje vozila u nazad', u'', u'', u''],
                ['10', u'ure??aji za oslanjanje', u'bez kontakta to??kova i karoserije', u'', u''],
                ['11', u'ure??aji za kretanje', u'pneumatici jednaki po osovinama', u'', u''],
                ['12', u'elektro ure??aji i instalacija', u'prekida?? svih strujnih kola osim taho. i bezb. ure??a', u'', u''],
                ['13', u'pogonski ure??aj', u'nije mogu??e povre??ivanje voza??a i putnika', u'', u''],
                ['14', u'ure??aj za prenos snage', u'bar jedna ruka na upravlja??u', u'', u''],
                ['15', u'delovi vozila od posebnog zna??aja za bezbednost saobra??aja', u'op??ta konstrukcija', u'', u'*'],
                ['', u'', u'VIN', u'', u''],
                ['', u'', u'otvor goriva ne u kabini i prostoru za putnike', u'', u''],
                ['', u'', u'istureni delovi, ukrasi bez o??trih ivica', u'', u''],
                ['', u'', u'reklamne table u gabaritima', u'', u''],
                ['', u'', u'prostor za tablicu', u'', u''],
                ['', u'', u'unutra??nja rasveta', u'', u''],
                ['', u'', u'dvostepene brave', u'', u''],
                ['', u'', u'blatobr. iznad svih to??. u ??irini to??. (osim kipera)', u'', u''],
                ['', u'', u'branik najmanje napred najistureniji', u'', u''],
                ['', u'', u'pojasevi za sva mesta', u'', u'*'],
                ['', u'', u'ZZOP (osim teglja??a)', u'', u''],
                ['', u'', u'BZOP (osim teglja??a)', u'', u'*'],
                ['16', u'Ure??aj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
               ]
    lll_data.extend(zap.zap_tbl_ppv_data_ftr)
    lll_dataf = zap.zap_tbl_ppv_data_bdy(lll_data)
    oxl_table = Table(lll_dataf, colWidths=[9*mm, 75*mm, 84*mm, 15*mm, 7*mm], hAlign='LEFT')
    oxl_ts = zap.zap_tbl_ppv_ts(lll_data)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0*mm, 35*mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zvd(u'N2N3'))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_vzdata())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_hmlgo())

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0*mm, 15*mm))
    self.DocElm.append(self.tbl_ppv())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HdFtCanvasZap)

#= CLASS ===============================
# zapisnik_o
#=======================================
class zapisnik_o(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(
               self,
               pi_PrId,
               pc_PdfFile,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10*mm,
               pn_bottomMargin=10*mm,
               pn_leftMargin=10*mm,
               pn_rightMargin=10*mm
              ):

    SimpleDocTemplate.__init__(
                               self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin
                              )

    data.dget(self.__class__.__name__, dd({'pr_id': pi_PrId}))
    self.Title = u'ZAPISNIK O ISPITIVANJU VOZILA VRSTE O'
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()

  #= METHOD ==============================
  # tbl_ppv
  #=======================================
  def tbl_ppv(self):

    lll_data = [
                ['KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'', u''],
                ['1', u'ure??aji za upravlj. - sistem za upravljanje', u'komanda na levoj strani', u'', u'*'],
                ['2', u'ure??aji za zaustavljanje vozila - ko??ni sistem', u'radna', u'', u'*'],
                ['', u'', u'pomo??na', u'', u'*'],
                ['', u'', u'parkirna', u'', u'*'],
                ['', u'', u'ABS (ako ima)', u'', u'*'],
                ['3', u'ure??aji za spajanje vu??nog i priklju??nog vozila', u'', u'', u'*'],
                ['4', u'ure??aji za oslanjanje', u'bez kontakta to??kova i karoserije', u'', u''],
                ['5', u'ure??aji za kretanje', u'pneumatici jednaki po osovinama', u'', u''],
                ['6', u'elektro ure??aji i instalacija', u'', u'', u''],
                ['7', u'delovi vozila od posebnog zna??aja za bezbednost saobra??aja', u'op??ta konstrukcija', u'', u'*'],
                ['', u'', u'VIN', u'', u''],
                ['', u'', u'istureni delovi, ukrasi bez o??trih ivica', u'', u''],
                ['', u'', u'reklamne table u gabaritima', u'', u''],
                ['', u'', u'prostor za tablicu', u'', u''],
                ['', u'', u'blatobrani iznad svih to??kova u ??irini to??ka', u'', u''],
                ['', u'', u'ZZOP', u'', u''],
                ['', u'', u'BZOP', u'', u'*'],
               ]
    lll_data.extend(zap.zap_tbl_ppv_data_ftr)
    lll_dataf = zap.zap_tbl_ppv_data_bdy(lll_data)
    oxl_table = Table(lll_dataf, colWidths=[9*mm, 75*mm, 84*mm, 15*mm, 7*mm], hAlign='LEFT')
    oxl_ts = zap.zap_tbl_ppv_ts(lll_data)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0*mm, 35*mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_zvd(u'O'))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_vzdata(u'O'))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_hmlgo(u'O'))

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0*mm, 15*mm))
    self.DocElm.append(self.tbl_ppv())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HdFtCanvasZap)

#= CLASS ===============================
# neusaglasenost
#=======================================
class neusaglasenost(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(
               self,
               pi_PrId,
               pc_PdfFile,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10*mm,
               pn_bottomMargin=10*mm,
               pn_leftMargin=10*mm,
               pn_rightMargin=10*mm
              ):

    SimpleDocTemplate.__init__(
                               self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin
                              )

    data.dget(self.__class__.__name__, dd({'pr_id': pi_PrId}))
    self.Title = u'<u>NALAZ O NEUSKLA??ENOSTI (NEUSAGLA??ENOSTI)</u>'
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()

  #= METHOD ==============================
  # data_fir
  #=======================================
  def data_fir(self):

    vcl_text = 'Na osnovu re??enja Agencije za bezbednost saobra??aja 221-22-00-507/2020-05 od 13.07.2020. kojim je pravno lice {0} {1}, ovla????eno za poslove ispitivanje vozila, {0} {1} sa??injava'.format(data.fir.fir_naziv, data.fir.fir_opis_s)
    oxl_pr = Paragraph(vcl_text, pss.alfn)

    return oxl_pr

  #= METHOD ==============================
  # data_fir1
  #=======================================
  def data_fir1(self):

    vcl_text = '<br/>'.join(
                            [
                             data.fir.fir_naziv,
                             data.fir.fir_adresa_sediste,
                             data.fir.fir_opis,
                             'telefon: {}'.format(data.fir.fir_tel1),
                             'mail: {}'.format(data.fir.fir_mail)
                            ]
                           )
    oxl_pr = Paragraph(vcl_text, pss.alfb)

    return oxl_pr

  #= METHOD ==============================
  # img_sl
  #=======================================
  def img_sl(self):

    oxl_img = Image(imgs.abs1, kind='proportional')
    oxl_img.drawHeight = 20*mm
    oxl_img.drawWidth = 50*mm
    oxl_img.hAlign = 'CENTER'

    return oxl_img

  #= METHOD ==============================
  # tbl_fir
  #=======================================
  def tbl_fir(self):

    oxl_img = self.img_sl()
    oxl_pr = self.data_fir()
    oxl_table = Table([[oxl_img, oxl_pr]], colWidths=[55*mm, 135*mm], hAlign='LEFT')
    oxl_table.setStyle(tss.acg)

    return oxl_table

  #= PROPERTY ============================
  # tbl_h1
  #=======================================
  def tbl_h1(self):

    lll_data = []
    lll_data.append([Paragraph(u'Broj potvrde o prijemu zahteva:', pss.alfn), Paragraph(u'od dana:', pss.alfn)])
    oxl_table = Table(lll_data, colWidths=[90*mm, 100*mm], hAlign='LEFT')
    oxl_ts = tss.alng
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= PROPERTY ============================
  # tbl_h2
  #=======================================
  def tbl_h2(self):

    lll_data = []
    lll_data.append([Paragraph(u'Broj zapisnika:', pss.alfb)])
    oxl_table = Table(lll_data, colWidths=[90*mm], hAlign='LEFT')
    oxl_ts = tss.alng
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= PROPERTY ============================
  # tbl_zkl
  #=======================================
  def tbl_zkl(self):

    lll_data = []
    lll_data.append([Paragraph(u'Vlasnik: {}'.format(nvl(data.pr.kl_naziv)), pss.alfn), self.data_fir1()])
    lll_data.append([Paragraph(u'Adresa: {}'.format(nvl(data.pr.kl_adresa)), pss.alfn), ''])
    lll_data.append([Paragraph(u'VIN oznake: {}'.format(nvl(data.pr.vz_sasija)), pss.alfn), ''])
    lll_data.append([Paragraph(u'Broj motora: {}'.format(nvl(data.pr.vz_motor)), pss.alfn), ''])
    oxl_table = Table(lll_data, colWidths=[120*mm, 70*mm], hAlign='LEFT')
    oxl_ts = tss.alng
    oxl_ts.add('SPAN', (-1, 0), (-1, -1))
    oxl_ts.add('BOX', (-1, 0), (-1, -1), lts.t05, colors.black)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # tbl_data
  #=======================================
  def tbl_data(self):

    vcl_text = '<br/>'.join(
                            [
                             'Ukoliko u roku od 30 dana ne otklonite navedene nedostatke i ne dostavite potrebnu dokumentaciju, smatra??emo da ste odustali od zahteva i postupak ??e biti obustavljen.',
                             'Na osnovu rezultata ispitivanja vozila, utvr??eno je da se na vozilu nalaze neuskla??enosti sa doma??im propisima i da bi vozilo dobilo pozitivno mi??ljenje, potrebno je otkloniti neuskla??enosti.',
                            ]
                           )
    lll_data = [
                [Paragraph(nvl(data.pr.pr_napomena), pss.alfn)],
                [Paragraph(vcl_text, pss.alfn)],
               ]
    oxl_table = Table(lll_data, rowHeights=[90*mm, 18*mm], colWidths=[190*mm], hAlign='LEFT')
    oxl_ts = tss.alg
    oxl_ts.add('VALIGN', (0, 0), (-1, -1), 'TOP')
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # tbl_sgn
  #=======================================
  def tbl_sgn(self):


    lll_data = [
                [u'Podnosilac zahteva', u'', u'{}<br/>{}, {}'.format(data.fir.fir_naziv_s, data.fir.fir_opis_s, data.fir.fir_mesto_sediste)],
                [u'', u'', u''],
               ]
    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append(
                       [
                        Paragraph(lcl_row[0], pss.acfn),
                        Paragraph(lcl_row[1], pss.acfn),
                        Paragraph(lcl_row[2], pss.acfn),
                       ]
                      )
    oxl_table = Table(lll_dataf, rowHeights=[5*mm, 10*mm], colWidths=[60*mm, 70*mm, 60*mm], hAlign='LEFT')

    oxl_ts = tss.acng
    oxl_ts.add('ALIGN', (0, 0), (0, 0), 'LEFT')
    oxl_ts.add('LINEBELOW', (0, -1), (0, -1), lts.t05, colors.black)
    oxl_ts.add('LINEBELOW', (-1, -1), (-1, -1), lts.t05, colors.black)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0*mm, 0*mm))
    self.DocElm.append(self.tbl_fir())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(self.tbl_h1())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(self.tbl_h2())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(self.tbl_zkl())

    self.DocElm.append(Spacer(0*mm, 5*mm))
    self.DocElm.append(tbl_txt('U toku ispitivanja ustanovljene su slede??e neusagla??enosti:'))

    self.DocElm.append(Spacer(0*mm, 2*mm))
    self.DocElm.append(self.tbl_data())

    self.DocElm.append(Spacer(0*mm, 2*mm))
    self.DocElm.append(tbl_txt('Zabranjeno je pre??tampavanje i umno??avanje.'))

    self.DocElm.append(Spacer(0*mm, 40*mm))
    self.DocElm.append(tbl_txt(u'Datum: {}'.format(data.cd)))

    self.DocElm.append(Spacer(0*mm, 2*mm))
    self.DocElm.append(self.tbl_sgn())

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm)

#= CLASS ===============================
# raspored
#=======================================
class raspored(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(
               self,
               pc_KnDatum,
               pc_PdfFile,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10*mm,
               pn_bottomMargin=10*mm,
               pn_leftMargin=10*mm,
               pn_rightMargin=10*mm
              ):

    SimpleDocTemplate.__init__(
                               self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin
                              )

    data.dget(self.__class__.__name__, dd({'kn_datum': pc_KnDatum}))
    self.Title = u'???????????????? ???????????????????? ???? ???????????????????? ???? ??????'
    self.Title1 = u'{}, {}'.format(data.rsp[0].kn_dan, data.rsp[0].kn_datum)
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()

  #= METHOD ==============================
  # tbl_data
  #=======================================
  def tbl_data(self):

    lll_data = [[Paragraph('????????????????', pss.alfb), Paragraph('??????????????', pss.alfb), Paragraph('??????', pss.alfb)]]
    for vil_row, row in enumerate(data.rsp):
      lll_data.append(
                      [
                       Paragraph(row.lk_naziv_d, pss.alfn),
                       Paragraph(row.kr_prezime, pss.alfn),
                       Paragraph(row.kr_ime, pss.alfn),
                      ]
                     )
    oxl_table = Table(lll_data, colWidths=[45*mm, 45*mm, 45*mm], hAlign='CENTER', repeatRows=1)
    oxl_ts = tss.alng
    oxl_ts.add('LINEBELOW', (0, 0), (-1, 0), lts.t05, colors.black)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0*mm, 20*mm))
    self.DocElm.append(tbl_ttl(self.Title))
    self.DocElm.append(tbl_ttl(self.Title1))

    self.DocElm.append(Spacer(0*mm, 5*mm))
    oxl_tbl = self.tbl_data()

    lol_tss = oxl_tbl.split(0*mm, 230*mm)
    if len(lol_tss)<2:
      self.DocElm.append(oxl_tbl)
    else:
      # ostale strane
      lol_tbls = []
      while len(lol_tss)==2:
        lol_tbls.append(lol_tss[0])
        lol_tss = lol_tss[1].split(0*mm, 250*mm)

      for vil_ti, oxl_tblp in enumerate(lol_tbls, 1):
        self.DocElm.append(oxl_tblp)
        if vil_ti==1:
          self.DocElm.append(Spacer(0*mm, 15*mm))
        elif vil_ti<len(lol_tbls):
          self.DocElm.append(Spacer(0*mm, 17*mm))

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HdFtCanvas)

#= CLASS ===============================
# report
#=======================================
class report:

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self):

    pass 

  #= METHOD ==============================
  # run
  #=======================================
  def run(self, pc_UserName, pc_Report, pd_RepPrms={}):

    """  Generate PDF report file"""

    reps = dd({})
    reps['pdfdir'] = osp.join(sysdf.pdf, pc_UserName)
    reps['pdf'] = osp.join(reps.pdfdir, '{}.pdf'.format(pc_Report))

    utl.dircheck(reps.pdfdir)
    utl.filedelete(reps.pdf)

    vcl_Report = pc_Report.lower()
    vil_pr_id = pd_RepPrms.get('pi_pr_id', 0)
    vcl_vzpv_oznaka = pd_RepPrms.get('pc_vzpv_oznaka', '')
    vbl_test = pd_RepPrms.get('pb_test', False)
    vcl_kn_datum = pd_RepPrms.get('pc_kn_datum', '')
    if vil_pr_id:
      if vcl_Report==u'zapisnik':
        if vcl_vzpv_oznaka:
          if vcl_vzpv_oznaka[:2]==u'M1':
            reps.pdf = osp.join(reps.pdfdir, '{}_m1.pdf'.format(vcl_Report))
            r = zapisnik_m1(vil_pr_id, reps.pdf)
          elif vcl_vzpv_oznaka[:2] in (u'M2', u'M3'):
            reps.pdf = osp.join(reps.pdfdir, '{}_m2m3.pdf'.format(vcl_Report))
            r = zapisnik_m2m3(vil_pr_id, reps.pdf)
          elif vcl_vzpv_oznaka[0]==u'L':
            reps.pdf = osp.join(reps.pdfdir, '{}_l.pdf'.format(vcl_Report))
            r = zapisnik_l(pd_RepPrms[pi_pr_id], reps.pdf)
          elif vcl_vzpv_oznaka[:2]==u'N1':
            reps.pdf = osp.join(reps.pdfdir, '{}_n1.pdf'.format(vcl_Report))
            r = zapisnik_n1(vil_pr_id, reps.pdf)
          elif vcl_vzpv_oznaka[:2] in (u'N2', u'N3'):
            reps.pdf = osp.join(reps.pdfdir, '{}_n2n3.pdf'.format(vcl_Report))
            r = zapisnik_n2n3(vil_pr_id, reps.pdf)
          elif vcl_vzpv_oznaka[0]==u'O':
            reps.pdf = osp.join(reps.pdfdir, '{}_o.pdf'.format(vcl_Report))
            r = zapisnik_o(vil_pr_id, reps.pdf)
      elif vcl_Report in [u'potvrda', u'potvrda_b']:
        r = potvrda(vil_pr_id, reps.pdf, vbl_test)
      elif vcl_Report==u'neusaglasenost':
        r = neusaglasenost(vil_pr_id, reps.pdf)
    elif vcl_Report=='raspored':
      r = raspored(vcl_kn_datum, reps.pdf)
    if not osp.exists(reps.pdf):
      print('Izve??taj "{}" nije generisan!'.format(reps.pdf))

    return reps.pdf

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
