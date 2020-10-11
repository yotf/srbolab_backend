from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_restful import Api

from procedures.table_wrapper import db
from resources.base_resource import generate_description, generate_resource
from resources.login import Login
from resources.tables import Tables

# from resources.user import UserLogin, UserRegister, Users

app = Flask(__name__)
app.secret_key = "asdfqwer"
app.config['JWT_SECRET_KEY'] = 'super-secret'  # Change this!
api = Api(app)
cors = CORS(app)  #TODO add fixed origin for production

jwt = JWTManager(app)

api.add_resource(Tables, "/tables")
api.add_resource(Login, "/login")
for table in db.tbls():
  try:
    url = f"/{table['table_name']}"
    api.add_resource(generate_resource(table["table_name"]),
                     url,
                     resource_class_kwargs={ 'table': table["table_name"] })
    api.add_resource(generate_description(table["table_name"]),
                     f"{url}/description",
                     resource_class_kwargs={ 'table': table["table_name"] })
  except Exception:
    print(Exception.__class__, url)

if __name__ == '__main__':
  app.run(port=5000, debug=True)
