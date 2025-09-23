from flask import Blueprint, jsonify, current_app, request
from app.models.pantry import pantry_model
from bson import ObjectId
from flask_bcrypt import Bcrypt

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
        username = data.get("username", email)  # Use email as username if not provided

        # Hash the password
        bcrypt = Bcrypt(current_app)
        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

        new_pantry = pantry_model(current_app.mongo)
        response = new_pantry.create_pantry(name, address, email, phone_number, hashed_password, username)

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
        }
        
        # Only include stock if it's provided
        if "stock" in data:
            update_data["stock"] = data["stock"]
        if "stream" in data:
            update_data["stream"] = data["stream"]

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

@pantry_routes.route("/info/<string:pantry_id>", methods=["GET"])
def get_pantry_info(pantry_id):
    """Get pantry information (name, address, email, phone)"""
    try:
        pantry_id = ObjectId(pantry_id)
        new_pantry = pantry_model(current_app.mongo)
        pantry_info = new_pantry.get_pantry_info(pantry_id)
        
        if pantry_info:
            return jsonify(pantry_info), 200
        else:
            return jsonify({"message": "Pantry not found"}), 404
            
    except Exception as e:
        return jsonify({"message": "Error getting pantry info", "error": str(e)}), 400

@pantry_routes.route("/<string:pantry_id>/stream", methods=["POST"])
def post_stream(pantry_id):
    try:
        pantry_id = ObjectId(pantry_id)
        data = request.get_json()
        message = data.get("message")
        if not message or not isinstance(message, str):
            return jsonify({"message": "Missing or invalid message"}), 400
        new_pantry = pantry_model(current_app.mongo)
        updated_stream = new_pantry.post_stream_message(pantry_id, message)
        if updated_stream is None:
            return jsonify({"message": "Pantry not found"}), 404
        return jsonify({"stream": updated_stream}), 200
    except Exception as e:
        return jsonify({"message": "Error appending stream", "error": str(e)}), 400

@pantry_routes.route("/<string:pantry_id>/stream/<int:index>", methods=["DELETE"])
def delete_stream_item(pantry_id, index):
    try:
        pantry_id = ObjectId(pantry_id)
        new_pantry = pantry_model(current_app.mongo)
        updated_stream = new_pantry.delete_stream_item(pantry_id, index)
        if updated_stream is None:
            return jsonify({"message": "Pantry not found"}), 404
        return jsonify({"stream": updated_stream}), 200
    except Exception as e:
        return jsonify({"message": "Error deleting stream item", "error": str(e)}), 400

# Inventory management routes
@pantry_routes.route("/<string:pantry_id>/inventory", methods=["GET"])
def get_inventory(pantry_id):
    """Get all inventory items for a pantry"""
    try:
        pantry_id = ObjectId(pantry_id)
        new_pantry = pantry_model(current_app.mongo)
        inventory = new_pantry.get_all_inventory(pantry_id)
        
        return jsonify({"inventory": inventory}), 200
        
    except Exception as e:
        return jsonify({"message": "Error getting inventory", "error": str(e)}), 400

@pantry_routes.route("/<string:pantry_id>/inventory", methods=["POST"])
def add_inventory_item(pantry_id):
    """Add a new inventory item to the pantry"""
    try:
        data = request.get_json()
        pantry_id = ObjectId(pantry_id)
        
        # Validate required fields
        required_fields = ["name", "current", "full", "type"]
        for field in required_fields:
            if field not in data:
                return jsonify({"message": f"Missing required field: {field}"}), 400
        
        new_pantry = pantry_model(current_app.mongo)
        success = new_pantry.add_inventory_item(pantry_id, data)
        
        if success:
            return jsonify({"message": "Item added successfully"}), 201
        else:
            return jsonify({"message": "Failed to add item"}), 400
            
    except Exception as e:
        return jsonify({"message": "Error adding inventory item", "error": str(e)}), 400

@pantry_routes.route("/<string:pantry_id>/inventory/<string:item_name>", methods=["PUT"])
def update_inventory_item(pantry_id, item_name):
    """Update an inventory item's quantities"""
    try:
        data = request.get_json()
        pantry_id = ObjectId(pantry_id)
        
        # Validate required fields
        if "current" not in data or "full" not in data:
            return jsonify({"message": "Missing current or full quantity"}), 400
        
        new_pantry = pantry_model(current_app.mongo)
        success = new_pantry.update_inventory_item(pantry_id, item_name, data)
        
        if success:
            return jsonify({"message": "Item updated successfully"}), 200
        else:
            return jsonify({"message": "Item not found or failed to update"}), 404
            
    except Exception as e:
        return jsonify({"message": "Error updating inventory item", "error": str(e)}), 400

@pantry_routes.route("/<string:pantry_id>/inventory/<string:item_name>", methods=["DELETE"])
def delete_inventory_item(pantry_id, item_name):
    """Remove an inventory item from the pantry"""
    try:
        pantry_id = ObjectId(pantry_id)
        new_pantry = pantry_model(current_app.mongo)
        success = new_pantry.delete_inventory_item(pantry_id, item_name)
        
        if success:
            return jsonify({"message": "Item deleted successfully"}), 200
        else:
            return jsonify({"message": "Item not found or failed to delete"}), 404
            
    except Exception as e:
        return jsonify({"message": "Error deleting inventory item", "error": str(e)}), 400