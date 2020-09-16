import json

from flask import request
from flask_restful import Resource, reqparse
from procedures.locations import locations_service


class Location(Resource):
  def get(self):
    lk_id = request.args.get('id')
    try:
      if lk_id is not None:
        lk_id = int(lk_id)
        locations = locations_service.tbl_get(lk_id)
        if not len(locations):
          return {'message': f'location with id "{lk_id}" does not exist'}, 404
        else:
          return locations_service.db_to_rest(locations[0]), 200

      locations = locations_service.tbl_get()
      return {
          "locations":
          [locations_service.db_to_rest(location) for location in locations]
      }, 200
    except Exception:
      print(Exception.__class__)
      print("failed to fetch locations")
      return { 'message': "failed to fetch locations"}, 500

  def post(self):
    request_args = [
        col_name for col_name in [col['header'] for col in locations_service.cols]
        if col_name != "Id"
    ]
    parser = reqparse.RequestParser()
    [parser.add_argument(arg) for arg in request_args]
    location = parser.parse_args()
    if location["Aktivna"] is None:
      location['Aktivna'] = "D"

    try:
      new_location = locations_service.tbl_insert(
          (locations_service.rest_to_db(location)))
      location["id"] = new_location["rcod"]
      return { 'message': "location added", 'location': location }, 200
    except:
      return { 'message': "failed to create location"}, 500

  def put(self):
    request_args = [
        col_name for col_name in [col['header'] for col in locations_service.cols]
    ]
    parser = reqparse.RequestParser()
    [parser.add_argument(arg) for arg in request_args]
    location = parser.parse_args()
    try:
      new_location = locations_service.tbl_update(
          json.dumps(locations_service.rest_to_db(location)))
      return { 'message': "location changed", 'location': location }, 200
    except:
      return { 'message': "failed to create location"}, 500

  def delete(self):
    lk_id = request.args.get('id')
    try:
      locations_service.tbl_delete(lk_id)
      return { 'message': "Location deleted"}, 200
    except:
      print('failed to delete location')
      return { 'message': 'failed to delete location'}, 500


class LocationDescription(Resource):
  def get(self):
    try:
      return locations_service.col_description(), 200
    except:
      return {'message': "failed to fetch column descriptions " }
