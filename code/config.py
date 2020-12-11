from os import environ, path, urandom

from dotenv import load_dotenv

basedir = path.abspath(path.dirname(__file__))
load_dotenv(path.join(basedir, '.env'))

SECRET_KEY = environ.get('FEV_KLJUC') or urandom(32)
JWT_SECRET_KEY = environ.get('FEV_KLJUC_TKN') or urandom(32)
JWT_BLACKLIST_ENABLED = True
JWT_REFRESH_TOKEN_EXPIRES = 2 * 60 * 60

if environ.get("FEV_ENV") == "develop":
  load_dotenv(path.join(basedir, ".env_develop"))
else:
  load_dotenv(path.join(basedir, ".env_prod"))

DATA_PATH = environ.get("FEV_DATA_PATH")
FRONTEND_IMGS_PATH = environ.get("FEV_FRONTEND_IMGS_PATH")
JAVA_PATH = environ.get("FEV_JAVA")
JASPER_PATH = environ.get("FEV_JASPER")
IMGS_PATH = f"{DATA_PATH}imgs"
REPORTS_PATH = f"{DATA_PATH}reports"
DOCS_PATH = f"{DATA_PATH}documents"
OCR_PATH = f"{DATA_PATH}ocr"
DB_PASSWORD = environ.get("FEV_DB_PASSWORD")
