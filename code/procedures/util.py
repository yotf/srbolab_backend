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
import json as js
import os.path as osp
import subprocess as sbp

# site-packages
from box import SBox as dd

#---------------------------------------
# global variables
#---------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= FUNCTION ============================
# py2json
#=======================================
def py2json(px_py):

  """  py to json"""

  return js.dumps(px_py)

#= FUNCTION ============================
# json2py
#=======================================
def json2py(px_json):

  """  json to py"""

  return js.loads(px_json)

#= FUNCTION ============================
#  dircheck
#=======================================
def dircheck(pc_Dir):

  """  Check if dir exists & create it if don`t"""

  if not osp.exists(pc_Dir):
    try:
      os.mkdir(pc_Dir)
    except:
      raise

#= FUNCTION ============================
#  filedelete
#=======================================
def filedelete(pc_File):

  """  Check if file exists & delete it if exists"""

  if osp.exists(pc_File):
    try:
      os.remove(pc_File)
    except:
      raise

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
# cmdrun
#=======================================
def cmdrun(px_Cmd2Exe, pb_Wait=True, pb_Shell=True):

  if pb_Wait:
    try:
      oxl_Cmd = sbp.Popen(px_Cmd2Exe, stdout=sbp.PIPE, stderr=sbp.PIPE, shell=pb_Shell, universal_newlines=True)
    except:
      vcl_CmdOut, vcl_CmdErr = ['', '']
      raise
    else:
      vcl_CmdOut, vcl_CmdErr = oxl_Cmd.communicate()
  else:
    try:
      oxl_Cmd = sbp.Popen(px_Cmd2Exe, stdout=sbp.PIPE, stderr=sbp.PIPE, shell=pb_Shell, universal_newlines=True).pid
    except:
      vcl_CmdOut, vcl_CmdErr = ['', '']
    else:
      vcl_CmdOut, vcl_CmdErr = [oxl_Cmd, '']

  return (vcl_CmdErr if vcl_CmdErr else vcl_CmdOut)

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
