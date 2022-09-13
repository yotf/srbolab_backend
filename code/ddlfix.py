#!/usr/bin/env python3
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
# system
import re
import sys
import os
import glob as g
import shutil as su
import os.path as osp
import argparse as arg

# site-packages
from box import SBox as dd

sys.path.append(osp.join(osp.dirname(osp.dirname(osp.abspath(__file__))), 'flask_app', 'code'))

# local
from procedures.pgdb import pgdb
from lib.data import data

#---------------------------------------
# global variables
#---------------------------------------
db = pgdb()
rexs = dd(
          {
           100: {'s': r'"', 'r': r''},
           105: {'s': r'(\(OIDS=TRUE,[ ]*)(\n[ ]+)(auto)', 'r': r'\1\3'},
           110: {'s': r'(\()(\n[ ]+)(auto)', 'r': r'\1\3'},
           111: {'s': r'(\))(\n)(WITH)', 'r': r'\1 \3'},
           120: {'s': r'\n;', 'r': r';'},
           130: {'s': r'(\*/)([\n]{2})([\n]{1,})', 'r': r'\1\2'},
           131: {'s': r'(-- Create tbls_scr section [-]+)(\n)(\n)', 'r': r'\1\2'},
           132: {'s': r'(\n)(-- Create foreign keys)', 'r': r'\1\1\2'},
           140: {'s': r'(\n)(\n)(CREATE TABLE)', 'r': r'\1\3'},
           150: {'s': r'(\n)(\n)(ALTER TABLE)', 'r': r'\1\3'},
           160: {'s': r'(\n)(\n)(CREATE INDEX)', 'r': r'\1\3'},
           170: {'s': r'(\n)(\n)(CREATE SCHEMA)', 'r': r'\1\3'},
           180: {'s': r'(\n)(\n)(COMMENT ON SCHEMA)', 'r': r'\1\3'},
           190: {'s': r'(CREATE TABLE .+)(\()(\n)', 'r': r'\1\3\2\3'},
           195: {'s': r'(CREATE OR REPLACE VIEW [a-z0-9_\.]+)([\n\r ]*)(AS)', 'r': r'\1 \3'},
           200: {'s': r'(,)([^ \n\t])', 'r': r'\1 \2'},
           210: {'s': r'(\n)([ ]+)(CHECK)', 'r': r' \3'},
           230: {'s': r'(\n)([ ]+)([^ ]+)', 'r': r'\1  \3'},
           505: {'s': r'OIDS=TRUE', 'r': None},
           510: {'s': r'Integer', 'r': None},
           520: {'s': r'Character', 'r': None},
           530: {'s': r'varying', 'r': None},
           540: {'s': r'Numeric', 'r': None},
           550: {'s': r'Date', 'r': None},
           560: {'s': r'Timestamp', 'r': None},
           565: {'s': r'Text', 'r': None},
          }
         )

dirs = dd({})

dirs['wrk'] = osp.dirname(osp.abspath(__file__))
dirs['sql'] = osp.join(dirs.wrk, 'sql')
dirs['_t'] = {
              'tbl': {
                      'ddl': osp.join(dirs.sql, '_t', 'tbl', 'ddl'),
                      'dml': osp.join(dirs.sql, '_t', 'tbl', 'dml'),
                     },
              'obj': {
                      'fnc': osp.join(dirs.sql, '_t', 'obj', 'fnc'),
                      'typ': osp.join(dirs.sql, '_t', 'obj', 'typ'),
                      'view': osp.join(dirs.sql, '_t', 'obj', 'view'),
                     },
             }

dirs['public'] = {
                  'tbl': {
                          'ddl': osp.join(dirs.sql, 'public', 'tbl', 'ddl'),
                          'dml': osp.join(dirs.sql, 'public', 'tbl', 'dml'),
                         },
                  'obj': {
                          'fnc': osp.join(dirs.sql, 'public', 'obj', 'fnc'),
                          'typ': osp.join(dirs.sql, 'public', 'obj', 'typ'),
                          'view': osp.join(dirs.sql, 'public', 'obj', 'view'),
                         },
                 }

dirs['other'] = {
                 'tbl': {
                         'ddl': osp.join(dirs.sql, 'other', 'tbl', 'ddl'),
                         'dml': osp.join(dirs.sql, 'other', 'tbl', 'dml'),
                        },
                 'obj': {
                         'fnc': osp.join(dirs.sql, 'other', 'obj', 'fnc'),
                         'typ': osp.join(dirs.sql, 'other', 'obj', 'typ'),
                         'view': osp.join(dirs.sql, 'other', 'obj', 'view'),
                        },
                }

dirs['scr'] = osp.join(dirs.wrk, 'scr')
dirs['scrg'] = ('/home/zeljko/Work/Case/TDM/GeneratedScripts' if sys.platform=='linux' else r'E:\Work\Case\TDM\GeneratedScripts')

fls = dd({})
fls['rawg'] = osp.join(dirs.scrg, 'Generated.sql')
fls['raw'] = osp.join(dirs.scr, 'Generated.sql')
fls['fxd'] = osp.join(dirs.scr, 'Fixed.sql')

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= CLASS ===============================
# model
#=======================================
class model:

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self):

    self.ddlflraw = fls.raw
    self.ddlflfxd = fls.fxd
    self.ddlfxd = self.ddlscr()
    self.tbls_db = self.tblsd()
    self.tbls_scr = dd({})
    self.tblss()
    self.tblcmmts()
    self.tblidxs()
    self.tblpks()
    self.tbluks()
    self.tblfks()
    self.tblsord()

  #= METHOD ==============================
  # ddlscr
  #=======================================
  def ddlscr(self):

    """  Get DDL from script"""

    vnl_TimeDDLRawG = (osp.getmtime(fls.rawg) if osp.exists(fls.rawg) else 0)
    vnl_TimeDDLRaw = (osp.getmtime(self.ddlflraw) if osp.exists(self.ddlflraw) else 0)
    vnl_TimeDDLFxd = (osp.getmtime(self.ddlflfxd) if osp.exists(self.ddlflfxd) else 0)
    if vnl_TimeDDLRawG>vnl_TimeDDLRaw:
      su.copy2(fls.rawg, self.ddlflraw)
      vnl_TimeDDLRaw = (osp.getmtime(self.ddlflraw) if osp.exists(self.ddlflraw) else 0)
    if vnl_TimeDDLRaw+vnl_TimeDDLFxd>0:
      if vnl_TimeDDLRaw>vnl_TimeDDLFxd:
        vcl_DDL = self.fixddl()
      else:
        with open(self.ddlflfxd, 'r', encoding='utf-8') as fr:
          vcl_DDL = fr.read().rstrip()+'\n'
    else:
      vcl_DDL = None

    return vcl_DDL

  #= METHOD ==============================
  # fixdddl
  #=======================================
  def fixddl(self):

    """  Fix DDL script"""

    with open(self.ddlflraw, 'r', encoding='utf-8') as fr:
      vcl_DDL = fr.read()

    for vcl_Idx, rex in sorted(rexs.items()):
      if rex.r is not None:
        vcl_DDL = re.sub(rex.s, rex.r, vcl_DDL)
      else:
        vcl_DDL = vcl_DDL.replace(rex.s, rex.s.lower())

    return vcl_DDL.rstrip('\n')+'\n'

  #= METHOD ==============================
  # fixdddlwrt
  #=======================================
  def fixdddlwrt(self):

    """  Write fixed DDL script"""

    with open(self.ddlflfxd, 'w', encoding='utf-8') as fw:
      fw.write(self.ddlfxd)

  #= METHOD ==============================
  # tblsn
  #=======================================
  def tblsn(self, pc_tblsn):

    """  Table schema & name"""

    try:
      vcl_TblS, vcl_TblN = [s.lower() for s in pc_tblsn.split('.')]
    except ValueError:
      print('Table "{}" has NOT asociated schema!'.format(pc_tblsn))
      raise
#    if '.' in pc_tblsn:
#      vcl_TblS, vcl_TblN = [s.lower() for s in pc_tblsn.split('.')]
#    else:
#      vcl_TblS, vcl_TblN = ['', pc_tblsn.lower()]

    return (vcl_TblS, vcl_TblN)

  #= METHOD ==============================
  # tblsnc
  #=======================================
  def tblsnc(self, pc_tblsnc):

    """  Column schema & table & name"""

    if pc_tblsnc.count('.')==1:
      vcl_TblS, vcl_TblN, vcl_ColN = ['']+[s.lower() for s in pc_tblsnc.split('.')]
    elif pc_tblsnc.count('.')==2:
      vcl_TblS, vcl_TblN, vcl_ColN = [s.lower() for s in pc_tblsnc.split('.')]
    else:
      vcl_TblS, vcl_TblN, vcl_ColN = ['', '', '']

    return (vcl_TblS, vcl_TblN, vcl_ColN)

  #= METHOD ==============================
  # tblsd
  #=======================================
  def tblsd(self):

    vcl_SQL = """SELECT n.nspname::character varying AS table_schema,
         c.relname::character varying AS table_name,
         CASE c.relkind WHEN 'r' THEN 't' ELSE 'v' END::character varying AS table_type,
         d.description::character varying AS table_comment
    FROM pg_catalog.pg_class AS c
      LEFT JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace
      LEFT JOIN pg_catalog.pg_description d ON (d.objoid=c.oid AND d.objsubid=0)
    WHERE n.nspname !~* '^(information_schema|pg_[ct]|public|_.*)'
      AND c.relkind IN ('r', 'v')
      AND (%(pc_table)s IS NULL OR (%(pc_table)s ~* '^(t|v)$' AND c.relkind=CASE lower(%(pc_table)s) WHEN 't' THEN 'r' ELSE 'v' END) OR c.relname=%(pc_table)s);"""
    conn = db.connget()
    crsr = conn.cursor()
    dxl_tbls = {}
    try:
      crsr.execute(vcl_SQL, {'pc_table': 't'})
      for vcl_sch, vcl_tbl, vcl_typ, vcl_cmmt in [[c for c in dict(t).values()] for t in crsr.fetchall()]:
        dxl_tbls[vcl_tbl] = {'sch': vcl_sch, 'cmmt': vcl_cmmt, 'typ': vcl_typ,'rc': db.tbl_rec_cnt(vcl_sch, vcl_tbl)}
    except:
      raise
    finally:
      crsr.close()
      db.connret(conn)

    return dxl_tbls

  #= METHOD ==============================
  # tblss
  #=======================================
  def tblss(self):

    """  Tables/columns from fixed DDL script"""

    ltl_TblCols = re.findall(r'(CREATE TABLE[ ]+)([a-z0-9_\.]+)(\n\()(.+?)(\))([ ]+WITH[ ]+\((oids|autovacuum_enabled)=.+?\);)', self.ddlfxd, re.I|re.S)
    if ltl_TblCols:
      for tcl_TblCols in ltl_TblCols:
        tcl_TblCols = tcl_TblCols[:6]
        vcl_TblSch, vcl_TblName = self.tblsn(tcl_TblCols[1])
        lcl_TblCols = [c.strip(' ,') for c in tcl_TblCols[3].splitlines() if c.strip()]
        dxl_TblCols = {}
        for vnl_TblColOrd, vcl_TblCol in enumerate(lcl_TblCols, 1):
          lcl_TblCol = vcl_TblCol.split(u' ')
          vcl_ColName = lcl_TblCol[0].lower()
          vcl_ColType = lcl_TblCol[1].upper()
          vcl_ColTypeG = None
          if len(lcl_TblCol)>2 and lcl_TblCol[2].startswith(u'VARYING'):
            vcl_ColType += u' '+lcl_TblCol[2]
          if vcl_ColType.startswith(u'CHARACTER'):
            vcl_ColTypeG = u'VARCHAR'
          elif vcl_ColType.startswith(u'NUMERIC'):
            vcl_ColTypeG = u'NUMERIC'
          else:
            vcl_ColTypeG = vcl_ColType
          dxl_TblCols[vcl_ColName] = dd(
                                        {
                                         'ord': vnl_TblColOrd,
                                         'type': vcl_ColType,
                                         'typeg': vcl_ColTypeG,
                                         'ddl': vcl_TblCol
                                        }
                                       )
        self.tbls_scr[vcl_TblName] = {
                                      'sch': vcl_TblSch,
                                      'cols': dxl_TblCols,
                                      'ord': 0,
                                      'cmmt': None,
                                      'pk': None,
                                      'tbc': [],
                                      'tbp': [],
                                      'ddl': {
                                              '1_ct': [u''.join(tcl_TblCols)],
                                              '2_cmmts': [],
                                              '3_idxs': [],
                                              '4_pk': [],
                                              '5_uks': [],
                                              '6_fks': [],
                                             }
                                     }

  #= METHOD ==============================
  # tblcmmts
  #=======================================
  def tblcmmts(self):

    """  Table/column comments from fixed DDL script"""

    ltl_TblCmmts = re.findall(r"(COMMENT ON TABLE[ ]+)([a-z0-9_\.]+)([ ]+IS[ ]+')(.+)(';)", self.ddlfxd, re.I)
    if ltl_TblCmmts:
      for tcl_TblCmmt in ltl_TblCmmts:
        vcl_TblSch, vcl_TblName = self.tblsn(tcl_TblCmmt[1])
        self.tbls_scr[vcl_TblName]['cmmt'] = tcl_TblCmmt[3]
        self.tbls_scr[vcl_TblName]['ddl']['2_cmmts'].append(u''.join(tcl_TblCmmt))


    ltl_ColCmmts = re.findall(r"(COMMENT ON COLUMN[ ]+)([a-z0-9_\.]+)([ ]+IS[ ]+')(.+)(';)", self.ddlfxd, re.I)
    if ltl_ColCmmts:
      for tcl_ColCmmt in ltl_ColCmmts:
        vcl_TblSch, vcl_TblName, vcl_ColName = self.tblsnc(tcl_ColCmmt[1])
        self.tbls_scr[vcl_TblName]['cols'][vcl_ColName]['cmmt'] = tcl_ColCmmt[3]
        self.tbls_scr[vcl_TblName]['ddl']['2_cmmts'].append(u''.join(tcl_ColCmmt))

  #= METHOD ==============================
  # tblidxs
  #=======================================
  def tblidxs(self):

    """  Table indexes from fixed DDL script"""

    ltl_TblIdxs = re.findall(r'(CREATE[ ]+)(UNIQUE|)([ ]*INDEX[ ]+)([a-z0-9_]+)([ ]+ON[ ]+)([a-z0-9_\.]+)([ ]+)(\()(.+)(\);)', self.ddlfxd, re.I)
    if ltl_TblIdxs:
      for tcl_TblIdx in ltl_TblIdxs:
        vcl_TblSch, vcl_TblName = self.tblsn(tcl_TblIdx[5])
        self.tbls_scr[vcl_TblName]['ddl']['3_idxs'].append(u''.join(tcl_TblIdx))

  #= METHOD ==============================
  # tblpks
  #=======================================
  def tblpks(self):

    """  Table primary key from fixed DDL script"""

    ltl_TblPKs = re.findall(r'(ALTER TABLE[ ]+)([a-z0-9_\.]+)([ ]+ADD CONSTRAINT[ ]+)([a-z0-9_]+)([ ]+PRIMARY KEY[ ]+\()([a-z0-9_, ]+)(\);)', self.ddlfxd, re.I)
    if ltl_TblPKs:
      for tcl_TblPK in ltl_TblPKs:
        vcl_TblSch, vcl_TblName = self.tblsn(tcl_TblPK[1])
        self.tbls_scr[vcl_TblName]['pk'] = tcl_TblPK[5]
        self.tbls_scr[vcl_TblName]['ddl']['4_pk'].append(u''.join(tcl_TblPK))

  #= METHOD ==============================
  # tbluks
  #=======================================
  def tbluks(self):

    """  Table unique keys from fixed DDL script"""

    ltl_TblAKs = re.findall(r'(ALTER TABLE[ ]+)([a-z0-9_\.]+)([ ]+ADD CONSTRAINT[ ]+)([a-z0-9_]+)([ ]+UNIQUE[ ]+\()([a-z0-9_, ]+)(\);)', self.ddlfxd, re.I)
    if ltl_TblAKs:
      for tcl_TblAK in ltl_TblAKs:
        vcl_TblSch, vcl_TblName = self.tblsn(tcl_TblAK[1])
        self.tbls_scr[vcl_TblName]['ddl']['5_uks'].append(u''.join(tcl_TblAK))

  #= METHOD ==============================
  # tblfks
  #=======================================
  def tblfks(self):

    """  Table foreign keys from fixed DDL script"""

    ltl_TblFKs = re.findall(r'(ALTER TABLE[ ]+)([a-z0-9_\.]+)([ ]+ADD CONSTRAINT[ ]+)([a-z0-9_]+)([ ]+FOREIGN KEY[ ]+)(\()([a-z0-9_, ]+)(\))([ ]+REFERENCES[ ]+)([a-z0-9_\.]+)([ ]+)(\()([a-z0-9_, ]+)(\))([ ]+ON DELETE[ ]+.+;)', self.ddlfxd, re.I)
    if ltl_TblFKs:
      for tcl_TblFK in ltl_TblFKs:
        vcl_TblC = self.tblsn(tcl_TblFK[1])[1]
        vcl_TblP = self.tblsn(tcl_TblFK[9])[1]
        if vcl_TblC!=vcl_TblP:
          self.tbls_scr[vcl_TblC]['tbp'].append(vcl_TblP)
          self.tbls_scr[vcl_TblP]['tbc'].append(vcl_TblC)
        self.tbls_scr[vcl_TblC]['ddl']['6_fks'].append(u''.join(tcl_TblFK))

      for vcl_Tbl in self.tbls_scr.keys():
        if self.tbls_scr[vcl_Tbl].tbp:
          self.tbls_scr[vcl_Tbl].tbp = [t for t in sorted(self.tbls_scr[vcl_Tbl].tbp)]
        if self.tbls_scr[vcl_Tbl].tbc:
          self.tbls_scr[vcl_Tbl].tbc = [t for t in sorted(self.tbls_scr[vcl_Tbl].tbc)]

  #= METHOD ==============================
  # tblsord
  #=======================================
  def tblsord(self):

    """  Tables ordered for creation/deletion"""

    #= FUNCTION ============================
    # tblsord_d
    #=======================================
    def tblsord_d():

      #= FUNCTION ============================
      # tblshie
      #=======================================
      def tblshie(pc_Table, pn_Lvl=0, pl_Pth=[]):

        if pc_Table not in pl_Pth:
          self.tbls_scr[pc_Table].ord = max(self.tbls_scr[pc_Table].ord, pn_Lvl)
          for vcl_TableP in self.tbls_scr[pc_Table].tbc:
            if vcl_TableP in self.tbls_scr:
              if vcl_TableP not in pl_Pth:
                tblshie(vcl_TableP, pn_Lvl+1, pl_Pth+[pc_Table])

        return pn_Lvl

      for vcl_Table, dxl_Table in self.tbls_scr.items():
        if dxl_Table.tbc:
          tblshie(vcl_Table)
        else:
          if not dxl_Table.tbp:
            self.tbls_scr[vcl_Table].ord = 0

    tblsord_d()

  #= METHOD ==============================
  # tblnms
  #=======================================
  def tblnms(self, pc_opt=None):

    """  Tables names sorted by name/order for creation/order for deletion"""

    if not isinstance(pc_opt, str) or pc_opt not in 'ncd':
      pc_opt = 'c'
    if pc_opt=='n': # sorted by name
      vcl_tbls = [t for t in sorted(self.tbls_scr.keys())]
    elif pc_opt=='c': # sorted by level for creation
      vcl_tbls = [t[0] for t in sorted(self.tbls_scr.items(), key=lambda tnd: (tnd[1].ord, tnd[1].sch, tnd[0]))]
    elif pc_opt=='d': # sorted by level for deletion
      vcl_tbls = [t[0] for t in sorted(self.tbls_scr.items(), key=lambda tnd: (tnd[1].ord, tnd[1].sch, tnd[0]), reversed=True)]

    return vcl_tbls

  #= METHOD ==============================
  # tblddl
  #=======================================
  def tblddl(self, pc_Table, pb_Drop=True):

    """  Generate table DDL (CREATE TABLE ...)"""

    if pc_Table and pc_Table in self.tbls_scr:
      vcl_Tbl = pc_Table
      dxl_Tbl = self.tbls_scr[vcl_Tbl]
      vcl_Sch = dxl_Tbl.sch
      vcl_TblDDL = u'/* Table {}.{} */'.format(vcl_Sch, vcl_Tbl)
      if pb_Drop:
        vcl_TblDDL += u'\nDROP TABLE IF EXISTS {}.{} CASCADE;'.format(vcl_Sch, vcl_Tbl)
      for vcl_DDLn, lcl_DDL in sorted(dxl_Tbl.ddl.items()):
        if lcl_DDL:
          if vcl_DDLn=='1_ct':
            vcl_TblDDL += u'\n-- Table {}.{}'.format(vcl_Sch, vcl_Tbl)
          elif vcl_DDLn=='2_cmmts':
            vcl_TblDDL += u'\n\n-- Comments on table {}.{}'.format(vcl_Sch, vcl_Tbl)
          elif vcl_DDLn=='3_idxs':
            vcl_TblDDL += u'\n\n-- Indexes on table {}.{}'.format(vcl_Sch, vcl_Tbl)
          elif vcl_DDLn=='4_pk':
            vcl_TblDDL += u'\n\n-- Primary key on table {}.{}'.format(vcl_Sch, vcl_Tbl)
          elif vcl_DDLn=='5_uks':
            vcl_TblDDL += u'\n\n-- Alternate keys on table {}.{}'.format(vcl_Sch, vcl_Tbl)
          elif vcl_DDLn=='6_fks':
            vcl_TblDDL += u'\n\n-- Foreign keys on table {}.{}'.format(vcl_Sch, vcl_Tbl)
          else:
            pass
          vcl_TblDDL += u'\n'+u'\n'.join(lcl_DDL)

    return vcl_TblDDL+u'\n\n'

  #= METHOD ==============================
  # tbliidta
  #=======================================
  def tbliidta(self, pc_Table, pb_Trunc=True):

    """  Generate table DML (INSERT INTO ...)"""

    if pc_Table and pc_Table in self.tbls_scr and pc_Table in data:
      vcl_Tbl = pc_Table
      dxl_Tbl = self.tbls_scr[vcl_Tbl]
      vcl_Sch = dxl_Tbl.sch
      vcl_IIDta = None
      vcl_TblCols = u', '.join([t[0] for t in sorted(dxl_Tbl.cols.items(), key=lambda cnd: cnd[1].ord)])
      if data[vcl_Tbl][0]!='(':
        vcl_II = """/* Table {0}.{1} */{3}
INSERT INTO {0}.{1} ({2})
{{}}
"""
        vcl_IIDta = vcl_II.format(vcl_Sch, vcl_Tbl, vcl_TblCols, (u'\nTRUNCATE TABLE {}.{} CASCADE;\nCOMMIT;'.format(vcl_Sch, vcl_Tbl) if pb_Trunc else u''))
      else:
        vcl_II = """/* Table {0}.{1} */{5}
INSERT INTO {0}.{1} ({2})
SELECT t.{3}
  FROM (
        VALUES {{}}
       ) t ({2})
  ORDER BY {4};
"""
        vcl_TblPK = u't.{}'.format(dxl_Tbl.pk.replace(u', ', u', t.'))
        lcl_TblCols = [u'{}::{}'.format(t[0], t[1].typeg) for t in sorted(dxl_Tbl.cols.items(), key=lambda cnd: cnd[1].ord)]
        vcl_IIDta = vcl_II.format(vcl_Sch, vcl_Tbl, vcl_TblCols, ',\n       t.'.join(lcl_TblCols), vcl_TblPK, (u'\nTRUNCATE TABLE {}.{} CASCADE;\nCOMMIT;'.format(vcl_Sch, vcl_Tbl) if pb_Trunc else u''))

      if data[vcl_Tbl][0]!='(':
        vcl_IIDta = vcl_IIDta.format(data[vcl_Tbl])
      else:
        vcl_IIDta = vcl_IIDta.format(u'\n               '.join(data[vcl_Tbl].rstrip('\n\r\t, ').splitlines()))

    return vcl_IIDta+u'\n'

mdl = model()

#= FUNCTION ============================
# wfx
#=======================================
def wfx():

  """  Write fixed generated script"""

  mdl.fixdddlwrt()

#= FUNCTION ============================
# tbls4ods
#=======================================
def tbls4ods():

  """  Print TABLE info for write to tables.ods"""

  for vnl_Idx, (vcl_Tbl, dxl_Tbl) in enumerate(sorted(mdl.tbls_scr.items(), key=lambda tnd: (tnd[1].ord, tnd[1].sch, tnd[0])), 1):
    vcl_TblPT = u', '.join(dxl_Tbl.tbp)
    vcl_TblCT = u', '.join(dxl_Tbl.tbc)
    vcl_TblCols = u', '.join([t[0] for t in sorted(dxl_Tbl.cols.items(), key=lambda cnd: cnd[1].ord)])
    vcl_TblInDb = ('+' if vcl_Tbl in mdl.tbls_db else '')
    vcl_TblHasData = ('+' if mdl.tbls_db.get(vcl_Tbl, {}).get('rc', 0) else '')
    print(u'{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(vnl_Idx, dxl_Tbl.ord, dxl_Tbl.sch, vcl_Tbl, dxl_Tbl.cmmt, vcl_TblPT, vcl_TblCT, vcl_TblCols, dxl_Tbl.pk, vcl_TblInDb, vcl_TblHasData))

#= FUNCTION ============================
# tblsddl
#=======================================
def tblsddl(px_Tbls=None):

  """  Generate all TABLE DDL scripts (<schema>.<table>.ddl),
  script for droping all TABLE-s in right order (tbls_drop.sql)
  script for creating all TABLE-s in right order (tbls_create.scr)"""

  if px_Tbls:
    if isinstance(px_Tbls, (list, tuple)):
      lcl_Tbls = px_Tbls
    else:
      lcl_Tbls = [px_Tbls]
  else:
      lcl_Tbls = mdl.tblnms()

  tcl_SchsPO = ('public', 'other')
  objsd = objectsd('tbl')
  scrs = dd({})
  for vcl_SchPO in ('public', 'other'):
    scrs[vcl_SchPO] = {
                       's2e': [],
                       't2d': [],
                       'scrtc': osp.join(dirs[vcl_SchPO].tbl.ddl, 'tbls_create.scr'),
                       'scrtd': osp.join(dirs[vcl_SchPO].tbl.ddl, 'tbls_drop.sql'),
                      }
  for vcl_Tbl in lcl_Tbls:
    vbl_Ok2W = True
    vcl_Sch = mdl.tbls_scr[vcl_Tbl].sch
    vcl_SchPO = (vcl_Sch if vcl_Sch=='public' else 'other')
    vcl_DDL = '{}\n\nCOMMIT;\n'.format(mdl.tblddl(vcl_Tbl).rstrip())
    vcl_DDLF = osp.join(dirs[vcl_SchPO].tbl.ddl, '{}.{}.ddl'.format(vcl_Sch, vcl_Tbl))
    if osp.exists(vcl_DDLF):
      with open(vcl_DDLF, 'r') as fr:
        vcl_DDLo = fr.read()
      if vcl_DDL==vcl_DDLo:
        vbl_Ok2W = False
    scrs[vcl_SchPO].s2e.append(r'\i {}'.format(vcl_DDLF.replace(dirs.sql, '.')))
    scrs[vcl_SchPO].t2d.append('DROP TABLE IF EXISTS {}.{} CASCADE;'.format(vcl_Sch, vcl_Tbl))
    if scrs[vcl_SchPO].t2d[-1] in objsd[vcl_SchPO]:
      objsd[vcl_SchPO].remove(scrs[vcl_SchPO].t2d[-1])
    if vbl_Ok2W:
      with open(vcl_DDLF, 'w') as fw:
        fw.write(vcl_DDL)
  for vcl_SchPO in ('public', 'other'):
    if objsd[vcl_SchPO]:
      scrs[vcl_SchPO].t2d.extend(objsd[vcl_SchPO])
    if scrs[vcl_SchPO].s2e:
      with open(scrs[vcl_SchPO].scrtc, 'w') as fw:
        fw.write('\n'.join(scrs[vcl_SchPO].s2e)+'\n')
    if scrs[vcl_SchPO].t2d:
      with open(scrs[vcl_SchPO].scrtd, 'w') as fw:
        fw.write('\n'.join(reversed(scrs[vcl_SchPO].t2d))+'\n')
        fw.write('COMMIT;\n')

#= FUNCTION ============================
# tblsdml
#=======================================
def tblsdml(px_Tbls=None):

  """  Generate all TABLE DML scripts (<schema>.<table>.dml),
  script for truncating all TABLE-s in right order (tbls_trunc.sql)
  script for populating all TABLE-s in right order (tbls_ins.scr)"""

  if px_Tbls:
    if isinstance(px_Tbls, (list, tuple)):
      lcl_Tbls = px_Tbls
    else:
      lcl_Tbls = [px_Tbls]
  else:
      lcl_Tbls = mdl.tblnms()

  tcl_SchsPO = ('public', 'other')
  scrs = dd({})
  for vcl_SchPO in tcl_SchsPO:
    scrs[vcl_SchPO] = {
                       's2e': [],
                       't2t': [],
                       'scrti': osp.join(dirs[vcl_SchPO].tbl.dml, 'tbls_ins.scr'),
                       'scrtt': osp.join(dirs[vcl_SchPO].tbl.dml, 'tbls_trunc.sql'),
                      }
  for vcl_Tbl in lcl_Tbls:
    if vcl_Tbl in data:
      vbl_Ok2W = True
      vcl_Sch = mdl.tbls_scr[vcl_Tbl].sch
      vcl_SchPO = (vcl_Sch if vcl_Sch=='public' else 'other')
      vcl_DML = '{}\nCOMMIT;\n'.format(mdl.tbliidta(vcl_Tbl).rstrip())
      vcl_DDLF = osp.join(dirs[vcl_SchPO].tbl.dml, '{}.{}.dml'.format(vcl_Sch, vcl_Tbl))
      if osp.exists(vcl_DDLF):
        with open(vcl_DDLF, 'r') as fr:
          vcl_DDLo = fr.read()
        if vcl_DML==vcl_DDLo:
          vbl_Ok2W = False
      scrs[vcl_SchPO].s2e.append(r'\i {}'.format(vcl_DDLF.replace(dirs.sql, '.')))
      scrs[vcl_SchPO].t2t.append('TRUNCATE TABLE {}.{} CASCADE;'.format(vcl_Sch, vcl_Tbl))
      if vbl_Ok2W:
        with open(vcl_DDLF, 'w') as fw:
          fw.write(vcl_DML)
  for vcl_SchPO in tcl_SchsPO:
    if scrs[vcl_SchPO].s2e:
      with open(scrs[vcl_SchPO].scrti, 'w') as fw:
        fw.write('\n'.join(scrs[vcl_SchPO].s2e)+'\n')
    if scrs[vcl_SchPO].t2t:
      with open(scrs[vcl_SchPO].scrtt, 'w') as fw:
        fw.write('\n'.join(reversed(scrs[vcl_SchPO].t2t))+'\n')
        fw.write('COMMIT;\n')

#= FUNCTION ============================
# objectsd
#=======================================
def objectsd(pc_Obj):

  """  Generate script for droping db objects"""

  if pc_Obj=='typ':
    vcl_SQL = """SELECT n.nspname AS type_schema,
       t.typname AS type_name
  FROM pg_type t
    LEFT JOIN pg_catalog.pg_namespace n ON (n.oid=t.typnamespace)
    LEFT JOIN pg_catalog.pg_class c ON (c.oid=t.typrelid)
  WHERE (t.typrelid=0 OR coalesce(c.relkind, '*')='c')
    AND NOT EXISTS
          (
           SELECT 1
             FROM pg_catalog.pg_type el
             WHERE el.oid=t.typelem
               AND el.typarray=t.oid
          )
    AND n.nspname !~ '^(information_schema|pg_[ct]|_.*)'
  ORDER BY CASE n.nspname WHEN 'public' THEN '0' ELSE '1' END||n.nspname, t.typname;"""
  elif pc_Obj=='fnc':
    vcl_SQL = """SELECT n.nspname::character varying AS function_schema,
       p.proname::character varying AS function_name,
       array_to_string(p.proargnames, ', ', null)::character varying AS param_names,
       (
        SELECT max(t2.types) AS types
          FROM (
                SELECT string_agg(CASE substr(t1.typname, 1, 1)
                                    WHEN '_' THEN substr(t1.typname, 2)||'[]'
                                    ELSE t1.typname
                                  END, ', ') OVER (ORDER BY t0.p_no) AS types
                  FROM (
                        SELECT row_number() OVER () AS p_no,
                               oid
                          FROM unnest(string_to_array(p.proargtypes::text, ' ', null)::integer[]) AS oid
                       ) t0
                    JOIN pg_catalog.pg_type t1 ON (t1.oid=t0.oid)
               ) t2
       )::character varying AS param_types,
       (
        SELECT CASE substr(t0.typname, 1, 1)
                 WHEN '_' THEN substr(t0.typname, 2)||'[]'
                 ELSE t0.typname
               END AS r_type
          FROM pg_catalog.pg_type t0
          WHERE t0.oid=p.prorettype
       )::character varying AS return_type,
       CASE (
             SELECT t0.typname
               FROM pg_catalog.pg_type t0
               WHERE t0.oid=p.prorettype
            )
         WHEN 'trigger' THEN 'y'
         ELSE 'n'
       END::character varying AS is_trigger
  FROM pg_catalog.pg_namespace n
    JOIN pg_catalog.pg_proc p ON (p.pronamespace=n.oid)
  WHERE n.nspname !~ '^(information_schema|pg_[ct])'
  ORDER BY CASE n.nspname WHEN 'public' THEN '0' ELSE '1' END||n.nspname, p.proname;"""
  elif pc_Obj in ('tbl', 'view'):
    vcl_SQL = """SELECT n.nspname::character varying AS table_schema,
       c.relname::character varying AS table_name,
       CASE c.relkind WHEN 'r' THEN 't' ELSE 'v' END::character varying AS table_type,
       d.description::character varying AS table_comment
  FROM pg_catalog.pg_class AS c
    LEFT JOIN pg_catalog.pg_namespace n ON n.oid=c.relnamespace
    LEFT JOIN pg_catalog.pg_description d ON (d.objoid=c.oid AND d.objsubid=0)
  WHERE n.nspname !~* '^(information_schema|pg_[ct])'
    AND c.relkind IN ('r', 'v')
    AND %(pc_type)s ~* '^(t|v)$'
    AND c.relkind=CASE lower(%(pc_type)s) WHEN 't' THEN 'r' ELSE 'v' END
  ORDER BY CASE n.nspname WHEN 'public' THEN '0' ELSE '1' END||n.nspname, c.relname;"""

  conn = db.connget()
  crsr = conn.cursor()
  objs = dd(
            {
             '_t': [],
             'public': [],
             'other': [],
            }
           )
  try:
    if pc_Obj in ('tbl', 'view'):
      vcl_type = pc_Obj[0]
      crsr.execute(vcl_SQL, {'pc_type': vcl_type})
    else:
      crsr.execute(vcl_SQL)
    for r in crsr:
      if pc_Obj=='typ':
        vcl_Schema = r['type_schema']
        vcl_DDL = 'DROP TYPE IF EXISTS {}.{} CASCADE;'.format(r['type_schema'], r['type_name'])
      elif pc_Obj=='fnc':
        vcl_Schema = r['function_schema']
        vcl_DDL = 'DROP FUNCTION IF EXISTS {}.{}({}) CASCADE;'.format(r['function_schema'], r['function_name'], r['param_types'])
      elif pc_Obj in ('tbl', 'view'):
        vcl_Schema = r['table_schema']
        if vcl_type=='v':
          vcl_DDL = 'DROP VIEW IF EXISTS {}.{} CASCADE;'.format(r['table_schema'], r['table_name'])
        elif vcl_type=='t':
          vcl_DDL = 'DROP TABLE IF EXISTS {}.{} CASCADE;'.format(r['table_schema'], r['table_name'])
      if vcl_Schema=='_t':
        objs._t.append(vcl_DDL)
      elif vcl_Schema=='public':
        objs.public.append(vcl_DDL)
      else:
        objs.other.append(vcl_DDL)
  except:
    raise
  finally:
    crsr.close()
    db.connret(conn)

  return objs

#= FUNCTION ============================
# objects
#=======================================
def objects(pc_Obj):

  """  Generate script for creating db objects"""

  tcl_SchsPO = ('_t', 'public', 'other')
  scrs = dd({})
  objsd = objectsd(pc_Obj)
  for vcl_SchPO in tcl_SchsPO:
    scrs[vcl_SchPO] = {
                       's2e': [],
                       'scroc': osp.join(dirs[vcl_SchPO].obj[pc_Obj], '{}s_create.scr'.format(pc_Obj)),
                       'o2d': objsd[vcl_SchPO],
                       'scrod': osp.join(dirs[vcl_SchPO].obj[pc_Obj], '{}s_drop.sql'.format(pc_Obj)),
                      }
  for vcl_SchPO in tcl_SchsPO:
    lcl_ObjFls = g.glob(osp.join(dirs[vcl_SchPO].obj[pc_Obj], '*.{}_*.sql'.format(pc_Obj[0])))
    for vcl_ObjF in sorted(lcl_ObjFls, key=lambda pc_fl: pc_fl.replace('.v_predmet.sql', '.v_vpredmet.sql')):
      scrs[vcl_SchPO].s2e.append(r'\i {}'.format(vcl_ObjF.replace(dirs.sql, '.')))

    if scrs[vcl_SchPO].s2e:
      with open(scrs[vcl_SchPO].scroc, 'w') as fw:
        fw.write('\n'.join(scrs[vcl_SchPO].s2e)+'\n')
        fw.write('COMMIT;\n')

    if scrs[vcl_SchPO].o2d:
      with open(scrs[vcl_SchPO].scrod, 'w') as fw:
        fw.write('\n'.join(scrs[vcl_SchPO].o2d)+'\n')
        fw.write('COMMIT;\n')

#= FUNCTION ============================
# typs
#=======================================
def typs():

  """  Generate script for creating all TYPE-s (typs_create.scr)"""

  objects('typ')

#= FUNCTION ============================
# fncs
#=======================================
def fncs():

  """  Generate script for creating all FUNCTION-s (fncs_create.scr)"""

  objects('fnc')

#= FUNCTION ============================
# views
#=======================================
def views():

  """  Generate script for creating all VIEW-s (views_create.scr)"""

  objects('view')

#= FUNCTION ============================
# genall
#=======================================
def genall(pc_Opt='*'):

  vcl_Opt = pc_Opt.lower()[:2]
  if vcl_Opt in ('a', 's'):
    print('  {}'.format('Writing fixed script ...'), end=' ')
    wfx()
    print('{}'.format('Done.'))

  if vcl_Opt in ('a', 'tc'):
    print('  {}'.format('Generatinig table DDL-s ...'), end=' ')
    tblsddl()
    print('{}'.format('Done.'))

  if vcl_Opt in ('a', 'ti'):
    print('  {}'.format('Generatinig table DML-s ...'), end=' ')
    tblsdml()
    print('{}'.format('Done.'))

  for vcl_O1, vcl_O2 in (('VIEW', 'view'), ('TYPE', 'typ'), ('FUNCTION', 'fnc')):
    if vcl_Opt=='a' or vcl_Opt==vcl_O2[0]:
      print('  Generatinig CREATE {}-s script ...'.format(vcl_O1), end=' ')
      objects(vcl_O2)
      print('{}'.format('Done.'))

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

  ap = arg.ArgumentParser()
  ap.add_argument('opt', default='a', nargs='*', choices=['a', 's', 'tc', 'ti', 'v', 't', 'f'])
  args = ap.parse_args()
  for vcg_Opt in args.opt:
    genall(vcg_Opt.lower()[:2])
