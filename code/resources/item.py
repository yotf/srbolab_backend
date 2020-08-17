import sqlite3
from flask_restful import Resource, reqparse
from flask_jwt import jwt_required
from models.item import ItemModel


class Item(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('price',
                        type=float,
                        required=True,
                        help="Price cannot be blank!")

    parser.add_argument('store_id',
                        type=int,
                        required=True,
                        help="store_id cannot be blank!")

    @jwt_required
    def get(self, name):
        item = ItemModel.find_by_name(name)
        if item:
            return item.json(), 200
        else:
            return {"message": "Item '{}' not found".format(name)}, 404

    def post(self, name):
        if ItemModel.find_by_name(name):
            return {
                "message": "Item '{}' already exists".format(data["name"])
            }, 400

        data = Item.parser.parse_args()
        item = ItemModel(name=name, **data)

        try:
            item.save_to_db()
        except:
            return {"message": "An error occurred inserting the item."}, 500

        return item.json(), 201

    def delete(self, name):
        item = ItemModel.find_by_name(name)

        if item:
            try:
                item.delete_from_db()
            except:
                return {
                    "message": "An error occurred inserting the item."
                }, 500
        else:
            return {
                "message": "Item you're trying to delete does not exist"
            }, 400

        return {"message": "item {} deleted".format(name)}

    def put(self, name):
        data = Item.parser.parse_args()
        item = ItemModel.find_by_name(name)
        if not item:
            item = ItemModel(name=name, **data)
        else:
            item.price = data["price"]
            item.store_id = data['store_id']

        try:
            item.save_to_db()
        except:
            return {
                "message":
                "An Error occured while saving item '{}' to database".format(
                    name)
            }, 500

        return item.json(), 200


class ItemList(Resource):
    def get(self):
        return {"items": [item.json() for item in ItemModel.query.all()]}
