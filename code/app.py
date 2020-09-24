from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_restful import Api

from resources.base_resource import (BaseResource, ResourceDescription,
                                     generate_resource)
from resources.location import Location, LocationDescription
from resources.user import UserLogin, UserRegister, Users

app = Flask(__name__)
app.secret_key = "asdfqwer"
api = Api(app)
cors = CORS(app)  #TODO add fixed origin for production

jwt = JWTManager(app)

api.add_resource(UserRegister, "/register")
api.add_resource(generate_resource('sys', 'korisnik', 'kr'),
                 "/users",
                 resource_class_kwargs={
                     'schema': 'sys',
                     'table': 'korisnik',
                     'prefix': "kr"
                 })
api.add_resource(UserLogin, "/login")
# api.add_resource(BaseResource,
api.add_resource(generate_resource('sys', 'lokacija', 'lk'),
                 "/locations",
                 resource_class_kwargs={
                     'schema': 'sys',
                     'table': 'lokacija',
                     'prefix': "lk"
                 })
api.add_resource(ResourceDescription,
                 "/locations/description",
                 resource_class_kwargs={
                     'schema': 'sys',
                     'table': 'lokacija',
                     'prefix': "lk"
                 })

if __name__ == '__main__':
  app.run(port=5000, debug=True)
