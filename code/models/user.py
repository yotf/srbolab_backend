from db import db


class UserModel:

    def __init__(self, ime, prezime, username, password, aktivan="D", arl_id=1):
        self.kr_username = username
        self.kr_password = password
        self.kr_prezime = ime
        self.kr_ime = prezime
        self.kr_aktivan = aktivan
        self.arl_id = arl_id

    def json(self):
        return {
            "ime": self.kr_ime,
            "prezime": self.kr_prezime,
            "id": self.kr_id,
            "username": self.kr_username
        }

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    @classmethod
    def find_by_username(cls, username):
        return cls.query.filter_by(  #querry is method on db.Model class
            kr_username=username).first()

    @classmethod
    def find_by_id(cls, _id):
        return cls.query.filter_by(kr_id=_id).first()
