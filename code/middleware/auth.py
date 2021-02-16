import json
import traceback
from functools import wraps

from flask import request
from flask_jwt_extended import get_jwt_identity
from procedures.application import application
from procedures.table_wrapper import db

method_actions = { "GET": "v", "POST": "i", "PUT": "u", "DELETE": "d"}


def auth(f):
  @wraps(f)
  def _auth(*args, **kwargs):
    user_identity = get_jwt_identity()
    form_groups = application(db, user_identity).apps
    form = find_form(form_groups, args[0].item_name)
    is_valid = isActionAvailable(form, method_actions[request.method])
    if is_valid:
      result = (f(*args, **kwargs))
      return result
    else:
      print("kr_id: ", user_identity)
      print("form: ", args[0].item_name)
      return { "message": "akcija nije dozvoljena!"}, 403

  return _auth


def find_form(form_groups, table_name):
  try:
    for form_group in form_groups:
      if "forms" in form_group:
        for form in form_group["forms"]:
          if "source" in form["tables"] and form["tables"][
              "source"] == table_name:
            return form
          elif "datails" in form["tables"] and len(form["tables"]["details"]):
            for d in form["tables"]["details"]:
              if d["source"] == table_name:
                return d
  except Exception as e:
    traceback.print_exc()
    print(e.__class__, e)
    return None


def isActionAvailable(form, action_key):
  if not form or not action_key:
    return False
  try:
    actions = form["actions"] if "actions" in form else form["tables"]["actions"]
    action = [action for action in actions if action["key"] == action_key][0]
    return action["enabled"]
  except Exception as e:
    traceback.print_exc()
    print(e.__class__, e)
    return False
