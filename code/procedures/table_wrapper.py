import json

from procedures.pgdb import pgdb
from procedures.table import table

#= CLASS ===============================
# lokacija
#=======================================
db = pgdb()


class TableWrapper(table):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self, schema, table_name):
    super().__init__(db, table_name)
    # super().__init__(db, schema, table_name)
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
