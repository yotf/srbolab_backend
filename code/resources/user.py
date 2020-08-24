import sqlite3
from  flask_restful import Resource, reqparse
from models.user import UserModel

class UserRegister(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('username', type=str, required=True, help="'username' cannot be blank!")
    parser.add_argument('password', type=str, required=True, help="'password' cannot be blank!")

    def post(self):

        data = UserReister.parser.parse_args()
        user = UserModel.find_by_username(data["username"])
        if user:
            return {"message": "User '{}' already exists!".format(data["username"])}, 400

        user = UserModel(**data)
        user.save_to_db()

        return {"message": "User created successfully."}, 201


class Users(Resource):
    def get(self):
        return {"users": [user.json() for user in UserModel.query.all()]}
