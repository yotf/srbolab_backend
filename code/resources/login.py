import datetime
from threading import Timer

from flask import jsonify, request
from flask_jwt_extended import (JWTManager, create_access_token,
                                create_refresh_token, get_jti,
                                get_jwt_identity, get_raw_jwt,
                                jwt_refresh_token_required, jwt_required,
                                set_access_cookies, set_refresh_cookies)
from flask_restful import Resource, reqparse
from jwt_init import jwt
from procedures.table_wrapper import TableWrapper, db

from tokens import create_tokens_table, delete_token, get_tokens, save_token

user_service = TableWrapper("v_korisnik")
whitelist = set()


class Login(Resource):
  def post(self):
    if not request.is_json:
      return { "msg": "Missing JSON in request"}, 400

    username = request.json.get('username', None)
    password = request.json.get('password', None)
    ipAddress = request.headers.get("publicAddress") or ""
    if not username:
      return { "msg": "Missing username parameter"}, 400
    if not password:
      return { "msg": "Missing password parameter"}, 400
    loginStatus = db.user_login({
        "kr_username": username,
        "kr_password": password
    })
    if loginStatus == -100:
      userLog(username, "login_failed", ipAddress)
      return { "msg": "Pogrešno korisničko ime ili šifra"}, 401
    elif loginStatus == -200:
      return { "msg": "Korsnik nije aktivan"}, 401
    elif loginStatus == -900:
      return { "msg": "Došlo je do greške"}, 401

    userLog(username, "login", ipAddress)
    access_token = create_access_token(identity=loginStatus)
    refresh_token = create_refresh_token(identity=loginStatus)
    new_jti = get_jti(access_token)
    print(new_jti)
    save_token(new_jti)
    return { 'access_token': access_token, "refresh_token": refresh_token }, 200


class Refresh(Resource):
  @jwt_refresh_token_required
  def post(self):
    parser = reqparse.RequestParser()
    parser.add_argument("jti")
    body = parser.parse_args()
    jti = body["jti"]
    remove_jti_from_whitelist_async(jti)
    current_user = get_jwt_identity()
    access_token = create_access_token(identity=current_user)
    new_jti = get_jti(access_token)
    save_token(new_jti)
    return { 'access_token': access_token }, 200


class Logout(Resource):
  @jwt_required
  def post(self):
    user_identity = get_jwt_identity()
    username = user_service.tbl_get({ "kr_id":
                                      user_identity })[0]["kr_username"]
    ipAddress = request.headers.get("publicAddress") or ""
    userLog(username, "logout", ipAddress)
    jti = get_raw_jwt()['jti']
    delete_token(jti)
    return { "msg": "Successfully logged out"}, 200


def remove_jti_from_whitelist_async(jti):
  Timer(10, delete_token, (jti, )).start()


def userLog(username, action, ipAddress):
  now = datetime.datetime.now()
  date = now.strftime("%d.%m.%Y %H:%M:%S")
  print(f'{date} {ipAddress} {username} {action} ')


@jwt.token_in_blacklist_loader
def check_token(token):
  jti = token['jti']
  tokens = get_tokens(jti)
  print(tokens, len(tokens))
  return jti not in [token.get("token", "") for token in tokens]
