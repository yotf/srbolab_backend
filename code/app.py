import datetime

from flask import Flask, request
from flask_cors import CORS
from flask_jwt_extended import get_raw_jwt
from flask_restful import Api

from jwt_init import jwt
from procedures.table_wrapper import db
from resources.azs import Azs
from resources.base_resource import (generate_copy, generate_description,
                                     generate_resource)
from resources.forms import Forms
from resources.login import Login, Logout, Refresh
from resources.predmeti import Predmeti
from resources.reports import Reports
from resources.tables import Tables
from resources.upload import Images, Upload

app = Flask(__name__)
# app.config['JWT_ACCESS_TOKEN_EXPIRES'] = 15 //in seconds
api = Api(app, "/api")
cors = CORS(app, supports_credentials=True)

jwt.init_app(app)
app.config.from_pyfile('config.py')


@app.after_request
def after_request(response):
  jwt = get_raw_jwt()
  username_ip = ""
  if request.method != "OPTIONS" and not request.url.endswith("login"):
    time = datetime.datetime.now().strftime("%d/%m/%Y %H:%M:%S")
    try:
      username_ip = f"{jwt['user_claims']['username']} {jwt['user_claims']['ip_address']}"
    except Exception as e:
      print(e)
    print(
        f"{time} - [{request.method}] {response.status} {request.url} {request.data} {username_ip}"
    )
  return response


api.add_resource(Forms, "/forms")
api.add_resource(Login, "/login")
api.add_resource(Logout, "/logout")
api.add_resource(Predmeti, "/predmeti")
api.add_resource(Refresh, "/refresh")
api.add_resource(Reports, "/report")
api.add_resource(Tables, "/tables")
api.add_resource(Upload, "/upload")
api.add_resource(Images, "/images")
api.add_resource(Azs, "/azs")
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
