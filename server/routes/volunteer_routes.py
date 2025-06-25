from flask import Blueprint, jsonify, current_app, request
from app.models.volunteer import volunteer_model
from bson import ObjectId

volunteer_routes = Blueprint("volunteer_routes", __name__)

# Define a simple route inside this blueprint

@volunteer_routes.route("/create", methods=["POST"])
def create_volunteer():
    data = request.get_json()
    
    
    new_volunteer = volunteer_model(current_app.mongo)

    response = new_volunteer.create_volunteer()
