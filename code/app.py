import json
import os

from flask import Flask
from flask_cors import CORS
from flask_restful import Api

from jwt_init import jwt
from procedures.application import application
from procedures.table_wrapper import db
from resources.base_resource import (generate_copy, generate_description,
                                     generate_resource)
from resources.forms import Forms
from resources.login import Login, Logout, Refresh, whitelist
from resources.predmeti import Predmeti
from resources.reports import Reports
from resources.tables import Tables
from resources.upload import Images, Upload

# from resources.user import UserLogin, UserRegister, Users

app = Flask(__name__)
# app.config['JWT_ACCESS_TOKEN_EXPIRES'] = 15 //in seconds
api = Api(app, "/api")
cors = CORS(app, supports_credentials=True)

jwt.init_app(app)
app.config.from_pyfile('config.py')

api.add_resource(Forms, "/forms")
api.add_resource(Login, "/login")
api.add_resource(Logout, "/logout")
api.add_resource(Predmeti, "/predmeti")
api.add_resource(Refresh, "/refresh")
api.add_resource(Reports, "/report")
api.add_resource(Tables, "/tables")
api.add_resource(Upload, "/upload")
api.add_resource(Images, "/images")
for table in db.tbls():
  try:
    url = f"/{table['table_name']}"
    api.add_resource(generate_resource(table["table_name"]),
                     url,
                     resource_class_kwargs={ 'table': table["table_name"] })

    api.add_resource(generate_description(table["table_name"]),
                     f"{url}/description",
                     resource_class_kwargs={ 'table': table["table_name"] })

    api.add_resource(generate_copy(table["table_name"]),
                     f"{url}/copy",
                     resource_class_kwargs={ 'table': table["table_name"] })

  except Exception as e:
    print(e.__class__, url, e)

if __name__ == '__main__':
  app.run(port=5000, debug=True)
