from os import environ, path, urandom

from dotenv import load_dotenv

basedir = path.abspath(path.dirname(__file__))
load_dotenv(path.join(basedir, '.env'))

SECRET_KEY = environ.get('KLJUC') or urandom(32)
JWT_SECRET_KEY = environ.get('KLJUC_TKN') or urandom(32)
JWT_BLACKLIST_ENABLED = True

if environ.get("ENV"):
  DATA_PATH = "/home/p/projects/srbolab/data/"
  FRONTEND_APP_PATH = "/home/p/projects/srbolab/react_app/public/imgs/"
else:
  DATA_PATH = "/srbolab/data/"
  FRONTEND_APP_PATH = "/var/www/srbolab/"
