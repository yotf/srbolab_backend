import json

from flask_jwt_extended import get_jwt_claims, get_jwt_identity, jwt_required
from flask_restful import Resource, reqparse
from procedures.table_wrapper import db


class Azs(Resource):
  @jwt_required
  def post(self):
    try:
      parser = reqparse.RequestParser()
      parser.add_argument("type")
      parser.add_argument("pr_id")
      body = parser.parse_args()
      string_type = 2 if body["type"] == "ispitivanje" else 1
      query = db.data4azs({ "pr_id": body["pr_id"] }, string_type)
      return { "query": query, "type": body["type"] }
    except Exception as e:
      print(e.__class__, e)
      return { 'message': 'failed to fetch data'}, 500
