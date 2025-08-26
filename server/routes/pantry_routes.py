from flask import Blueprint, jsonify, current_app, request
from app.models.pantry import pantry_model
from bson import ObjectId

pantry_routes = Blueprint("pantry_routes", __name__)