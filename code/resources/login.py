from flask import jsonify, request
from flask_jwt_extended import (JWTManager, create_access_token,
                                create_refresh_token, get_jwt_identity,
                                get_raw_jwt, jwt_refresh_token_required,
                                jwt_required, set_access_cookies,
                                set_refresh_cookies)
from flask_restful import Resource
from procedures.table_wrapper import TableWrapper

user_service = TableWrapper("v_korisnik")
blacklist = set()


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
    if username != user["kr_username"] or password != user["kr_password"]:
      return { "msg": "Bad username or password"}, 401

    access_token = create_access_token(identity=user["kr_id"])
    refresh_token = create_refresh_token(identity=user["kr_id"])

    headers = [('Set-Cookie', 'access_token_cookie=' + access_token +
                "; Domain=http://localhost:3000"),
               ('Set-Cookie', 'refresh_token_cookie=' + refresh_token)]
    # return { "login": True }, 200,
    return {
        'access_token': access_token,
        "refresh_token": refresh_token
    }, 200, headers


class Refresh(Resource):
  @jwt_refresh_token_required
  def post(self):
    current_user = get_jwt_identity()
    access_token = create_access_token(identity=current_user)
    return { 'access_token': access_token }, 200


class Logout(Resource):
  @jwt_required
  def post(self):
    jti = get_raw_jwt()['jti']
    blacklist.add(jti)
    return { "msg": "Successfully logged out"}, 200
