from flask_restful import Resource  #, reqparse
from models.location import LocationModel


class LocationList(Resource):
    def get(self):
        return {
            "locations":
            [location.json() for location in LocationModel.query.all()]
        }
