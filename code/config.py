#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- Mode: Python; py-indent-offset: 2 -*-
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  imports
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# system
from os import environ, path, urandom
from pathlib import Path

# site-packages
from dotenv import load_dotenv

#---------------------------------------
# global variables
#---------------------------------------

basedir = path.abspath(path.dirname(__file__))
load_dotenv(path.join(basedir, '.env'))

SECRET_KEY = environ.get('FEV_KLJUC') or urandom(32)
JWT_SECRET_KEY = environ.get('FEV_KLJUC_TKN') or urandom(32)
JWT_BLACKLIST_ENABLED = True
JWT_ACCESS_TOKEN_EXPIRES = 2*60*60

environ["FEV_ENV"]="develop"

if environ.get('FEV_ENV')=='develop':
  load_dotenv(path.join(basedir, '.env_develop'))
else:
  load_dotenv(path.join(basedir, '.env_prod'))

DATA_PATH = environ.get('FEV_DATA_PATH')
ASSETS_PATH = environ.get('FEV_ASSETS_PATH')

FRONTEND_IMGS_PATH = environ.get('FEV_FRONTEND_IMGS_PATH')
DB_PASSWORD = environ.get('FEV_DB_PASSWORD')

#IMGS_PATH = f'{DATA_PATH}imgs'
#REPORTS_DATA_PATH = f'{DATA_PATH}reports'
#REPORTS_ASSETS_PATH = f'{ASSETS_PATH}reports'
#DOCS_PATH = f'{DATA_PATH}documents'
#OCR_PATH = f'{DATA_PATH}ocr'

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
