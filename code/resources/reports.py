import json
import os
import traceback

from flask import send_file
from flask_jwt_extended import get_jwt_claims, get_jwt_identity, jwt_required
from flask_restful import Resource, reqparse
from procedures.report import report
from procedures.table_wrapper import TableWrapper

report_service = report()

user_service = TableWrapper("v_korisnik")

filepath = ""


class Reports(Resource):
  @jwt_required
  def post(self):
    try:
      if filepath:
        os.remove(filepath)

      parser = reqparse.RequestParser()
      parser.add_argument("type")
      parser.add_argument("values")
      body = parser.parse_args()
      print(body)

      user_identity = get_jwt_identity()
      username = user_service.tbl_get({ "kr_id":
                                        user_identity })[0]["kr_username"]
      file_path = report_service.run(username, body["type"],
                                     eval(body["values"]))

      return send_file(file_path)
    except Exception as e:
      traceback.print_exc()
      print(e.__class__, e)
      return { 'message': 'failed to fetch forms'}, 500
