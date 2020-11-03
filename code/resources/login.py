import json

from flask import request
from flask_jwt_extended import (JWTManager, create_access_token,
                                get_jwt_identity, jwt_required)
from flask_restful import Resource
from procedures.table_wrapper import TableWrapper

user_service = TableWrapper("v_korisnik")


class Login(Resource):
  def post(self):
    if not request.is_json:
      return { "msg": "Missing JSON in request"}, 400

    username = request.json.get('username', None)
    password = request.json.get('password', None)
    if not username:
      return { "msg": "Missing username parameter"}, 400
    if not password:
      return { "msg": "Missing password parameter"}, 400

    user = user_service.tbl_get({ "kr_username": username })[0]
    print(user, username, password)
    if username != user["kr_username"] or password != user["kr_password"]:
      return { "msg": "Bad username or password"}, 401

    # Identity can be any data that is json serializable
    print(user["kr_id"])
    access_token = create_access_token(identity=user["kr_id"])
    return { 'access_token': access_token }, 200
