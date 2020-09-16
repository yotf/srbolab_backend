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
    self.prefix = 'lk'
    self.cols = [{
        **col, 'header': col['header'].replace("_", " ")
    } for col in self.cols]

  def db_to_rest(self, location):
    location_rest = {}
    for key, value in location.items():
      column = next(filter(lambda col: (col["name"] == key), self.cols))
      location_rest[column['header']] = value
    return location_rest

  def rest_to_db(self, location):
    location_db = {}
    for key, value in location.items():
      column = next(filter(lambda col: (col["header"] == key), self.cols))
      location_db[column['name']] = value

    return location_db

  def col_description(self):
    visible_cols = [col.copy() for col in self.cols if col['show']]
    columns = list(map(map_columns, visible_cols))
    return columns


def map_columns(col):
  col['name'] = col.copy()['header'].replace("_", " ")
  del col['header']
  return col


locations_service = Location()
