import json
import types
from flask import request
from flask_restful import Resource, reqparse
from procedures.table_wrapper import TableWrapper


def generate_resource(schema, table, prefix, id_key="Id"):
    return types.new_class(table, ( BaseResource, ), {'schema': schema, 'table': table, 'prefix': prefix, 'id_key': id_key}, lambda ns: ns) #TODO


class BaseResource(Resource):
  def __init__(self, schema, table, prefix, id_key="Id"):
    self.service = TableWrapper(schema, table, prefix)
    self.item_name = table
    self.prefix = prefix
    self.id_key = id_key

  def get(self):
    item_id = request.args.get('id')
    try:
      if item_id is not None:

        item_id = int(item_id)
        items = self.service.tbl_get(item_id)
        if not len(items):
          return {'message': f'{self.item_name} with id "{item_id}" does not exist'}, 404
        else:
          return self.service.db_to_rest(items[0]), 200

      items = self.service.tbl_get()
      return [self.service.db_to_rest(item) for item in items] , 200
    except Exception:
      print(Exception.__class__)
      print(f"failed to fetch {self.item_name}")
      return { 'message': f"failed to fetch {self.item_name}s"}, 500

  def post(self):
    request_args = [
        col_name for col_name in [col['header'] for col in self.service.cols]
        if col_name != "Id"
    ]
    parser = reqparse.RequestParser()
    [parser.add_argument(arg) for arg in request_args]
    item = parser.parse_args()

    try:
      new_item = self.service.tbl_insert(
          (self.service.rest_to_db(item)))
      item[self.id_key] = new_item["rcod"]
      print(json.dumps(item), json.dumps(new_item))
      return item , 200
    except:
      return { 'message': f"failed to create {self.item_name}"}, 500

  def put(self):
    request_args = [
        col_name for col_name in [col['header'] for col in self.service.cols]
    ]
    parser = reqparse.RequestParser()
    [parser.add_argument(arg) for arg in request_args]
    item = parser.parse_args()
    try:
      new_item = self.service.rest_to_db(item)
      update_result = self.service.tbl_update(new_item)
      return  item, 200
    except:
      return { 'message': f"failed to create {self.item_name}"}, 500

  def delete(self):
    item_id = request.args.get('id')
    try:
      self.service.tbl_delete(item_id)
      return { 'message': f"{self.item_name.capitalize()} deleted"}, 200
    except:
      print(f'failed to delete self.item_name')
      return { 'message': f'failed to delete {self.item_name}'}, 500


class ResourceDescription(Resource):
  def __init__(self, schema, table, prefix):
    self.service = TableWrapper(schema, table, prefix)
    self.item_name = table

  def get(self):
    try:
      return self.service.col_description(), 200
    except:
      return {'message': f"failed to fetch column descriptions for '{self.item_name}'" }
