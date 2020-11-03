import json
import types

from flask import request
from flask_restful import Resource, reqparse
from procedures.table_wrapper import predmeti_service


class Predmeti(Resource):
  def get(self):
    return predmeti_service.col_fnc

  def post(self):
    parser = reqparse.RequestParser()
    parser.add_argument("activeColumn")
    parser.add_argument("values")
    parser.add_argument("altFnc")

    body = parser.parse_args()
    fnc_key = "fnc" if body["altFnc"] == "False" else "fnc1"
    filter_params = eval(body["values"])  #TODO

    if (not hasattr(filter_params, body["activeColumn"])):
      filter_params[body["activeColumn"]] = ""

    fnc = predmeti_service.col_fnc[body["activeColumn"]][fnc_key]
    items = predmeti_service.data_get(fnc, filter_params)
    return items, 200
