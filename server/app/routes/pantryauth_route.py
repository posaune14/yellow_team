from flask import Blueprint, jsonify, current_app, request
from flask_bcrypt import Bcrypt
from app.models.pantry import pantry_model
from flask_jwt_extended import (
    create_access_token,
    jwt_required,
    get_jwt_identity,
    create_refresh_token
)
#used to convert string to ObjectId
pantryauth_route = Blueprint("pantryauth_route", __name__)

#define a simple route inside this blueprint
#is current_app correct? 
@pantryauth_route.route("/log_in/", methods=["POST"])
def log_in():
    try:
        data=request.get_json()
        username = data["username"]
        password = data["password"]

        pantry = pantry_model(current_app.mongo) #is this correct??? whole section needs to be checked to distinguish between employees and users
        pantry_database = pantry.find_user_by_username(username)
        if not pantry_database:
            return jsonify({"error": "Error incorrect username"}), 401
        
        bcrypt = Bcrypt(current_app)
        #retrieve hashed password from the database
        hashed_password = pantry_database["password"]

        is_valid = bcrypt.check_password_hash(hashed_password, password)
        if is_valid and pantry_database["username"] == username:
            pantry_database.pop("password", None)
            #Generate a token
            access_token = create_access_token(identity=username)
            refresh_token = create_refresh_token(identity=username)
            return jsonify(
                {
                    "pantry_database":pantry_database,
                    "access_token": access_token,
                    "refresh_token": refresh_token,
                }
            )
        else:
            return jsonify({"error": "Error incorrect password or username"}), 401
    except Exception as err:
        return jsonify({"error": str(err)}), 400 
    
@pantryauth_route.route("/log_out")
def log_out():
    return jsonify({"message": "List will be here"}) #what does this mean?

@pantryauth_route.route("/refresh/", methods=["POST"])
@jwt_required(refresh=True) #ensures only refresh tokens can be used
def refresh():
    try: 
        # Get the identity from the refresh token
        user_id = get_jwt_identity()

        #Create a new access token
        new_access_token = create_access_token(identity=user_id)   
        
        return jsonify({"access_token": new_access_token}), 200
    
    except Exception as err:
        return jsonify({"error": str(err)}), 400