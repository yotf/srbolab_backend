from flask_restful import Resource
from procedures.table_wrapper import db


class Tables(Resource):
  def get(self):
    try:
      tables = db.tbls()
      return tables, 200
    except Exception:
      print(Exception.__class__)
      return { 'message': 'failed to fetch tables'}, 500