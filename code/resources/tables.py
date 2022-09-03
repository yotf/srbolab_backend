import traceback
from flask_jwt_extended import jwt_required
from flask_restful import Resource
from procedures.table_wrapper import db


class Tables(Resource):
  @jwt_required
  def get(self):
    try:
      tables = db.tbls()
      return tables, 200
    except Exception:
      traceback.print_exc()
      print(Exception.__class__)
      return { 'message': 'failed to fetch tables'}, 500
