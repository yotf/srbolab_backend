from os import environ, path, urandom

from dotenv import load_dotenv

basedir = path.abspath(path.dirname(__file__))
load_dotenv(path.join(basedir, '.env'))

SECRET_KEY = environ.get('KLJUC') or urandom(32)
JWT_SECRET_KEY = environ.get('KLJUC_TKN') or urandom(32)
