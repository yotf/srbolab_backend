from flask_jwt_extended import (create_access_token, create_refresh_token,
                                jwt_required)
from flask_restful import Resource, reqparse
from procedures.users import user_service


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
    user = user_service.tbl_get(username=data["username"])
    if user:
      return {
          "message": "User '{}' already exists!".format(data["username"])
      }, 400

    db_response = user_service.tbl_i(**data)
    print(db_response)
    return { "message": "User created successfully."}, 201


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
    user = user_service.tbl_g(username=data["username"])
    # print(user.json())
    if user and user.kr_password == data["password"]:
      access_token = create_access_token(identity=user.json(), fresh=True)
      refresh_token = create_refresh_token(user.json())
      return {
          'access_token': access_token,
          'refresh_token': refresh_token,
          'username': user.kr_username,
          'user_id': user.kr_id,
          'name': user.kr_ime,
          'surname': user.kr_prezime,
      }, 200
    else:
      return { 'message': "wrong username or password"}, 400


class Users(Resource):
  # @jwt_required
  def get(self):
    return { "users": [user for user in user_service.tbl_g()] }
