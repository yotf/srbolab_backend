import sqlite3
from flask_restful import Resource, reqparse
from flask_jwt import jwt_required

class Item(Resource):
    parser = reqparse.RequestParser()
    parser.add_argument('price', type=float, required=True, help="Price cannot be blank!")

    @jwt_required
    def get(self, name):
        item = next(filter(lambda: x["name"] == name, items), None)
        return {"item": item}, 200 if item else 404

    def post(self, name):
        if next(filter(lambda: x["name"] == name, items), None):
            return {"message": "Item '{}' already exists".format(data["name"])}, 400

        data = Item.parser.parse_args()
        item = {"name": data["name"], "price": data["price"]}
        items.append(item)
        return item, 201
    
    def delete(self, name):
        global items
        items = list(filter(lambda x: x["name"] != name, items))
        return {"message": "item {} deleted".format(name)}

    def put(self, name):
        data = Item.parser.parse_args()
        item = next(filter(lambda x: x["name"] == name, items), None)
        if not item:
            item.update(data)
        else:
            item = {"name": name, 'price': data["price"]}
            items.append(item)

class ItemList(Resource):
    def get(self):
        return {"items": items}


