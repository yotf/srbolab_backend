from flask_restful import Resource, reqparse
from flask import request
from procedures.locations import locations_service
import json

# class LocationList(Resource):
#   def get(self):
#     lk_id = request.args.get('id')
#     print(lk_id)
#     print("fetching locations")
#     try:
#       locations = locations_service.lk_g()
#       return {
#           "locations":
#           [locations_service.remove_prefix(location) for location in locations]
#       }, 200
#     except Exception:
#       print(Exception.__class__)
#       print("failed to fetch locations")
#       return { 'message': "failed to fetch locations"}, 500


class Location(Resource):
  def get(self):
    lk_id = request.args.get('id')
    print(lk_id)
    print("fetching locations")
    try:
      locations = locations_service.lk_g()
      return {
          "locations":
          [locations_service.remove_prefix(location) for location in locations]
      }, 200
    except Exception:
      print(Exception.__class__)
      print("failed to fetch locations")
      return { 'message': "failed to fetch locations"}, 500

  def post(self):
    request_args = [
        col_name.split("_", 1)[1] for col_name in locations_service.col_names
        if col_name != "lk_id"
    ]
    parser = reqparse.RequestParser()
    [parser.add_argument(arg) for arg in request_args]
    location = parser.parse_args()
    if location["aktivna"] is None:
      location['aktivna'] = "D"
    try:
      new_location = locations_service.tbl_i(
          json.dumps(locations_service.add_prefix(location)))
      print(new_location)
      location["id"] = new_location["rcod"]
      return { 'message': "location added", 'location': location }, 200
    except:
      return { 'message': "failed to create location"}, 500

  def put(self):
    request_args = [
        col_name.split("_", 1)[1] for col_name in locations_service.col_names
    ]
    parser = reqparse.RequestParser()
    [parser.add_argument(arg) for arg in request_args]
    location = parser.parse_args()
    try:
      new_location = locations_service.tbl_u(
          json.dumps(locations_service.add_prefix(location)))
      print(new_location)
      return { 'message': "location changed", 'location': location }, 200
    except:
      return { 'message': "failed to create location"}, 500

  def delete(self):
    lk_id = request.args.get('id')
    try:
      locations_service.tbl_d(lk_id)
      return { 'message': "Location deleted"}, 200
    except:
      print('failed to delete location')
      return { 'message': 'failed to delete location'}, 500
