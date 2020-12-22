import sqlite3
import time
from functools import partial
from threading import Timer


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
      'CREATE TABLE IF NOT EXISTS tokens (jti text PRIMARY KEY, time integer);')
  con.commit()
  con.close()


def get_tokens(jti=""):
  con = db_connect()
  cursor = con.cursor()
  if jti:
    cursor.execute(f'SELECT * FROM tokens WHERE jti=? ;', (jti, ))
    rows = cursor.fetchall()
    cursor.close()
    return [{ "jti": row[0], "time": row[1] } for row in rows]
  else:
    cursor.execute('SELECT * FROM tokens')
    rows = cursor.fetchall()
    cursor.close()
    con.close()
    return [{ "jti": row[0], "time": row[1] } for row in rows]


def save_token(jti, time_stamp):
  time = int(time_stamp)
  con = db_connect()
  cursor = con.cursor()
  cursor.execute("INSERT INTO tokens VALUES (?, ?);", (jti, time))
  con.commit()
  cursor.close()
  con.close()


def delete_token(jti):
  con = db_connect()
  cursor = con.cursor()
  cursor.execute("DELETE FROM tokens WHERE jti=? ;", (jti, ))
  con.commit()
  cursor.close()
  con.close()


def delete_expired_tokens():
  print("DELETING STALE TOKENS")
  current_time = int(time.time())
  con = db_connect()
  cursor = con.cursor()
  cursor.execute("DELETE FROM tokens WHERE time <= ? ;", (current_time, ))
  con.commit()
  cursor.close()
  con.close()


delete_stale_worker = Interval((60 * 60 * 2), delete_expired_tokens)
