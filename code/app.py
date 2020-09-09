from flask import Flask
from flask_restful import Api
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from resources.user import UserRegister, Users, UserLogin
from resources.location import Location

app = Flask(__name__)
app.secret_key = "asdfqwer"
api = Api(app)
cors = CORS(app)  #TODO add fixed origin for production

# @app.before_first_request
# def create_tables():
#     db.create_all()

jwt = JWTManager(app)

# @app.route('/login', methods=['POST'])
# def login():
#     if not request.is_json:
#         return jsonify({"msg": "Missing JSON in request"}), 400

#     username = request.json.get('username', None)
#     password = request.json.get('password', None)
#     if not username:
#         return jsonify({"msg": "Missing username parameter"}), 400
#     if not password:
#         return jsonify({"msg": "Missing password parameter"}), 400

#     if username != 'test' or password != 'test':
#         return jsonify({"msg": "Bad username or password"}), 401

#     # Identity can be any data that is json serializable
#     access_token = create_access_token(identity=username)
#     return jsonify(access_token=access_token), 200

# api.add_resource(Item, "/item/<string:name>")
# api.add_resource(ItemList, "/items")
api.add_resource(UserRegister, "/register")
api.add_resource(Users, "/users")
api.add_resource(UserLogin, "/login")
# api.add_resource(LocationList, "/locations")
api.add_resource(Location, "/locations")

if __name__ == '__main__':
  app.run(port=5000, debug=True)
