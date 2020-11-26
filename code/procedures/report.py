#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
import os
import os.path as osp
import subprocess as sbp

# site-packages
from box import SBox as dd

# local
from .config import getpgdb, sysdf

#---------------------------------------
# global variables
#---------------------------------------


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  classes & functions
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#= CLASS ===============================
# report
#=======================================
class report:

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self):

    self.conn = getpgdb()
    self.cmd_pfx = [sysdf.java, '-jar', sysdf.jasperstarter, 'pr']
    self.cmd_sfx = [
        '-r', '-f', 'pdf', '-t', 'generic', '-H', self.conn.host, '--db-port',
        self.conn.port, '-n', self.conn.database, '-u', self.conn.user, '-p',
        self.conn.password, '--db-driver', 'org.postgresql.Driver', '--db-url',
        'jdbc:postgresql://{}:{}/{}'.format(self.conn.host, self.conn.port,
                                            self.conn.database)
    ]

  #= METHOD ==============================
  # run
  #=======================================
  def run(self, pc_UserName, pc_JRFile, pd_RepPrms={}):
    """  Generate PDF report file"""

    reps = dd({})
    reps['pdfdir'] = osp.join(sysdf.reps, 'pdf', pc_UserName)
    reps['jasper'] = osp.join(sysdf.reps, '{}.jasper'.format(pc_JRFile))
    reps['pdf'] = osp.join(reps.pdfdir, '{}.pdf'.format(pc_JRFile))

    if not osp.exists(reps.pdfdir):
      os.mkdir(reps.pdfdir)

    if osp.exists(reps.jasper):
      if osp.exists(reps.pdf):
        os.remove(reps.pdf)
      cmd = self.cmd_pfx + [reps.jasper, '-o', reps.pdfdir] + self.cmd_sfx

      if pd_RepPrms:
        cmd.append('-P')
        for vcl_Prm, vxl_Value in pd_RepPrms.items():
          if isinstance(vxl_Value, str):
            cmd.append('{}="{}"'.format(vcl_Prm, vxl_Value))
          else:
            cmd.append('{}={}'.format(vcl_Prm, vxl_Value))
      try:
        oxl_Cmd = sbp.Popen(' '.join(cmd),
                            stdout=sbp.PIPE,
                            stderr=sbp.PIPE,
                            shell=True,
                            universal_newlines=True)
      except:
        raise
      else:
        vcl_CmdOut, vcl_CmdErr = oxl_Cmd.communicate()
        if not osp.exists(reps.pdf):
          reps.pdf = None
          print('{}\n{}'.format(vcl_CmdOut, vcl_CmdErr))
          print('Izveštaj "{}" ne postoji!'.format(reps.pdf))
    else:
      reps.pdf = None
      print('Izveštaj "{}" ne postoji!'.format(osp.basename(reps.jasper)))

    return reps.pdf


report_service = report()
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
