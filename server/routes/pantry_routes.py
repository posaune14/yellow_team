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
