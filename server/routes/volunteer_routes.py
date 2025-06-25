from flask import Blueprint, jsonify, current_app, request
from app.models.volunteer import volunteer_model
from bson import ObjectId

volunteer_routes = Blueprint("volunteer_routes", __name__)

# Define a simple route inside this blueprint

