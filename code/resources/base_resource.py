import json
import traceback
import types

from flask import request
from flask_jwt_extended import get_jwt_claims, get_jwt_identity, jwt_required
from flask_restful import Resource, reqparse
from procedures.table_wrapper import TableWrapper


def init_resource(self, table):
  super(self.__class__, self).__init__(table)


def init_description(self, table):
  super(self.__class__, self).__init__(table)


def init_copy(self, table):
  super(self.__class__, self).__init__(table)


def generate_resource(table):
  return type(table, (BaseResource, ), {
      '__init__': init_resource,
      'table': table,
  })


def generate_description(table):
  return type(table + "_dsc", (ResourceDescription, ), {
      '__init__': init_description,
      'table': table,
  })


def generate_copy(table):
  return type(table + "_copy", (Copy, ), {
      '__init__': init_copy,
      'table': table,
  })


class BaseResource(Resource):
  def __init__(self, table):
    self.service = TableWrapper(table)
    self.item_name = table
    self.primary_keys = self.service.primarykey

  @jwt_required
  def get(self):
    jwt_identity = get_jwt_identity()
    request_args = [
        col_name for col_name in [
            col['name'] for col in
            [*self.service.cols, {
                "name": "limit"
            }, {
                "name": "offset"
            }]
        ]
    ]
    if "kn_datum" in request_args:
      request_args.append("kn_datum_to")

    query_params = {
        key: request.args.get(key)
        for key in request_args if request.args.get(key)
    }
    try:
      if len(query_params.items()):
        items = self.service.tbl_get(query_params)
      else:
        items = self.service.tbl_get()

      if self.item_name == "v_korisnik":
        for item in items:
          item["kr_password"] = ""
      return items, 200
    except Exception as e:
      traceback.print_exc()
      print(e.__class__, e)
      print(f"failed to fetch {self.item_name}")
      return { 'message': f"failed to fetch {self.item_name}s"}, 500

  @jwt_required
  def post(self):
    request_args = [
        col_name for col_name in [col['name'] for col in [*self.service.cols]]
    ]

    parser = reqparse.RequestParser()
    [
        parser.add_argument(
            col["name"],
            type=int if col["type"] == "i" else str,
        ) if col["name"] != "vz_osovine" and col["name"] != "vzs_osovine" else
        parser.add_argument(col["name"], type=list, location="json")
        for col in self.service.cols
    ]

    item = parser.parse_args()

    try:
      new_item = self.service.tbl_insert(item)
      if (new_item["rcod"] and new_item["rcod"] > 0) or new_item["rcod"] == 0:
        get_args = {
            key:
            item.get(key, None) if item.get(key, None) else new_item["rcod"]
            for key in self.primary_keys
        }
        new_item = self.service.tbl_get(get_args)[0]
        if self.item_name == "v_korisnik" and new_item["kr_password"]:
          new_item["kr_password"] = ""

        return new_item, 200
      else:
        return new_item, 400
    except Exception as e:
      traceback.print_exc()
      print(e.__class__, e)
      return { 'message': f"failed to create {self.item_name}"}, 500

  @jwt_required
  def put(self):
    request_args = [
        col_name for col_name in [col['name'] for col in [*self.service.cols]]
    ]

    parser = reqparse.RequestParser()
    [
        parser.add_argument(
            col["name"],
            type=int if col["type"] == "i" else str,
        ) if col["name"] != "vz_osovine" and col["name"] != "vzs_osovine" else
        parser.add_argument(col["name"], type=list, location="json")
        for col in self.service.cols
    ]
    item = parser.parse_args()
    update_result = self.service.tbl_update(item)
    try:
      if (update_result["rcod"]
          and update_result["rcod"] > 0) or update_result["rcod"] == 0:
        get_args = { key: item[key] for key in self.primary_keys }
        new_item = self.service.tbl_get(get_args)[0]
        if self.item_name == "v_korisnik" and new_item["kr_password"]:
          new_item["kr_password"] = ""

        return new_item, 200
      else:
        return update_result, 400
    except Exception as e:
      traceback.print_exc()
      print(item)
      print(e.__class__, e)
      return { 'message': f"failed to update {self.item_name}"}, 500

  @jwt_required
  def delete(self):
    item_id = { key: request.args.get(key) for key in self.primary_keys }
    try:
      res = self.service.tbl_delete(item_id)
      if res["rcod"] >= 0:
        return { 'message': f"{self.item_name.capitalize()} deleted"}, 200
      else:
        return res, 400
    except:
      print(f'failed to delete self.item_name')
      return { 'message': f'failed to delete {self.item_name}'}, 500


class ResourceDescription(Resource):
  def __init__(self, table):
    self.service = TableWrapper(table)
    self.item_name = table

  @jwt_required
  def get(self):
    try:
      return self.service.cols, 200
    except:
      return {
          'message':
          f"failed to fetch column descriptions for '{self.item_name}'"
      }


class Copy(Resource):
  def __init__(self, table):
    self.service = TableWrapper(table)
    self.item_name = table
    self.primary_keys = self.service.primarykey

  def post(self):
    request_args = [
        *self.primary_keys, *[key + "_to" for key in self.primary_keys]
    ]
    parser = reqparse.RequestParser()
    [parser.add_argument(arg) for arg in request_args]
    item = parser.parse_args()

    try:
      new_item = self.service.tbl_copy(item)
      item[self.primary_keys[0]] = new_item[
          "rcod"]  #TODO fix primary key return
      return item, 200
    except Exception as e:
      traceback.print_exc()
      print(e.__class__, e)
      return { 'message': f"failed to create {self.item_name}"}, 500
