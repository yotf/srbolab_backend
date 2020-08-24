import sqlite3
from db import db

class UserModel(db.Model):
    __tablename__ = "korisnik"

    kr_id = db.Column(db.Integer, primary_key=True)
    kr_username = db.Column(db.String(80))
    kr_password = db.Column(db.String(80))
    kr_prezime = db.Column(db.String(80))
    kr_ime = db.Column(db.String(80))
    kr_aktivan = db.Column(db.String(1)) 
    arl_id = db.Column(db.Integer) #TODO change to foreign key when tabels are ready

    def __init__(self, ime, prezime,  username, password,  aktivan="D", arl_id=1):
        self.kr_username = username
        self.kr_password = password
        self.kr_prezime = ime
        self.kr_ime = prezime
        self.kr_aktivan = aktivan
        self.arl_id = arl_id

    def json(self):
        return {"ime": self.kr_ime, "prezime": self.kr_prezime, "id": self.kr_id, "username": self.kr_username }

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    @classmethod
    def find_by_username(cls, username):
        return cls.querry.filter_by(kr_username=username).first() #querry is method on db.Model class

    @classmethod
    def find_by_id(cls, _id):
        return cls.query.filter_by(kr_id=_id).first()
