from procedures.table import table


#= CLASS ===============================
# korisnik
#=======================================
class User(table):

  #= METHOD ==============================
  # __init__
  #=======================================
  def __init__(self):
    super().__init__("sys", "korisnik")

  def user_to_json(user):
    return {
        'username': user["kr_username"],
        'ime': user["kr_ime"],
        'prezime': user["kr_prezime"]
    }


user_service = User()
