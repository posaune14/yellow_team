from flask import Blueprint, jsonify, current_app, request
from app.models.volunteer import volunteer_model
from bson import ObjectId

volunteer_routes = Blueprint("volunteer_routes", __name__)

# Define a simple route inside this blueprint

@volunteer_routes.route("/create", methods=["POST"])
def create_volunteer():
    try:
        data = request.get_json()
        first_name = data["first_name"]
        last_name = data["last_name"]
        date_of_birth = data["date_of_birth"]
        email = data["email"]
        phone_number = data["phone_number"]
        zipcode = data["zipcode"]
        roles = data["roles"]
        availability = data["availability"]
        emergency_name = data["emergency_name"]
        emergency_number = data["emergency_number"]
        
        new_volunteer = volunteer_model(current_app.mongo)

        response = new_volunteer.create_volunteer(first_name, last_name, date_of_birth, email, phone_number, zipcode, roles, availability, emergency_name, emergency_number)

    except Exception as e:
        return jsonify({"message": "Error creating volunteer", "error": str(e)}), 400
    
    return jsonify(
        {
            "_id": response,
        }
    ), 201