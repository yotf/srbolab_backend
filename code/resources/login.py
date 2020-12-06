import asyncio
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
from passlib.hash import sha256_crypt
from procedures.table_wrapper import TableWrapper

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

    user = user_service.tbl_get({ "kr_username": username })[0]
    #TODO change pass verification to sha256_cryp.verify(password, user["kr_passwor"])
    if username != user["kr_username"] or password != user["kr_password"]:
      userLog(username, "login_failed", ipAddress)
      return { "msg": "Bad username or password"}, 401

    userLog(username, "login", ipAddress)
    access_token = create_access_token(identity=user["kr_id"])
    refresh_token = create_refresh_token(identity=user["kr_id"])
    new_jti = get_jti(access_token)
    whitelist.add(new_jti)
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
    whitelist.add(new_jti)
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
    whitelist.remove(jti)
    return { "msg": "Successfully logged out"}, 200


def remove_jti_from_whitelist(jti):
  print(whitelist, jti)
  if jti in whitelist:
    whitelist.remove(jti)
  print(whitelist)


def remove_jti_from_whitelist_async(jti):
  Timer(10, remove_jti_from_whitelist, (jti, )).start()


def userLog(username, action, ipAddress):
  now = datetime.datetime.now()
  date = now.strftime("%d.%m.%Y %H:%M:%S")
  print(f'{date} {ipAddress} {username} {action} ')


@jwt.token_in_blacklist_loader
def check_token(token):
  jti = token['jti']
  return jti not in whitelist
