import json
import types

from flask import request
from flask_jwt_extended import jwt_required
from flask_restful import Resource, reqparse
from procedures.table_wrapper import predmeti_service


class Predmeti(Resource):
  @jwt_required
  def get(self):
    return predmeti_service.col_fnc

  @jwt_required
  def post(self):
    try:
      parser = reqparse.RequestParser()
      parser.add_argument("activeColumn")
      parser.add_argument("values")
      parser.add_argument("altFnc")
      body = (parser.parse_args())
      fnc_key = "fnc" if body["altFnc"] == "False" else "fnc1"
      filter_params = dct_type(body["values"])

      # if (not hasattr(filter_params, body["activeColumn"])):
      #   filter_params[body["activeColumn"]] = ""

      fnc = predmeti_service.col_fnc[body["activeColumn"]][fnc_key]
      print(fnc, filter_params)
      items = predmeti_service.data_get(fnc, filter_params)
      return items, 200

    except Exception as e:
      traceback.print_exc()
      print(e)
      return { "message": "Something went wrong"}, 500


def dct_type(dictString):
  return eval(dictString)
