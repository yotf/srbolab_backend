#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
import locale as lc
import os
import os.path as osp

from box import SBox as dd
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_JUSTIFY, TA_LEFT, TA_RIGHT
from reportlab.lib.pagesizes import A4, portrait
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas
# site-packages
from reportlab.platypus import *

from . import util as utl
from .cfg import getpgdb, sysdf
# local
from .pgdb import pgdb

#---------------------------------------
# setings
#---------------------------------------
lc.setlocale(lc.LC_ALL, '')

#---------------------------------------
# global variables
#---------------------------------------
db = pgdb()

imgs = dd({
    u'sl1': osp.join(sysdf.reps, u'srbolab-logo.png'),
    u'abs1': osp.join(sysdf.reps, u'abs-logo.png'),
})

fnts = dd({
    u's6': 6,
    u's7': 7,
    u's8': 8,
    u's9': 9,
    u's10': 10,
    u's11': 11,
    u's12': 12,
    u's14': 14,
})

fntn = dd({
    u'tahoma': 'Tahoma',
    u'tahomab': 'Tahoma Bold',
    u'consolas': 'Consolas',
    u'couriernew': 'Courier New',
})

lts = dd({
    u't025': 0.5,
    u't05': 0.5,
    u't075': 0.75,
    u't1': 1,
    u't125': 1.25,
    u't15': 1.5,
    u't175': 1.75,
})


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= METHOD ==============================
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
      'Verdana': 'verdana.ttf',
      'Courier New': 'cour.ttf',
      'Consolas': 'consola.ttf',
  }
  for vcl_FntNme, vcl_FntFle in dcl_Fonts.items():
    pdfmetrics.registerFont(
        TTFont(vcl_FntNme, osp.join(sysdf.reps, 'fonts', vcl_FntFle)))


regfonts()


#= METHOD ==============================
# tbl_ttl
#=======================================
def tbl_ttl(pc_text):

  oxl_table = Table([[Paragraph(pc_text, pss.psbc)]], hAlign='CENTER')

  return oxl_table


#= CLASS ===============================
#  Data
#=======================================
class Data():

  #= METHOD ==============================
  #  __init__
  #=======================================
  def __init__(self, pi_PrId=None, pb_Potvrda=False):

    self.fir = dd(db.fir())
    self.dget(pi_PrId, pb_Potvrda)

  #= METHOD ==============================
  #  dget
  #=======================================
  def dget(self, pi_PrId, pb_Potvrda=False):

    if pi_PrId:
      if pb_Potvrda:
        self.h = [dd(row) for row in db.potvrda_h(pi_PrId)]
        self.b = [dd(row) for row in db.potvrda_b(pi_PrId)]
        self.f = [dd(row) for row in db.potvrda_f(pi_PrId)]
      else:
        self.pr = dd(db.predmet_b(pi_PrId))
    else:
      self.pr = None
      self.h = None
      self.b = None
      self.f = None


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
  #  psnc
  #=======================================
  def psnc(self):

    return ParagraphStyle(name='psnc',
                          fontName=fntn.tahoma,
                          fontSize=fnts.s10,
                          alignment=TA_CENTER)

  @property
  #= PROPERTY ============================
  #  psnl
  #=======================================
  def psnl(self):

    return ParagraphStyle(name='psnl',
                          fontName=self.fntnm,
                          fontSize=self.fntsz,
                          alignment=TA_LEFT)

  @property
  #= PROPERTY ============================
  #  psnr
  #=======================================
  def psnr(self):

    return ParagraphStyle(name='psnr',
                          fontName=self.fntnm,
                          fontSize=self.fntsz,
                          alignment=TA_RIGHT)

  @property
  #= PROPERTY ============================
  #  psbc
  #=======================================
  def psbc(self):

    return ParagraphStyle(name='psbc',
                          fontName=self.fntnmb,
                          fontSize=self.fntsz,
                          alignment=TA_CENTER)

  @property
  #= PROPERTY ============================
  #  psbl
  #=======================================
  def psbl(self):

    return ParagraphStyle(name='psbl',
                          fontName=self.fntnmb,
                          fontSize=self.fntsz,
                          alignment=TA_LEFT)

  @property
  #= PROPERTY ============================
  #  psbr
  #=======================================
  def psbr(self):

    return ParagraphStyle(name='psbr',
                          fontName=self.fntnmb,
                          fontSize=self.fntsz,
                          alignment=TA_RIGHT)


pss = ParagStyles(fnts.s10)


#= CLASS ===============================
#  TblStyles
#=======================================
class TblStyles():

  #= METHOD ==============================
  #  __init__
  #=======================================
  def __init__(self, *args, **kwargs):

    pass

  @property
  #= PROPERTY ============================
  #  alg
  #=======================================
  def alg(self):

    return TableStyle([
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 1),
        ('TOPPADDING', (0, 0), (-1, -1), 1),
        ('LEFTPADDING', (0, 0), (-1, -1), 3),
        ('RIGHTPADDING', (0, 0), (-1, -1), 3),
        ('INNERGRID', (0, 0), (-1, -1), lts.t05, colors.black),
        ('BOX', (0, 0), (-1, -1), lts.t05, colors.black),
    ])

  @property
  #= PROPERTY ============================
  #  acg
  #=======================================
  def acg(self):

    return TableStyle([
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 1),
        ('TOPPADDING', (0, 0), (-1, -1), 1),
        ('LEFTPADDING', (0, 0), (-1, -1), 3),
        ('RIGHTPADDING', (0, 0), (-1, -1), 3),
        ('INNERGRID', (0, 0), (-1, -1), lts.t05, colors.black),
        ('BOX', (0, 0), (-1, -1), lts.t05, colors.black),
    ])

  @property
  #= PROPERTY ============================
  #  alng
  #=======================================
  def alng(self):

    return TableStyle([
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 1),
        ('TOPPADDING', (0, 0), (-1, -1), 1),
        ('LEFTPADDING', (0, 0), (-1, -1), 3),
        ('RIGHTPADDING', (0, 0), (-1, -1), 3),
    ])

  @property
  #= PROPERTY ============================
  #  acng
  #=======================================
  def acng(self):

    return TableStyle([
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 1),
        ('TOPPADDING', (0, 0), (-1, -1), 1),
        ('LEFTPADDING', (0, 0), (-1, -1), 3),
        ('RIGHTPADDING', (0, 0), (-1, -1), 3),
    ])


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
      oxl_fme._leftPadding = 0
      oxl_fme._rightPadding = 0
      oxl_fme._topPadding = 0
      oxl_fme._bottomPadding = 0
      oxl_fme._geom()
    SimpleDocTemplate.addPageTemplates(self, pageTemplates)


#= CLASS ===============================
#  HeaderFooterCanvas
#=======================================
class HeaderFooterCanvas(canvas.Canvas):

  #= METHOD ==============================
  #  __init__
  #=======================================
  def __init__(self, *args, **kwargs):

    canvas.Canvas.__init__(self, *args, **kwargs)
    self.pages = []
    self.width, self.height = A4

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
    oxl_img.drawHeight = 10 * mm
    oxl_img.drawWidth = 37 * mm
    oxl_img.hAlign = 'CENTER'

    vcl_text = ' '.join([
        '{}<br/>'.format(data.fir.fir_naziv), data.fir.fir_adresa_sediste,
        'telefon: {}'.format(data.fir.fir_tel1),
        'mail: {}'.format(data.fir.fir_mail)
    ])
    oxl_pr = Paragraph(vcl_text, pss.psnc)

    lll_data = [[oxl_img, oxl_pr]]
    oxl_table = Table(lll_data, colWidths=[40 * mm, 150 * mm], hAlign='LEFT')
    oxl_table.setStyle(tss.acg)
    oxl_table.wrapOn(self, 0, 0)
    oxl_table.drawOn(self, 10 * mm, A4[1] - 20 * mm + 1)

    if self._pageNumber == pi_pg_cnt:
      oxl_table = zap.tbl_sgn
      oxl_table.wrapOn(self, 0, 0)
      oxl_table.drawOn(self, 10 * mm, A4[1] - 280 * mm)
    vcl_page = 'Strana {} od {}'.format(self._pageNumber, pi_pg_cnt)
    self.setFont('Tahoma', 10)
    self.drawString(175 * mm, 5 * mm, vcl_page)
    self.restoreState()


#= CLASS ===============================
# potvrda
#=======================================
class potvrda(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self,
               pi_PrId,
               pc_PdfFile,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10 * mm,
               pn_bottomMargin=10 * mm,
               pn_leftMargin=10 * mm,
               pn_rightMargin=10 * mm):

    SimpleDocTemplate.__init__(self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin)

    data.dget(pi_PrId, True)
    self.Title = u'IZVOD IZ BAZE O TEHNIČKIM KARAKTERISTIKAMA VOZILA'
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()

  #= METHOD ==============================
  # data_fir
  #=======================================
  def data_fir(self):

    vcl_text = '<br/>'.join([
        data.fir.fir_naziv, data.fir.fir_adresa_sediste, data.fir.fir_opis,
        'telefon: {}'.format(data.fir.fir_tel1),
        'mail: {}'.format(data.fir.fir_mail)
    ])
    oxl_pr = Paragraph(vcl_text, pss.psbl)

    return oxl_pr

  #= METHOD ==============================
  # img_sl
  #=======================================
  def img_sl(self):

    oxl_img = Image(imgs.sl1, kind='proportional')
    oxl_img.drawHeight = 30 * mm
    oxl_img.drawWidth = 115 * mm
    oxl_img.hAlign = 'CENTER'

    return oxl_img

  #= METHOD ==============================
  # tbl_fir
  #=======================================
  def tbl_fir(self):

    oxl_img = self.img_sl()
    oxl_pr = self.data_fir()
    oxl_table = Table([[oxl_img, oxl_pr]],
                      colWidths=[115 * mm, 75 * mm],
                      hAlign='LEFT')
    oxl_table.setStyle(tss.alg)

    return oxl_table

  #= METHOD ==============================
  # tbl_h
  #=======================================
  def tbl_h(self):

    lll_data = []
    for vil_row, oxl_row in enumerate(data.h):
      lll_data.append([
          Paragraph(nvl(oxl_row.h_lbl), pss.psnl),
          Paragraph(nvl(oxl_row.h_val), pss.psnl)
      ])
    oxl_table = Table(lll_data, colWidths=[50 * mm, 65 * mm], hAlign='LEFT')
    oxl_table.setStyle(tss.alg)

    return oxl_table

  #= METHOD ==============================
  # tbl_b
  #=======================================
  def tbl_b(self):

    lll_data = []
    for vil_row, oxl_row in enumerate(data.b):
      lll_data.append([
          Paragraph(nvl(oxl_row.tis_lbl_coc), pss.psnc),
          Paragraph(nvl(oxl_row.tis_lbl_drvlc), pss.psnc),
          Paragraph(nvl(oxl_row.tis_desc), pss.psnl),
          Paragraph(nvl(oxl_row.tis_value), pss.psnl),
      ])

    oxl_table = Table(lll_data,
                      colWidths=[11 * mm, 15 * mm, 100 * mm, 64 * mm],
                      hAlign='LEFT')
    oxl_table.setStyle(tss.alg)

    return oxl_table

  #= METHOD ==============================
  # tbl_f
  #=======================================
  def tbl_f(self):

    lll_data = []
    for vil_row, oxl_row in enumerate(data.f):
      lll_data.append([
          Paragraph(nvl(oxl_row.vz_sert_lbl), pss.psnl),
          Paragraph(nvl(oxl_row.vz_sert), pss.psnl)
      ])
    oxl_table = Table(lll_data, colWidths=[80 * mm, 110 * mm], hAlign='LEFT')
    oxl_table.setStyle(tss.alg)

    return oxl_table

  #= METHOD ==============================
  # tbl_ftr
  #=======================================
  def tbl_ftr(self):

    lll_data = []
    lll_data.append([
        Paragraph(
            u'POTVRĐUJEMO DA JE OVO VOZILO PROIZVEDENO U SKLADU SA EEC/ECE REGULATIVIMA',
            pss.psbl)
    ])
    lll_data.append([
        Paragraph(
            u'Ovaj dokument se izdaje (bez pregleda vozila) na osnovu saobraćajne dozvole i važi bez pečata i potpisa',
            pss.psnl)
    ])

    oxl_table = Table(lll_data, hAlign='LEFT')
    oxl_table.setStyle(tss.alng)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    self.DocElm.append(Spacer(0 * mm, 0 * mm))
    self.DocElm.append(self.tbl_fir())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(self.tbl_h())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(self.tbl_b())

    self.DocElm.append(self.tbl_f())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(self.tbl_ftr())

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

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
    lll_data = [[
        Paragraph(u'Broj:', pss.psnc),
        Paragraph(nvl(data.pr.pr_broj), pss.psnc)
    ]]
    oxl_table = Table(lll_data, colWidths=[20 * mm, 40 * mm], hAlign='CENTER')
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
    lll_data.append([
        Paragraph(u'Podnosilac zahteva:', pss.psnl),
        Paragraph(nvl(data.pr.kl_naziv), pss.psnl)
    ])
    lll_data.append([
        Paragraph(u'Adresa:', pss.psnl),
        Paragraph(nvl(data.pr.kl_adresa), pss.psnl)
    ])
    lll_data.append([
        Paragraph(u'Kontakt:', pss.psnl),
        Paragraph(nvl(data.pr.kl_telefon), pss.psnl)
    ])
    oxl_table = Table(lll_data, colWidths=[35 * mm, 150 * mm], hAlign='LEFT')
    oxl_ts = tss.acng
    oxl_ts.add('LINEBELOW', (1, 0), (1, -1), lts.t05, colors.black)
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # tbl_zvd
  #=======================================
  def tbl_zvd(self, pc_zap):

    lcl_vzdok = nvl(data.pr.pvd_oznaka).split(u'/')
    lcl_vzdokx = [u''] * 4
    for vcl_vzdok in lcl_vzdok:
      if vcl_vzdok == u'SD':
        lcl_vzdokx[0] = u'x'
      elif vcl_vzdok == u'OD':
        lcl_vzdokx[1] = u'x'
      elif vcl_vzdok == u'COC':
        lcl_vzdokx[2] = u'x'
      elif vcl_vzdok == u'PP':
        lcl_vzdokx[3] = u'x'

    lcl_extra = [u''] * 4
    if pc_zap == u'M1':
      lcl_extra = [u'STAKLA:', u'PR. PLOČICA (VW):', u'GORIVO:', u'AC:']
    elif pc_zap == u'M2M3':
      lcl_extra = [u'', u'', u'STAKLA:', u'GORIVO:']
    elif pc_zap == u'L':
      lcl_extra = [u'', u'', u'', u'GORIVO:']
    elif pc_zap == u'N1':
      lcl_extra = [u'', u'STAKLA:', u'PR. PLOČICA (VW):', u'GORIVO:']
    elif pc_zap == u'N2N3':
      lcl_extra = [u'', u'', u'STAKLA:', u'GORIVO:']

    lll_data = [
        [u'Dostavljena dokumentacija', u'', u'', u'', u''],
        [lcl_vzdokx[0], u'Saobraćajna dozvola', u'', lcl_extra[0], u''],
        [lcl_vzdokx[1], u'Odgovarajući dokument', u'', lcl_extra[1], u''],
        [lcl_vzdokx[2], u'COC dokument', u'', lcl_extra[2], u''],
        [lcl_vzdokx[3], u'Potvrda pr. proizvođača', u'', lcl_extra[3], u''],
    ]

    lll_dataf = []
    for lcl_row in lll_data:
      lll_dataf.append([
          Paragraph(lcl_row[0], pss.psnc),
          Paragraph(lcl_row[1], pss.psnl),
          Paragraph(lcl_row[2], pss.psnl),
          Paragraph(lcl_row[3], pss.psnr),
          Paragraph(lcl_row[4], pss.psnc),
      ])
    oxl_table = Table(lll_dataf,
                      colWidths=[7 * mm, 48 * mm, 90 * mm, 38 * mm, 7 * mm],
                      hAlign='LEFT')

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

    if pc_zap == u'O':
      lll_data = [
          [
              u'Zadnje poziciono svetlo', u'', u'Zadnji katadiopteri', u'',
              u'Bočni katadiopteri', u''
          ],
          [
              u'Zadnje stop svetlo', u'', u'Zadnje gabaritno svetlo', u'',
              u'Pneumatici', u''
          ],
          [
              u'Zadnji pokazivač pravca', u'', u'Prednje gabaritno svetlo', u'',
              u'', u''
          ],
          [
              u'Svetla registarske tablice', u'', u'Bočna poziciona svetla',
              u'', u'', u''
          ],
      ]
    else:
      lll_data = [
          [
              u'Prednje glavno svetlo', u'', u'Zadnji pokazivač pravca', u'',
              u'Zadnje gabaritno svetlo', u''
          ],
          [
              u'Prednje poziciono svetlo', u'', u'Svetla registarske tablice',
              u'', u'Bočna poziciona svetla', u''
          ],
          [
              u'Prednje svetlo za maglu', u'', u'Zadnji katadiopteri', u'',
              u'Bočni katadiopteri', u''
          ],
          [
              u'Prednji pokazivač pravca', u'', u'Svetla za vožnju u nazad',
              u'', u'Sigurnosni pojasevi', u''
          ],
          [
              u'Dnevno svetlo za vožnju', u'', u'Sv. za vožnju pri skretanju',
              u'', u'Sigurnosna stakla', u''
          ],
          [
              u'Zadnje poziciono svetlo', u'', u'Zadnja svetla za maglu', u'',
              u'Retrovizori', u''
          ],
          [
              u'Zadnje stop svetlo', u'', u'Parkirno svetlo', u'',
              u'Vučni uređaj', u''
          ],
          [
              u'Pomoćno stop svetlo', u'', u'Prednje gabaritno svetlo', u'',
              u'Pneumatici', u''
          ],
          [u'', u'', u'', u'', u'', u''],
      ]
    lll_data.insert(
        0, [u'KONTROLISANJE HOMOLOGACIONIH OZNAKA', u'', u'', u'', u'', u''])
    lll_data.append([
        'x = uređaj-sistem postoji na vozilu,', u'',
        u'- = uređaj-sistem ne postoji na vozilu,', u'',
        u'N/P = nije primenljivo', u''
    ])
    vil_rows = len(lll_data)
    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append([
          Paragraph(lcl_row[0], (pss.psbc if vil_row == 0 else pss.psnl)),
          Paragraph(lcl_row[1], pss.psnc),
          Paragraph(lcl_row[2],
                    (pss.psnc if vil_row == vil_rows else pss.psnl)),
          Paragraph(lcl_row[3], pss.psnl),
          Paragraph(lcl_row[4],
                    (pss.psnc if vil_row == vil_rows else pss.psnl)),
          Paragraph(lcl_row[5], pss.psnl),
      ])
    oxl_table = Table(
        lll_dataf,
        rowHeights=[5 * mm] * len(lll_data),
        colWidths=[56 * mm, 7 * mm, 56 * mm, 8 * mm, 55 * mm, 8 * mm],
        hAlign='LEFT')

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
    lll_data.append([
        u'0.10.', u'(E)', u'Identifikaciona oznaka (VIN)', data.pr.vz_sasija,
        u''
    ])
    if pc_zap != u'O':
      lll_data.append(
          [u'21', u'(P)', u'Oznaka motora', data.pr.mto_oznaka, u''])
    lll_data.append([
        u'0.1.', u'(D.1)', u'Marka (komercijalni naziv proizvođača)',
        data.pr.mr_naziv, u''
    ])
    lll_data.append(
        [u'0.2.1.', u'(D.3)', u'Komercijalna oznaka', data.pr.md_naziv_k, u''])
    lll_data.append([u'0.4', u'(J)', u'Vrsta', data.pr.vz_kategorija, u''])
    lll_data.append(
        [u'38.', u'(J.1)', u'Oznaka oblika karoserije', data.pr.vz_vzk, u''])
    lll_data.append([
        u'0.2.', u'(D.2)', u'Tip / Varijanta / Verzija', data.pr.vz_mdtvv, u''
    ])
    lll_data.append([
        u'16.', u'(F.1)', u'Najveća dozvoljena masa [kg]', data.pr.vz_masa_max,
        u''
    ])
    lll_data.append([
        u'16.2.', u'(N)', u'Najveće dozvolj. oso. opterećenje [kg]',
        data.pr.vz_os_nosivost, u''
    ])
    lll_data.append(
        [u'1.', u'(L)', u'Broj osovina i točkova', data.pr.vz_os_broj, u''])
    if pc_zap != u'O':
      lll_data.append([
          u'42.', u'(S.1)', u'Broj mesta za sedenje', data.pr.vz_mesta_sedenje,
          u''
      ])
    lll_data.append([u'35.', u'', u'Pneumatici', data.pr.vz_os_pneumatici, u''])
    lll_data.append([
        u'Uređaj za spajanje vučnog i priključnog vozila (da/ne)', u'', u'',
        data.pr.vz_kuka, u''
    ])
    lll_data.append([u'Očitana kilometraža', u'', u'', data.pr.vz_km, u''])

    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append([
          Paragraph(lcl_row[0], (pss.psnc if vil_row < 12 else pss.psnl)),
          Paragraph(lcl_row[1], pss.psnc),
          Paragraph(lcl_row[2], pss.psnl),
          Paragraph(lcl_row[3], pss.psnl),
          Paragraph(lcl_row[4], pss.psnc),
      ])
    oxl_table = Table(lll_dataf,
                      colWidths=[13 * mm, 13 * mm, 63 * mm, 94 * mm, 7 * mm],
                      hAlign='LEFT')

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
    lll_data.append([Paragraph(u'', pss.psnl)])
    oxl_table = Table(lll_data,
                      rowHeights=[25 * mm],
                      colWidths=[190 * mm],
                      hAlign='LEFT')
    oxl_ts = tss.alng
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  @property
  #= PROPERTY ============================
  # tbl_sgn
  #=======================================
  def tbl_sgn(self):

    lll_data = []
    lll_data.append([
        Paragraph(u'Datum', pss.psnc),
        Paragraph(u'', pss.psnl),
        Paragraph(u'Kontrolor', pss.psnc)
    ])
    lll_data.append([
        Paragraph(data.pr.pr_datum, pss.psnc),
        Paragraph(u'', pss.psnc),
        Paragraph(u'', pss.psnc)
    ])
    lll_data.append([
        Paragraph(u'', pss.psnc),
        Paragraph(u'', pss.psnc),
        Paragraph(u'{} {}'.format(data.pr.kr_ime, data.pr.kr_prezime), pss.psnc)
    ])
    oxl_table = Table(lll_data,
                      rowHeights=[5 * mm, 10 * mm, 5 * mm],
                      colWidths=[63 * mm, 64 * mm, 63 * mm],
                      hAlign='LEFT')
    oxl_ts = tss.acng
    oxl_ts.add('LINEBELOW', (0, 1), (0, 1), lts.t05, colors.black)
    oxl_ts.add('LINEBELOW', (2, 1), (2, 1), lts.t05, colors.black)
    oxl_ts.add('VALIGN', (0, 1), (0, 1), 'BOTTOM')
    oxl_table.setStyle(oxl_ts)

    return oxl_table


zap = zapisnici()


#= CLASS ===============================
# zapisnik_m1
#=======================================
class zapisnik_m1(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self,
               pi_PrId,
               pc_PdfFile,
               pc_UserName=None,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10 * mm,
               pn_bottomMargin=10 * mm,
               pn_leftMargin=10 * mm,
               pn_rightMargin=10 * mm):

    SimpleDocTemplate.__init__(self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin)

    data.dget(pi_PrId)
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
        [
            'KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'',
            u''
        ],
        [
            '1', u'uređaji za upravlj. - sistem za upravljanje',
            u'komanda na levoj strani', u'', u'*'
        ],
        [
            '2', u'uređaji za zaustavljanje vozila - kočni sistem', u'radna',
            u'', u'*'
        ],
        ['', u'', u'pomoćna', u'', u'*'],
        ['', u'', u'parkirna', u'', u'*'],
        ['', u'', u'ABS (ako ima)', u'', u'*'],
        [
            '3', u'uređaji za osvetljavanje puta',
            u'svetlosno i svetlosno signalni uređaji', u'', u'*'
        ],
        ['', u'', u'uređaji za označavanje vozila', u'', u'*'],
        ['', u'', u'uređaji za davanje svetlosnih znakova', u'', u'*'],
        [
            '4', u'uređaji koji omogućuju normalnu vidljivost',
            u'retrovizori spoljni oba i unutrašnji', u'', u'*'
        ],
        ['', u'', u'stakla i zatamnjena stakla', u'', u'*'],
        ['', u'', u'uređaj za brisanje', u'', u''],
        ['', u'', u'uređaj za kvašenje', u'', u''],
        ['5', u'uređaj za davanje zvučnih znakova', u'', u'', u'*'],
        [
            '6', u'uređaji za kontrolu i davanje znakova',
            u'brzinomer sa odometrom', u'', u''
        ],
        ['', u'', u'plavo kontrolno svetlo za dugo svetlo', u'', u''],
        ['', u'', u'svetlosni ili zvučni znak za pokazivanje pravca', u'', u''],
        [
            '7', u'uređaji za odvođenje i regulisanje izduvnih gasova',
            u'katalizator', u'', u'*'
        ],
        ['', u'', u'ne u desnu stranu i u gabaritima izduva', u'', u''],
        [
            '8', u'uređaji za spajanje vučnog i priključnog vozila',
            u'rastavljen ne sme da premaši gabarit', u'', u'*'
        ],
        ['9', u'uređaj za kretanje vozila u nazad', u'', u'', u''],
        [
            '10', u'uređaji za oslanjanje',
            u'bez kontakta točkova i karoserije', u'', u''
        ],
        [
            '11', u'uređaji za kretanje', u'pneumatici jednaki po osovinama',
            u'', u''
        ],
        ['12', u'elektro uređaji i instalacija', u'', u'', u''],
        ['13', u'pogonski uređaj', u'', u'', u''],
        [
            '14', u'uređaj za prenos snage', u'bar jedna ruka na upravljaču',
            u'', u''
        ],
        [
            '15', u'delovi vozila od posebnog značaja za bezbednost saobraćaja',
            u'opšta konstrukcija', u'', u'*'
        ],
        ['', u'', u'VIN', u'', u''],
        ['', u'', u'otvor goriva ne u kabini i prostoru za putnike', u'', u''],
        ['', u'', u'istureni delovi, ukrasi bez oštrih ivica', u'', u''],
        ['', u'', u'reklamne table u gabaritima', u'', u''],
        ['', u'', u'prostor za tablicu', u'', u''],
        ['', u'', u'unutrašnja rasveta', u'', u''],
        ['', u'', u'dvostepene brave', u'', u''],
        ['', u'', u'blatobrani iznad svih točkova u širini točka', u'', u''],
        ['', u'', u'branik najmanje napred najistureniji', u'', u''],
        ['', u'', u'pojasevi za sva mesta', u'', u'*'],
        ['', u'', u'priključak za vuču neispravnog vozula', u'', u'*'],
        ['16', u'Uređaj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
        [
            '', u'x = uređaj/sistem postoji na vozilu,',
            u'- = uređaj/sistem ne postoji na vozilu', u'', u''
        ],
        [
            '', u'&nbsp;' * 15 + u'N/P = nije primenljivo,',
            u'&nbsp;' * 15 + u'* = obavezna homologacija', u'', u''
        ],
    ]
    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append([
          Paragraph(lcl_row[0], (pss.psbc if vil_row == 0 else pss.psnr)),
          Paragraph(lcl_row[1], pss.psnl),
          Paragraph(lcl_row[2], pss.psnl),
          Paragraph(lcl_row[3], pss.psnl),
          Paragraph(lcl_row[4], pss.psnl),
      ])
    oxl_table = Table(lll_dataf,
                      colWidths=[9 * mm, 78 * mm, 81 * mm, 15 * mm, 7 * mm],
                      hAlign='LEFT')

    oxl_ts = tss.alng
    oxl_ts.add('ALIGN', (0, 1), (0, -3), 'RIGHT')
    oxl_ts.add('ALIGN', (1, 1), (-1, -1), 'LEFT')
    oxl_ts.add('BOX', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, -2), (-1, -1), lts.t05, colors.black)
    oxl_ts.add('INNERGRID', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('SPAN', (0, 0), (-1, 0))
    oxl_ts.add('SPAN', (0, 2), (0, 5))
    oxl_ts.add('SPAN', (1, 2), (1, 5))
    oxl_ts.add('SPAN', (0, 6), (0, 8))
    oxl_ts.add('SPAN', (1, 6), (1, 8))
    oxl_ts.add('SPAN', (0, 9), (0, 12))
    oxl_ts.add('SPAN', (1, 9), (1, 12))
    oxl_ts.add('SPAN', (0, 14), (0, 16))
    oxl_ts.add('SPAN', (1, 14), (1, 16))
    oxl_ts.add('SPAN', (0, 17), (0, 18))
    oxl_ts.add('SPAN', (1, 17), (1, 18))
    oxl_ts.add('SPAN', (0, 26), (0, 37))
    oxl_ts.add('SPAN', (1, 26), (1, 37))
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0 * mm, 35 * mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zvd(u'M1'))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_vzdata())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_hmlgo())

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0 * mm, 15 * mm))
    self.DocElm.append(self.tbl_ppv())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HeaderFooterCanvas)


#= CLASS ===============================
# zapisnik_m2m3
#=======================================
class zapisnik_m2m3(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self,
               pi_PrId,
               pc_PdfFile,
               pc_UserName=None,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10 * mm,
               pn_bottomMargin=10 * mm,
               pn_leftMargin=10 * mm,
               pn_rightMargin=10 * mm):

    SimpleDocTemplate.__init__(self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin)

    data.dget(pi_PrId)
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
        [
            'KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'',
            u''
        ],
        [
            '1', u'uređaji za upravlj. - sistem za upravljanje',
            u'komanda na levoj strani', u'', u'*'
        ],
        [
            '2', u'uređaji za zaustavljanje vozila - kočni sistem', u'radna',
            u'', u'*'
        ],
        ['', u'', u'pomoćna', u'', u'*'],
        ['', u'', u'parkirna', u'', u'*'],
        ['', u'', u'ABS (ako ima)', u'', u'*'],
        ['', u'', u'usporač', u'', u'*'],
        [
            '3', u'uređaji za osvetljavanje puta',
            u'svetlosno i svetlosno signalni uređaji', u'', u'*'
        ],
        ['', u'', u'uređaji za označavanje vozila', u'', u'*'],
        ['', u'', u'uređaji za davanje svetlosnih znakova', u'', u'*'],
        [
            '4', u'uređaji koji omogućuju normalnu vidljivost',
            u'retrovizori spoljni oba i unutrašnji', u'', u'*'
        ],
        ['', u'', u'stakla i zatamnjena stakla', u'', u'*'],
        ['', u'', u'uređaj za brisanje', u'', u''],
        ['', u'', u'uređaj za kvašenje', u'', u''],
        [
            '5', u'uređaj za davanje zvučnih znakova',
            u'uključujući i signal pri kretanju unazad', u'', u''
        ],
        [
            '6', u'uređaji za kontrolu i davanje znakova',
            u'brzinomer sa odometrom', u'', u''
        ],
        ['', u'', u'indikator pritiska u sistemu za radno kočenje', u'', u''],
        ['', u'', u'digitalni tahograf', u'', u''],
        ['', u'', u'plavo kontrolno svetlo za dugo svetlo', u'', u''],
        ['', u'', u'ograničavač brzine do 100 km/H', u'', u'*'],
        [
            '', u'', u'svetlosni signal za kontrolu zatvorenih vrata (kl I/II)',
            u'', u''
        ],
        [
            '', u'', u'uređaj za dav. i prim. znakova od putnika (kl I/II)',
            u'', u''
        ],
        ['', u'', u'svetlosni ili zvučni znak za pokazivanje pravca', u'', u''],
        [
            '7', u'uređaji za odvođenje i regulisanje izduvnih gasova',
            u'katalizator', u'', u'*'
        ],
        ['', u'', u'ne u desnu stranu i u gabaritima izduva', u'', u''],
        [
            '8', u'uređaji za spajanje vučnog i priključnog vozila',
            u'rastavljen ne sme da premaši gabarit', u'', u'*'
        ],
        ['9', u'uređaj za kretanje vozila u nazad', u'', u'', u''],
        [
            '10', u'uređaji za oslanjanje',
            u'bez kontakta točkova i karoserije', u'', u''
        ],
        [
            '11', u'uređaji za kretanje', u'pneumatici jednaki po osovinama',
            u'', u''
        ],
        [
            '12', u'elektro uređaji i instalacija',
            u'prekidač svih strujnih kola osim taho. i bezb. uređa', u'', u''
        ],
        [
            '13', u'pogonski uređaj',
            u'nije moguće povređivanje vozača i putnika', u'', u''
        ],
        [
            '14', u'uređaj za prenos snage', u'bar jedna ruka na upravljaču',
            u'', u''
        ],
        [
            '15', u'delovi vozila od posebnog značaja za bezbednost saobraćaja',
            u'opšta konstrukcija', u'', u'*'
        ],
        ['', u'', u'VIN', u'', u''],
        ['', u'', u'otvor goriva ne u kabini i prostoru za putnike', u'', u''],
        ['', u'', u'istureni delovi, ukrasi bez oštrih ivica', u'', u''],
        ['', u'', u'reklamne table u gabaritima', u'', u''],
        ['', u'', u'prostor za tablicu', u'', u''],
        ['', u'', u'slobodna površina za stajanje putnika', u'', u''],
        ['', u'', u'pričvršćenost alata, pribora, uređaja i opreme', u'', u''],
        ['', u'', u'izlaz u slučaju opasnosti (na krovu i vrata)', u'', u''],
        ['', u'', u'uređaj za provetravanje', u'', u''],
        ['', u'', u'unutrašnja rasveta', u'', u''],
        ['', u'', u'dvostepene brave', u'', u''],
        ['', u'', u'blatobrani iznad svih točkova u širini točka', u'', u''],
        ['', u'', u'branik najmanje napred najistureniji', u'', u''],
        ['', u'', u'pojasevi za sva mesta', u'', u'*'],
        [
            '', u'', u'putnički prost. obezbeđen od prodora štetnih gasova',
            u'', u''
        ],
        ['', u'', u'priključak za vuču neispravnog vozila', u'', u'*'],
        ['16', u'Uređaj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
        [
            '', u'x = uređaj/sistem postoji na vozilu,',
            u'- = uređaj/sistem ne postoji na vozilu', u'', u''
        ],
        [
            '', u'&nbsp;' * 15 + u'N/P = nije primenljivo,',
            u'&nbsp;' * 15 + u'* = obavezna homologacija', u'', u''
        ],
    ]
    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append([
          Paragraph(lcl_row[0], (pss.psbc if vil_row == 0 else pss.psnr)),
          Paragraph(lcl_row[1], pss.psnl),
          Paragraph(lcl_row[2], pss.psnl),
          Paragraph(lcl_row[3], pss.psnl),
          Paragraph(lcl_row[4], pss.psnl),
      ])
    oxl_table = Table(lll_dataf,
                      rowHeights=[4 * mm] * len(lll_dataf),
                      colWidths=[9 * mm, 75 * mm, 84 * mm, 15 * mm, 7 * mm],
                      hAlign='LEFT')

    oxl_ts = tss.alng
    oxl_ts.add('ALIGN', (0, 1), (0, -3), 'RIGHT')
    oxl_ts.add('ALIGN', (1, 1), (-1, -1), 'LEFT')
    oxl_ts.add('BOX', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, -2), (-1, -1), lts.t05, colors.black)
    oxl_ts.add('INNERGRID', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('SPAN', (0, 0), (-1, 0))
    oxl_ts.add('SPAN', (0, 2), (0, 6))
    oxl_ts.add('SPAN', (1, 2), (1, 6))
    oxl_ts.add('SPAN', (0, 7), (0, 9))
    oxl_ts.add('SPAN', (1, 7), (1, 9))
    oxl_ts.add('SPAN', (0, 10), (0, 13))
    oxl_ts.add('SPAN', (1, 10), (1, 13))
    oxl_ts.add('SPAN', (0, 15), (0, 22))
    oxl_ts.add('SPAN', (1, 15), (1, 22))
    oxl_ts.add('SPAN', (0, 23), (0, 24))
    oxl_ts.add('SPAN', (1, 23), (1, 24))
    oxl_ts.add('SPAN', (0, 32), (0, 48))
    oxl_ts.add('SPAN', (1, 32), (1, 48))
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0 * mm, 35 * mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zvd(u'M2M3'))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_vzdata())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_hmlgo())

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0 * mm, 15 * mm))
    self.DocElm.append(self.tbl_ppv())
    #    oxl_tbl = self.tbl_ppv()
    #    for oxl_split in oxl_tbl.split(0*mm, 260*mm):
    #        self.DocElm.append(oxl_split)
    #        self.DocElm.append(Spacer(0*mm, 15*mm))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HeaderFooterCanvas)


#= CLASS ===============================
# zapisnik_l
#=======================================
class zapisnik_l(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self,
               pi_PrId,
               pc_PdfFile,
               pc_UserName=None,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10 * mm,
               pn_bottomMargin=10 * mm,
               pn_leftMargin=10 * mm,
               pn_rightMargin=10 * mm):

    SimpleDocTemplate.__init__(self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin)

    data.dget(pi_PrId)
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
        [
            'KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'',
            u''
        ],
        [
            '1', u'uređaji za upravlj. - sistem za upravljanje',
            u'komanda na levoj strani', u'', u'*'
        ],
        [
            '2', u'uređaji za zaustavljanje vozila - kočni sistem', u'radna',
            u'', u'*'
        ],
        ['', u'', u'pomoćna (L5 i L7 m>1t)', u'', u'*'],
        ['', u'', u'parkirna L7', u'', u'*'],
        [
            '3', u'svetlosno i svetlosno signalni uređaji',
            u'uređaji za osvetljavanje puta', u'', u'*'
        ],
        ['', u'', u'uređaji za označavanje vozila', u'', u'*'],
        ['', u'', u'uređaji za davanje svetlosnih znakova', u'', u'*'],
        [
            '4', u'uređaji koji omogućuju normalnu vidljivost', u'retrovizori',
            u'', u'*'
        ],
        ['', u'', u'stakla i zatamnjena stakla', u'', u'*'],
        ['', u'', u'uređaj za brisanje', u'', u''],
        ['', u'', u'uređaj za kvašenje', u'', u''],
        ['5', u'uređaj za davanje zvučnih znakova', u'', u'', u'*'],
        [
            '6', u'uređaji za kontrolu i davanje znakova',
            u'brzinomer sa odometrom', u'', u''
        ],
        ['', u'', u'plavo kontrolno svetlo za dugo svetlo', u'', u''],
        ['', u'', u'svetlosni ili zvučni znak za pokazivanje pravca', u'', u''],
        [
            '7', u'uređaji za odvođenje i regulisanje izduvnih gasova',
            u'katalizator', u'', u'*'
        ],
        [
            '8', u'uređaji za spajanje vučnog i priključnog vozila',
            u'rastavljen ne sme da premaši gabarit', u'', u'*'
        ],
        ['9', u'uređaj za kretanje vozila u nazad', u'', u'', u''],
        [
            '10', u'uređaji za oslanjanje',
            u'bez kontakta točkova i karoserije', u'', u''
        ],
        [
            '11', u'uređaji za kretanje', u'pneumatici jednaki po osovinama',
            u'', u''
        ],
        ['12', u'elektro uređaji i instalacija', u'', u'', u''],
        ['13', u'pogonski uređaj', u'', u'', u''],
        [
            '14', u'uređaj za prenos snage', u'bar jedna ruka na upravljaču',
            u'', u''
        ],
        [
            '15', u'delovi vozila od posebnog značaja za bezbednost saobraćaja',
            u'opšta konstrukcija', u'', u'*'
        ],
        ['', u'', u'VIN', u'', u''],
        ['', u'', u'otvor goriva ne u kabini i prostoru za putnike', u'', u''],
        ['', u'', u'istureni delovi, ukrasi bez oštrih ivica', u'', u''],
        ['', u'', u'reklamne table u gabaritima', u'', u''],
        ['', u'', u'pričvršćenost pribora, alata i opreme', u'', u''],
        ['', u'', u'prostor za tablicu', u'', u''],
        ['', u'', u'blatobrani iznad svih točkova u širini točka', u'', u''],
        ['16', u'Uređaj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
        [
            '', u'x = uređaj/sistem postoji na vozilu,',
            u'- = uređaj/sistem ne postoji na vozilu', u'', u''
        ],
        [
            '', u'&nbsp;' * 15 + u'N/P = nije primenljivo,',
            u'&nbsp;' * 15 + u'* = obavezna homologacija', u'', u''
        ],
    ]
    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append([
          Paragraph(lcl_row[0], (pss.psbc if vil_row == 0 else pss.psnr)),
          Paragraph(lcl_row[1], pss.psnl),
          Paragraph(lcl_row[2], pss.psnl),
          Paragraph(lcl_row[3], pss.psnl),
          Paragraph(lcl_row[4], pss.psnl),
      ])
    oxl_table = Table(lll_dataf,
                      colWidths=[9 * mm, 78 * mm, 81 * mm, 15 * mm, 7 * mm],
                      hAlign='LEFT')

    oxl_ts = tss.alng
    oxl_ts.add('ALIGN', (0, 1), (0, -3), 'RIGHT')
    oxl_ts.add('ALIGN', (1, 1), (-1, -1), 'LEFT')
    oxl_ts.add('BOX', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, -2), (-1, -1), lts.t05, colors.black)
    oxl_ts.add('INNERGRID', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('SPAN', (0, 0), (-1, 0))
    oxl_ts.add('SPAN', (0, 2), (0, 4))
    oxl_ts.add('SPAN', (1, 2), (1, 4))
    oxl_ts.add('SPAN', (0, 5), (0, 7))
    oxl_ts.add('SPAN', (1, 5), (1, 7))
    oxl_ts.add('SPAN', (0, 8), (0, 11))
    oxl_ts.add('SPAN', (1, 8), (1, 11))
    oxl_ts.add('SPAN', (0, 13), (0, 15))
    oxl_ts.add('SPAN', (1, 13), (1, 15))
    oxl_ts.add('SPAN', (0, 24), (0, 31))
    oxl_ts.add('SPAN', (1, 24), (1, 31))
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0 * mm, 35 * mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zvd(u'L'))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_vzdata())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_hmlgo())

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0 * mm, 15 * mm))
    self.DocElm.append(self.tbl_ppv())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HeaderFooterCanvas)


#= CLASS ===============================
# zapisnik_n1
#=======================================
class zapisnik_n1(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self,
               pi_PrId,
               pc_PdfFile,
               pc_UserName=None,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10 * mm,
               pn_bottomMargin=10 * mm,
               pn_leftMargin=10 * mm,
               pn_rightMargin=10 * mm):

    SimpleDocTemplate.__init__(self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin)

    data.dget(pi_PrId)
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
        [
            'KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'',
            u''
        ],
        [
            '1', u'uređaji za upravlj. - sistem za upravljanje',
            u'komanda na levoj strani', u'', u'*'
        ],
        [
            '2', u'uređaji za zaustavljanje vozila - kočni sistem', u'radna',
            u'', u'*'
        ],
        ['', u'', u'pomoćna', u'', u'*'],
        ['', u'', u'parkirna', u'', u'*'],
        ['', u'', u'ABS (ako ima)', u'', u'*'],
        [
            '3', u'uređaji za osvetljavanje puta',
            u'svetlosno i svetlosno signalni uređaji', u'', u'*'
        ],
        ['', u'', u'uređaji za označavanje vozila', u'', u'*'],
        ['', u'', u'uređaji za davanje svetlosnih znakova', u'', u'*'],
        [
            '4', u'uređaji koji omogućuju normalnu vidljivost',
            u'retrovizori spoljni oba i unutrašnji', u'', u'*'
        ],
        ['', u'', u'stakla i zatamnjena stakla', u'', u'*'],
        ['', u'', u'uređaj za brisanje', u'', u''],
        ['', u'', u'uređaj za kvašenje', u'', u''],
        ['5', u'uređaj za davanje zvučnih znakova', u'', u'', u'*'],
        [
            '6', u'uređaji za kontrolu i davanje znakova',
            u'brzinomer sa odometrom', u'', u''
        ],
        ['', u'', u'plavo kontrolno svetlo za dugo svetlo', u'', u''],
        ['', u'', u'svetlosni ili zvučni znak za pokazivanje pravca', u'', u''],
        [
            '7', u'uređaji za odvođenje i regulisanje izduvnih gasova',
            u'katalizator', u'', u'*'
        ],
        ['', u'', u'ne u desnu stranu i u gabaritima izduva', u'', u''],
        [
            '8', u'uređaji za spajanje vučnog i priključnog vozila',
            u'rastavljen ne sme da premaši gabarit', u'', u'*'
        ],
        ['9', u'uređaj za kretanje vozila u nazad', u'', u'', u''],
        [
            '10', u'uređaji za oslanjanje',
            u'bez kontakta točkova i karoserije', u'', u''
        ],
        [
            '11', u'uređaji za kretanje', u'pneumatici jednaki po osovinama',
            u'', u''
        ],
        ['12', u'elektro uređaji i instalacija', u'', u'', u''],
        ['13', u'pogonski uređaj', u'', u'', u''],
        [
            '14', u'uređaj za prenos snage', u'bar jedna ruka na upravljaču',
            u'', u''
        ],
        [
            '15', u'delovi vozila od posebnog značaja za bezbednost saobraćaja',
            u'opšta konstrukcija', u'', u'*'
        ],
        ['', u'', u'VIN', u'', u''],
        ['', u'', u'otvor goriva ne u kabini i prostoru za putnike', u'', u''],
        ['', u'', u'istureni delovi, ukrasi bez oštrih ivica', u'', u''],
        ['', u'', u'reklamne table u gabaritima', u'', u''],
        ['', u'', u'prostor za tablicu', u'', u''],
        ['', u'', u'unutrašnja rasveta', u'', u''],
        ['', u'', u'dvostepene brave', u'', u''],
        [
            '', u'',
            u'blatobrani iznad svih točkova u širini točka (osim kipera)', u'',
            u''
        ],
        ['', u'', u'branik najmanje napred najistureniji', u'', u''],
        ['', u'', u'pojasevi za sva mesta', u'', u'*'],
        ['', u'', u'priključak za vuču neispravnog vozula', u'', u'*'],
        ['', u'', u'ispunjenost standarda ISO 27956:2009 (za BB)', u'', u'*'],
        ['16', u'Uređaj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
        [
            '', u'x = uređaj/sistem postoji na vozilu,',
            u'- = uređaj/sistem ne postoji na vozilu', u'', u''
        ],
        [
            '', u'&nbsp;' * 15 + u'N/P = nije primenljivo,',
            u'&nbsp;' * 15 + u'* = obavezna homologacija', u'', u''
        ],
    ]
    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append([
          Paragraph(lcl_row[0], (pss.psbc if vil_row == 0 else pss.psnr)),
          Paragraph(lcl_row[1], pss.psnl),
          Paragraph(lcl_row[2], pss.psnl),
          Paragraph(lcl_row[3], pss.psnl),
          Paragraph(lcl_row[4], pss.psnl),
      ])
    oxl_table = Table(lll_dataf,
                      colWidths=[9 * mm, 78 * mm, 81 * mm, 15 * mm, 7 * mm],
                      hAlign='LEFT')

    oxl_ts = tss.alng
    oxl_ts.add('ALIGN', (0, 1), (0, -3), 'RIGHT')
    oxl_ts.add('ALIGN', (1, 1), (-1, -1), 'LEFT')
    oxl_ts.add('BOX', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, -2), (-1, -1), lts.t05, colors.black)
    oxl_ts.add('INNERGRID', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('SPAN', (0, 0), (-1, 0))
    oxl_ts.add('SPAN', (0, 2), (0, 5))
    oxl_ts.add('SPAN', (1, 2), (1, 5))
    oxl_ts.add('SPAN', (0, 6), (0, 8))
    oxl_ts.add('SPAN', (1, 6), (1, 8))
    oxl_ts.add('SPAN', (0, 9), (0, 12))
    oxl_ts.add('SPAN', (1, 9), (1, 12))
    oxl_ts.add('SPAN', (0, 14), (0, 16))
    oxl_ts.add('SPAN', (1, 14), (1, 16))
    oxl_ts.add('SPAN', (0, 17), (0, 18))
    oxl_ts.add('SPAN', (1, 17), (1, 18))
    oxl_ts.add('SPAN', (0, 26), (0, 38))
    oxl_ts.add('SPAN', (1, 26), (1, 38))
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0 * mm, 35 * mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zvd(u'N1'))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_vzdata())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_hmlgo())

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0 * mm, 15 * mm))
    self.DocElm.append(self.tbl_ppv())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HeaderFooterCanvas)


#= CLASS ===============================
# zapisnik_n2n3
#=======================================
class zapisnik_n2n3(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self,
               pi_PrId,
               pc_PdfFile,
               pc_UserName=None,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10 * mm,
               pn_bottomMargin=10 * mm,
               pn_leftMargin=10 * mm,
               pn_rightMargin=10 * mm):

    SimpleDocTemplate.__init__(self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin)

    data.dget(pi_PrId)
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
        [
            'KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'',
            u''
        ],
        [
            '1', u'uređaji za upravlj. - sistem za upravljanje',
            u'komanda na levoj strani', u'', u'*'
        ],
        [
            '2', u'uređaji za zaustavljanje vozila - kočni sistem', u'radna',
            u'', u'*'
        ],
        ['', u'', u'pomoćna', u'', u'*'],
        ['', u'', u'parkirna', u'', u'*'],
        ['', u'', u'ABS (ako ima)', u'', u'*'],
        ['', u'', u'usporač', u'', u'*'],
        [
            '3', u'uređaji za osvetljavanje puta',
            u'svetlosno i svetlosno signalni uređaji', u'', u'*'
        ],
        ['', u'', u'uređaji za označavanje vozila', u'', u'*'],
        ['', u'', u'uređaji za davanje svetlosnih znakova', u'', u'*'],
        [
            '4', u'uređaji koji omogućuju normalnu vidljivost',
            u'retrovizori spoljni oba i unutrašnji', u'', u'*'
        ],
        ['', u'', u'stakla i zatamnjena stakla', u'', u'*'],
        ['', u'', u'uređaj za brisanje', u'', u''],
        ['', u'', u'uređaj za kvašenje', u'', u''],
        [
            '5', u'uređaj za davanje zvučnih znakova',
            u'uključujući i signal pri kretanju unazad', u'', u''
        ],
        [
            '6', u'uređaji za kontrolu i davanje znakova',
            u'brzinomer sa odometrom', u'', u''
        ],
        ['', u'', u'indikator pritiska u sistemu za radno kočenje', u'', u''],
        ['', u'', u'digitalni tahograf', u'', u''],
        ['', u'', u'plavo kontrolno svetlo za dugo svetlo', u'', u''],
        ['', u'', u'ograničavač brzine do 100 (90) km/h', u'', u'*'],
        ['', u'', u'svetlosni ili zvučni znak za pokazivanje pravca', u'', u''],
        [
            '7', u'uređaji za odvođenje i regulisanje izduvnih gasova',
            u'katalizator', u'', u'*'
        ],
        ['', u'', u'ne u desnu stranu i u gabaritima izduva', u'', u''],
        [
            '8', u'uređaji za spajanje vučnog i priključnog vozila',
            u'rastavljen ne sme da premaši gabarit', u'', u'*'
        ],
        ['9', u'uređaj za kretanje vozila u nazad', u'', u'', u''],
        [
            '10', u'uređaji za oslanjanje',
            u'bez kontakta točkova i karoserije', u'', u''
        ],
        [
            '11', u'uređaji za kretanje', u'pneumatici jednaki po osovinama',
            u'', u''
        ],
        [
            '12', u'elektro uređaji i instalacija',
            u'prekidač svih strujnih kola osim taho. i bezb. uređa', u'', u''
        ],
        [
            '13', u'pogonski uređaj',
            u'nije moguće povređivanje vozača i putnika', u'', u''
        ],
        [
            '14', u'uređaj za prenos snage', u'bar jedna ruka na upravljaču',
            u'', u''
        ],
        [
            '15', u'delovi vozila od posebnog značaja za bezbednost saobraćaja',
            u'opšta konstrukcija', u'', u'*'
        ],
        ['', u'', u'VIN', u'', u''],
        ['', u'', u'otvor goriva ne u kabini i prostoru za putnike', u'', u''],
        ['', u'', u'istureni delovi, ukrasi bez oštrih ivica', u'', u''],
        ['', u'', u'reklamne table u gabaritima', u'', u''],
        ['', u'', u'prostor za tablicu', u'', u''],
        ['', u'', u'unutrašnja rasveta', u'', u''],
        ['', u'', u'dvostepene brave', u'', u''],
        [
            '', u'', u'blatobr. iznad svih toč. u širini toč. (osim kipera)',
            u'', u''
        ],
        ['', u'', u'branik najmanje napred najistureniji', u'', u''],
        ['', u'', u'pojasevi za sva mesta', u'', u'*'],
        ['', u'', u'ZZOP (osim tegljača)', u'', u''],
        ['', u'', u'BZOP (osim tegljača)', u'', u'*'],
        ['16', u'Uređaj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
        [
            '', u'x = uređaj/sistem postoji na vozilu,',
            u'- = uređaj/sistem ne postoji na vozilu', u'', u''
        ],
        [
            '', u'&nbsp;' * 15 + u'N/P = nije primenljivo,',
            u'&nbsp;' * 15 + u'* = obavezna homologacija', u'', u''
        ],
    ]
    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append([
          Paragraph(lcl_row[0], (pss.psbc if vil_row == 0 else pss.psnr)),
          Paragraph(lcl_row[1], pss.psnl),
          Paragraph(lcl_row[2], pss.psnl),
          Paragraph(lcl_row[3], pss.psnl),
          Paragraph(lcl_row[4], pss.psnl),
      ])
    oxl_table = Table(lll_dataf,
                      colWidths=[9 * mm, 75 * mm, 84 * mm, 15 * mm, 7 * mm],
                      hAlign='LEFT')

    oxl_ts = tss.alng
    oxl_ts.add('ALIGN', (0, 1), (0, -3), 'RIGHT')
    oxl_ts.add('ALIGN', (1, 1), (-1, -1), 'LEFT')
    oxl_ts.add('BOX', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, -2), (-1, -1), lts.t05, colors.black)
    oxl_ts.add('INNERGRID', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('SPAN', (0, 0), (-1, 0))
    oxl_ts.add('SPAN', (0, 2), (0, 6))
    oxl_ts.add('SPAN', (1, 2), (1, 6))
    oxl_ts.add('SPAN', (0, 7), (0, 9))
    oxl_ts.add('SPAN', (1, 7), (1, 9))
    oxl_ts.add('SPAN', (0, 10), (0, 13))
    oxl_ts.add('SPAN', (1, 10), (1, 13))
    oxl_ts.add('SPAN', (0, 15), (0, 20))
    oxl_ts.add('SPAN', (1, 15), (1, 20))
    oxl_ts.add('SPAN', (0, 21), (0, 22))
    oxl_ts.add('SPAN', (1, 21), (1, 22))
    oxl_ts.add('SPAN', (0, 30), (0, 42))
    oxl_ts.add('SPAN', (1, 30), (1, 42))
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0 * mm, 35 * mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zvd(u'N2N3'))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_vzdata())

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_hmlgo())

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0 * mm, 15 * mm))
    self.DocElm.append(self.tbl_ppv())
    #    oxl_tbl = self.tbl_ppv()
    #    for oxl_split in oxl_tbl.split(0*mm, 260*mm):
    #        self.DocElm.append(oxl_split)
    #        self.DocElm.append(Spacer(0*mm, 15*mm))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HeaderFooterCanvas)


#= CLASS ===============================
# zapisnik_o
#=======================================
class zapisnik_o(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self,
               pi_PrId,
               pc_PdfFile,
               pc_UserName=None,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10 * mm,
               pn_bottomMargin=10 * mm,
               pn_leftMargin=10 * mm,
               pn_rightMargin=10 * mm):

    SimpleDocTemplate.__init__(self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin)

    data.dget(pi_PrId)
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
        [
            'KONTROLISANJE ISPUNJENOSTI PROPISANIH USLOVA (PPV)', u'', u'', u'',
            u''
        ],
        [
            '1', u'uređaji za upravlj. - sistem za upravljanje',
            u'komanda na levoj strani', u'', u'*'
        ],
        [
            '2', u'uređaji za zaustavljanje vozila - kočni sistem', u'radna',
            u'', u'*'
        ],
        ['', u'', u'pomoćna', u'', u'*'],
        ['', u'', u'parkirna', u'', u'*'],
        ['', u'', u'ABS (ako ima)', u'', u'*'],
        [
            '3', u'uređaji za spajanje vučnog i priključnog vozila', u'', u'',
            u'*'
        ],
        [
            '4', u'uređaji za oslanjanje', u'bez kontakta točkova i karoserije',
            u'', u''
        ],
        [
            '5', u'uređaji za kretanje', u'pneumatici jednaki po osovinama',
            u'', u''
        ],
        ['6', u'elektro uređaji i instalacija', u'', u'', u''],
        [
            '7', u'delovi vozila od posebnog značaja za bezbednost saobraćaja',
            u'opšta konstrukcija', u'', u'*'
        ],
        ['', u'', u'VIN', u'', u''],
        ['', u'', u'istureni delovi, ukrasi bez oštrih ivica', u'', u''],
        ['', u'', u'reklamne table u gabaritima', u'', u''],
        ['', u'', u'prostor za tablicu', u'', u''],
        ['', u'', u'blatobrani iznad svih točkova u širini točka', u'', u''],
        ['', u'', u'ZZOP', u'', u''],
        ['', u'', u'BZOP', u'', u'*'],
        ['16', u'Uređaj i opr. za pogon na alternativ. goriva', u'', u'', u'*'],
        [
            '', u'x = uređaj/sistem postoji na vozilu,',
            u'- = uređaj/sistem ne postoji na vozilu', u'', u''
        ],
        [
            '', u'&nbsp;' * 15 + u'N/P = nije primenljivo,',
            u'&nbsp;' * 15 + u'* = obavezna homologacija', u'', u''
        ],
    ]
    lll_dataf = []
    for vil_row, lcl_row in enumerate(lll_data):
      lll_dataf.append([
          Paragraph(lcl_row[0], (pss.psbc if vil_row == 0 else pss.psnr)),
          Paragraph(lcl_row[1], pss.psnl),
          Paragraph(lcl_row[2], pss.psnl),
          Paragraph(lcl_row[3], pss.psnl),
          Paragraph(lcl_row[4], pss.psnl),
      ])
    oxl_table = Table(lll_dataf,
                      colWidths=[9 * mm, 75 * mm, 84 * mm, 15 * mm, 7 * mm],
                      hAlign='LEFT')

    oxl_ts = tss.alng
    oxl_ts.add('ALIGN', (0, 1), (0, -3), 'RIGHT')
    oxl_ts.add('ALIGN', (1, 1), (-1, -1), 'LEFT')
    oxl_ts.add('BOX', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('BOX', (0, -2), (-1, -1), lts.t05, colors.black)
    oxl_ts.add('INNERGRID', (0, 1), (-1, -3), lts.t05, colors.black)
    oxl_ts.add('SPAN', (0, 0), (-1, 0))
    oxl_ts.add('SPAN', (0, 2), (0, 5))
    oxl_ts.add('SPAN', (1, 2), (1, 5))
    oxl_ts.add('SPAN', (0, 10), (0, 17))
    oxl_ts.add('SPAN', (1, 10), (1, 17))
    oxl_table.setStyle(oxl_ts)

    return oxl_table

  #= METHOD ==============================
  # pdfprep
  #=======================================
  def pdfprep(self):

    # 1. strana
    self.DocElm.append(Spacer(0 * mm, 35 * mm))
    self.DocElm.append(tbl_ttl(self.Title))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zbr)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zkl)

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_zvd(u'O'))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_vzdata(u'O'))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_hmlgo(u'O'))

    # 2. strana
    self.DocElm.append(PageBreak())

    self.DocElm.append(Spacer(0 * mm, 15 * mm))
    self.DocElm.append(self.tbl_ppv())
    #    oxl_tbl = self.tbl_ppv()
    #    for oxl_split in oxl_tbl.split(0*mm, 260*mm):
    #        self.DocElm.append(oxl_split)
    #        self.DocElm.append(Spacer(0*mm, 15*mm))

    self.DocElm.append(Spacer(0 * mm, 5 * mm))
    self.DocElm.append(zap.tbl_text)

  #= METHOD ==============================
  # pdfmake
  #=======================================
  def pdfmake(self):

    self.build(self.DocElm, canvasmaker=HeaderFooterCanvas)


#= CLASS ===============================
# neusaglasenost
#=======================================
class neusaglasenost(SimpleDocTemplateNP):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self,
               pi_PrId,
               pc_PdfFile,
               pl_PageSize=A4,
               pb_showBoundary=0,
               pn_topMargin=10 * mm,
               pn_bottomMargin=10 * mm,
               pn_leftMargin=10 * mm,
               pn_rightMargin=10 * mm):

    SimpleDocTemplate.__init__(self,
                               pc_PdfFile,
                               pagesize=portrait(pl_PageSize),
                               showBoundary=pb_showBoundary,
                               topMargin=pn_topMargin,
                               bottomMargin=pn_bottomMargin,
                               leftMargin=pn_leftMargin,
                               rightMargin=pn_rightMargin)

    data.dget(pi_PrId, True)
    self.Title = u'IZVOD IZ BAZE O TEHNIČKIM KARAKTERISTIKAMA VOZILA'
    self.PdfDoc = pc_PdfFile
    self.DocElm = []
    self.pdfprep()
    self.pdfmake()


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
    reps['pdfdir'] = osp.join(sysdf.reps, 'pdf', pc_UserName)
    reps['pdf'] = osp.join(reps.pdfdir, '{}.pdf'.format(pc_Report))

    utl.dircheck(reps.pdfdir)
    utl.filedelete(reps.pdf)

    if pc_Report == u'zapisnik':
      if pd_RepPrms['pc_vzpv_oznaka'] == u'M1':
        reps.pdf = osp.join(reps.pdfdir, '{}_m1.pdf'.format(pc_Report))
        r = zapisnik_m1(pd_RepPrms[u'pi_pr_id'], reps.pdf)
      elif pd_RepPrms['pc_vzpv_oznaka'] in (u'M2', u'M3'):
        reps.pdf = osp.join(reps.pdfdir, '{}_m2m3.pdf'.format(pc_Report))
        r = zapisnik_m2m3(pd_RepPrms[u'pi_pr_id'], reps.pdf)
      elif pd_RepPrms['pc_vzpv_oznaka'][0] == u'L':
        reps.pdf = osp.join(reps.pdfdir, '{}_l.pdf'.format(pc_Report))
        r = zapisnik_l(pd_RepPrms["pi_pr_id"], reps.pdf)
      elif pd_RepPrms['pc_vzpv_oznaka'] == u'N1':
        reps.pdf = osp.join(reps.pdfdir, '{}_n1.pdf'.format(pc_Report))
        r = zapisnik_n1(pd_RepPrms[u'pi_pr_id'], reps.pdf)
      elif pd_RepPrms['pc_vzpv_oznaka'] in (u'N2', u'N3'):
        reps.pdf = osp.join(reps.pdfdir, '{}_n2n3.pdf'.format(pc_Report))
        r = zapisnik_n2n3(pd_RepPrms[u'pi_pr_id'], reps.pdf)
      elif pd_RepPrms['pc_vzpv_oznaka'][0] == u'O':
        reps.pdf = osp.join(reps.pdfdir, '{}_o.pdf'.format(pc_Report))
        r = zapisnik_o(pd_RepPrms[u'pi_pr_id'], reps.pdf)
    elif pc_Report == u'potvrda_b':
      r = potvrda(pd_RepPrms[u'pi_pr_id'], reps.pdf)
    elif pc_Report == u'neusaglasenost':
      pass
      r = neusaglasenost(pd_RepPrms[u'pi_pr_id'], reps.pdf)

    if not osp.exists(reps.pdf):
      reps.pdf = None
      print('{}'.format(vcl_CmdRes))
      print('Izveštaj "{}" ne postoji!'.format(reps.pdf))

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
