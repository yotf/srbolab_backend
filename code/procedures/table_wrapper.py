import json

from procedures.pgdb import pgdb
from procedures.table import table

#= CLASS ===============================
# table_wrapper
#=======================================
db = pgdb()


class TableWrapper(table):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self, table_name):
    super().__init__(db, table_name)
