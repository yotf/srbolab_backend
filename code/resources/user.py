from flask_restful import Resource, reqparse
from models.user import UserModel
from flask_jwt_extended import (
    create_access_token,
    create_refresh_token
)

class UserRegister(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('username',
                        type=str,
                        required=True,
                        help="'username' cannot be blank!")
    parser.add_argument('password',
                        type=str,
                        required=True,
                        help="'password' cannot be blank!")

    def post(self):
        data = self.parser.parse_args()
        user = UserModel.find_by_username(data["username"])
        if user:
            return {
                "message": "User '{}' already exists!".format(data["username"])
            }, 400

        user = UserModel(**data)
        user.save_to_db()

        return {"message": "User created successfully."}, 201

class UserLogin(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('username',
                        type=str,
                        required=True,
                        help="'username' cannot be blank!")
    parser.add_argument('password',
                        type=str,
                        required=True,
                        help="'password' cannot be blank!")
    def post(self):
        data = self.parser.parse_args()
        user = UserModel.find_by_username(data["username"])
        if user and user.kr_password == data["password"]:
            access_token = create_access_token(identity=user.json(), fresh=True)
            refresh_token = create_refresh_token(user.json())
            return {
                'access_token': access_token,
                'refresh_token': refresh_token
            }, 200




class Users(Resource):
    def get(self):
        return {"users": [user.json() for user in UserModel.query.all()]}
