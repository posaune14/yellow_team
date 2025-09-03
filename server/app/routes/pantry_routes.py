from flask import Blueprint, jsonify, current_app, request
from app.models.pantry import pantry_model
from bson import ObjectId

pantry_routes = Blueprint("pantry_routes", __name__)

@pantry_routes.route("/create", methods=["POST"])
def create_pantry():
    try: 
        data = request.get_json()
        name = data["name"]
        address = data["address"]
        email = data["email"]
        phone_number = data["phone_number"]
        password = data["password"]

        new_pantry = pantry_model(current_app.mongo)
        response = new_pantry.create_pantry(name, address, email, phone_number, password)

    except Exception as e:
        return jsonify({"message": "Error creating pantry", "error": str(e)}), 400
    
    return jsonify(
        {
            "_id": response,
        }
    ),201

@pantry_routes.route("/update/<string:pantry_id>", methods=["PUT"])
def update_pantry(pantry_id):
    try:
        data = request.get_json()

        update_data = {
            "name": data["name"],
            "address": data["address"], 
            "email": data["email"],
            "phone_number": data["phone_number"],
            "password": data["password"],
            "stock": data["stock"],
        }

        new_pantry = pantry_model(current_app.mongo)
        response = new_pantry.update_pantry(ObjectId(pantry_id), update_data)   

    except Exception as e:
        return jsonify({"message": "Error updating pantry", "error": str(e)}), 400
    
    return jsonify({"_id": pantry_id}), 200

@pantry_routes.route("/get/<string:pantry_id>", methods=["GET"])
def get_stock(pantry_id):
    try:
        pantry_id = ObjectId(pantry_id)
        new_pantry = pantry_model(current_app.mongo)
        stock = new_pantry.get_stock(pantry_id)

    except Exception as e:
        return jsonify({"message": "Error getting stock", "error": str(e)}), 400
    
    for item in stock:
        return jsonify(item), 200
    #to remove the stock list object being in a list from the aggregate method which returns a list