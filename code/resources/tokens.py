import datetime
from functools import partial
from threading import Timer

import dateutil.parser as parser
import sqlie3


class Interval(object):
  def __init__(self, interval, function, args=[], kwargs={}):
    """
        Runs the function at a specified interval with given arguments.
        """
    self.interval = interval
    self.function = partial(function, *args, **kwargs)
    self.running = False
    self._timer = None

  def __call__(self):
    """
        Handler function for calling the partial and continuting. 
        """
    self.running = False  # mark not running
    self.start()  # reset the timer for the next go
    self.function()  # call the partial function

  def start(self):
    """
        Starts the interval and lets it run. 
        """
    if self.running:
      # Don't start if we're running!
      return

    # Create the timer object, start and set state.
    self._timer = Timer(self.interval, self)
    self._timer.start()
    self.running = True

  def stop(self):
    """
        Cancel the interval (no more function calls).
        """
    if self._timer:
      self._timer.cancel()
    self.running = False
    self._timer = None


def db_connect():
  con = sqlite3.connect("tokens.db")
  return con


def create_tokens_table():
  con = db_connect()
  cursor = con.cursor()
  cursor.execute(
      'CREATE TABLE IF NOT EXISTS tokens (token text PRIMARY KEY, date text);')
  con.commit()
  con.close()


def get_tokens(token=""):
  con = db_connect()
  cursor = con.cursor()
  if token:
    cursor.execute(f'SELECT * FROM tokens WHERE token={token};')
    rows = cursor.fetchall()
    cursor.close()
    return [{ "token": row[0], "time": row[1] } for row in rows]
  else:
    cursor.execute('SELECT * FROM tokens')
    rows = cursor.fetchall()
    cursor.close()
    con.close()
    return [{ "token": row[0], "time": row[1] } for row in rows]


def save_token(token):
  con = db_connect()
  date = datetime.datetime.now().isoformat()
  cursor = con.cursor()
  cursor.execute("INSERT INTO tokens VALUES (?, ?);", (token, date))
  print(get_tokens())
  con.commit()
  cursor.close()
  con.close()


def delete_token(token):
  con = db_connect()
  cursor = con.cursor()
  cursor.execute("DELETE FROM tokens WHERE token=?", (token, ))
  con.commit()
  cursor.close()
  con.close()


create_tokens_table()
