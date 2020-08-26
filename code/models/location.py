from db import db


class LocationModel(db.Model):
    __tablename__ = "lokacija"

    lk_id = db.Column(db.Integer, primary_key=True)
    lk_naziv = db.Column(db.String(300))
    lk_naziv_l = db.Column(db.String(30))
    lk_ip = db.Column(db.String(20))
    lk_aktivna = db.Column(db.String(1))

    def __init__(self, naziv, naziv_l, ip, aktivna="D"):
        self.lk_naziv = naziv
        self.lk_naziv_l = naziv_l
        self.lk_ip = ip
        self.lk_aktivna = aktivna

    def json(self):
        return {
            "naziv": self.lk_naziv,
            "naziv_lokativ": self.lk_naziv_l,
            "ip": self.lk_ip,
            "id": self.lk_id
        }

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    @classmethod
    def find_by_id(cls, _id):
        return cls.query.filter_by(lk_id=_id).first()

    @classmethod
    def find_by_ip(cls, ip):
        return cls.query.filter_by(lk_ip=ip).first()

    @classmethod
    def find_by_naziv(cls, naziv):
        return cls.query.filter_by(lk_naziv=naziv).first()
