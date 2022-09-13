import datetime
import json
import traceback

from flask_jwt_extended import get_jwt_identity, jwt_required
from flask_restful import Resource
from procedures.application import application
from procedures.table_wrapper import TableWrapper, db

user_service = TableWrapper("v_korisnik")


class Forms(Resource):
  @jwt_required
  def get(self):
    try:
      user_identity = get_jwt_identity()
      role_id = user_service.tbl_get({ "kr_id": user_identity })[0]["arl_id"]
      form_groups = application(db, user_identity).apps
      filtered_form_groups = [{
          **form_group, "forms":
          [form for form in form_group["forms"] if form["enabled"]]
      } for form_group in form_groups]
      return filtered_form_groups, 200
    except Exception as e:
      traceback.print_exc()
      print(e.__class__, e)
      return { 'message': 'failed to fetch forms'}, 500
