import json

from procedures.form import predmeti
from procedures.pgdb import pgdb
from procedures.table import table

#= CLASS ===============================
# table_wrapper
#=======================================
db = pgdb()
predmeti_service = predmeti(db)


class TableWrapper(table):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self, table_name):
    super().__init__(db, table_name)
