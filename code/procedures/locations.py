import json

from procedures.pgdb import pgdb
from procedures.table import table

#= CLASS ===============================
# lokacija
#=======================================
db = pgdb('pg123')


class Location(table):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self):
    super().__init__("sys", "lokacija")

  def remove_prefix(self, location):
    location_rest = {}
    for key, value in location.items():
      location_rest[key.split("_", 1)[1]] = value

    json.dumps(location_rest)
    return location_rest

  def add_prefix(self, location):
    location_db = {}
    for key, value in location.items():
      location_db["lk_" + key] = value
    return location_db


locations_service = Location()
