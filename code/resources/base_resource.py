import json
import types

from flask import request
from flask_jwt_extended import get_jwt_claims, get_jwt_identity
from flask_restful import Resource, reqparse
from procedures.table_wrapper import TableWrapper


def initi_resource(self, table):
  super(self.__class__, self).__init__(table)


def initi_description(self, table):
  super(self.__class__, self).__init__(table)


def generate_resource(table):
  return type(table, (BaseResource, ), {
      '__init__': initi_resource,
      'table': table,
  })  #TODO


def generate_description(table):
  return type(table + "_dsc", (ResourceDescription, ), {
      '__init__': initi_description,
      'table': table,
  })  #TODO


class BaseResource(Resource):
  def __init__(self, table):
    self.service = TableWrapper(table)
    self.item_name = table
    self.primary_keys = self.service.primarykey

  def get(self):
    jwt_identity = get_jwt_identity()
    jwt_claims = get_jwt_claims()
    print(jwt_identity, json.dumps(jwt_identity), jwt_claims)
    request_args = [
        col_name for col_name in [col['name'] for col in self.service.cols]
    ]
    query_params = {
        key: request.args.get(key)
        for key in request_args if request.args.get(key)
    }
    items = self.service.tbl_get()
    try:
      if len(query_params.items()):
        items = self.service.tbl_get(query_params)
        # if not len(items):
        #   return {
        #       'message':
        #       f"{self.item_name} with id '{json.dumps(query_params)}' does not exist"
        #   }, 404
        # else:
        return (items), 200

      items = self.service.tbl_get()
      return items, 200
    except Exception as e:
      print(e.__class__, e)
      print(f"failed to fetch {self.item_name}")
      return { 'message': f"failed to fetch {self.item_name}s"}, 500

  def post(self):
    request_args = [
        col_name for col_name in [col['name'] for col in self.service.cols]
    ]
    parser = reqparse.RequestParser()
    [parser.add_argument(arg) for arg in request_args]
    item = parser.parse_args()

    try:
      new_item = self.service.tbl_insert(item)
      item[self.primary_keys[0]] = new_item[
          "rcod"]  #TODO fix primary key return
      return item, 200
    except Exception as e:
      print(e.__class__, e)
      return { 'message': f"failed to create {self.item_name}"}, 500

  def put(self):
    request_args = [
        col_name for col_name in [col['name'] for col in self.service.cols]
    ]
    parser = reqparse.RequestParser()
    [parser.add_argument(arg) for arg in request_args]
    item = parser.parse_args()
    try:
      update_result = self.service.tbl_update(item)
      return item, 200
    except Exception as e:
      print(item)
      print(e.__class__, e)
      return { 'message': f"failed to update {self.item_name}"}, 500

  def delete(self):
    item_id = { key: request.args.get(key) for key in self.primary_keys }
    try:
      self.service.tbl_delete(item_id)
      return { 'message': f"{self.item_name.capitalize()} deleted"}, 200
    except:
      print(f'failed to delete self.item_name')
      return { 'message': f'failed to delete {self.item_name}'}, 500


class ResourceDescription(Resource):
  def __init__(self, table):
    self.service = TableWrapper(table)
    self.item_name = table

  def get(self):
    try:
      return self.service.cols, 200
    except:
      return {
          'message':
          f"failed to fetch column descriptions for '{self.item_name}'"
      }