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
    print('BR INIT {}'.format(table))
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
    print('GET {}'.format(query_params))
    try:
      if len(query_params.items()):
        items = self.service.tbl_get(query_params, { "kr_id": jwt_identity })
      else:
        items = self.service.tbl_get({}, { "kr_id": jwt_identity })

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
    jwt_identity = get_jwt_identity()
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
    # print(item)
    print('POST {}'.format(item))

    try:
      new_item = self.service.tbl_insert(item, { "kr_id": jwt_identity })
      if (new_item["rcod"] and new_item["rcod"] > 0) or new_item["rcod"] == 0:
        get_args = {
            key:
            item.get(key, None) if item.get(key, None) else new_item["rcod"]
            for key in self.primary_keys
        }
        new_items = self.service.tbl_get(get_args, { "kr_id": jwt_identity })
        if new_items and len(new_items)>0:          
          new_item = new_items[0]
          if self.item_name == "v_korisnik" and new_item["kr_password"]:
            new_item["kr_password"] = ""
        #INS/UPD into sert after predmet insert
        if(self.service.name == "v_predmet"):
          self.insert_sert(item, { "kr_id": jwt_identity })
        return item, 200
      else:
        return new_item, 400
    except Exception as e:
      traceback.print_exc()
      print(e.__class__, e)
      return { 'message': f"failed to create {self.item_name}"}, 500

  def insert_sert(self, item, px_x):
    sert_table = TableWrapper("v_vozilo_sert")
    sert_item = dict(item)
    sert_item = {
      "vzs_id": item.get("vzs_id"),
      "vzs_oznaka":item.get("vzs_oznaka"),
      "vzs_godina": item.get("vz_godina"),
      "vzs_mesta_sedenje": item.get("vz_mesta_sedenje"),
      "vzs_mesta_stajanje": item.get("vz_mesta_stajanje"),
      "vzs_masa": item.get("vz_masa"),
      "vzs_nosivost": item.get("vz_nosivost"),
      "vzs_masa_max": item.get("vz_masa_max"),
      "vzs_duzina": item.get("vz_duzina"),
      "vzs_sirina": item.get("vz_sirina"),
      "vzs_visina": item.get("vz_visina"),
      "vzs_kuka_sert": item.get("vz_kuka_sert"),
      "vzs_max_brzina": item.get("vz_max_brzina"),
      "vzs_kw_kg": item.get("vz_kw_kg"),
      "vzs_co2": item.get("vz_co2"),
      "vzs_sert_hmlg_tip": item.get("vz_sert_hmlg_tip"),
      "vzs_sert_emisija": item.get("vz_sert_emisija"),
      "vzs_sert_buka": item.get("vz_sert_buka"),
      "mr_id": item.get("mr_id"),
      "md_id": item.get("md_id"),
      "vzpv_id": item.get("vzpv_id"),
      "vzkl_id": item.get("vzkl_id"),
      "em_id": item.get("em_id"),
      "gr_id": item.get("gr_id"),
      "mdt_id": item.get("mdt_id"),
      "mdvr_id": item.get("mdvr_id"),
      "mdvz_id": item.get("mdvz_id"),
      "mt_id": item.get("mt_id"),
      "kr_id": item.get("kr_id")
    }
    print('INS SERT FROM PREDMET {}'.format(sert_item))
    rez = sert_table.tbl_insert(sert_item, px_x)
    #TODO this rez iz ignored no ERROR HANDLING
    print('INS SERT FROM PREDMET REZ = {}'.format(rez))

  @jwt_required
  def put(self):
    jwt_identity = get_jwt_identity()
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
    print('PUT {}'.format(item))
    update_result = self.service.tbl_update(item, { "kr_id": jwt_identity })
    try:
      if (update_result["rcod"]
          and update_result["rcod"] > 0) or update_result["rcod"] == 0:
        get_args = { key: item[key] for key in self.primary_keys }
        new_item = self.service.tbl_get(get_args, { "kr_id": jwt_identity })[0]
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
    jwt_identity = get_jwt_identity()
    item_id = { key: request.args.get(key) for key in self.primary_keys }
    print('DEL {}'.format(item_id))
    try:
      res = self.service.tbl_delete(item_id, { "kr_id": jwt_identity })
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

  @jwt_required
  def post(self):
    jwt_identity = get_jwt_identity()
    request_args = [
        *self.primary_keys, *[key + "_to" for key in self.primary_keys]
    ]
    parser = reqparse.RequestParser()
    [parser.add_argument(arg) for arg in request_args]
    item = parser.parse_args()
    print('Copy {}'.format(item))
    try:
      db_response = self.service.tbl_copy(item, { "kr_id": jwt_identity })
      new_item = self.service.tbl_get(
          { key: item[key + "_to"]
            for key in self.primary_keys })
      return new_item[0], 200
    except Exception as e:
      traceback.print_exc()
      print(e.__class__, e)
      return { 'message': f"failed to create {self.item_name}"}, 500
