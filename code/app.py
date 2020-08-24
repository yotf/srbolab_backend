from flask import Flask
from flask_restful import Api
from flask_jwt_extended import JWTManager, create_access_token
from security import authenticate, identity
from resources.user import UserRegister, Users
# from resources.item import Item, ItemList


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgres+psycopg2://postgres:pg123@localhost:5432/srbolab'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.secret_key = "asdfqwer"
api = Api(app)


# @app.before_first_request
# def create_tables():
#     db.create_all()


jwt = JWTManager(app)

@app.route('/login', methods=['POST'])
def login():
    if not request.is_json:
        return jsonify({"msg": "Missing JSON in request"}), 400

    username = request.json.get('username', None)
    password = request.json.get('password', None)
    if not username:
        return jsonify({"msg": "Missing username parameter"}), 400
    if not password:
        return jsonify({"msg": "Missing password parameter"}), 400

    if username != 'test' or password != 'test':
        return jsonify({"msg": "Bad username or password"}), 401

    # Identity can be any data that is json serializable
    access_token = create_access_token(identity=username)
    return jsonify(access_token=access_token), 200


# api.add_resource(Item, "/item/<string:name>")
# api.add_resource(ItemList, "/items")
api.add_resource(UserRegister, "/register")
api.add_resource(Users, "/users")

if __name__ == '__main__':
    from db import db
    db.init_app(app)
    app.run(port=5000, debug=True)
