from flask import Blueprint, jsonify, current_app, request
from flask_bcrypt import Bcrypt
from app.models.user import UserModel
from flask_jwt_extended import (
    create_access_token,
    jwt_required,
    get_jwt_identity,
    create_refresh_token,
)

auth_routes = Blueprint("auth_routes", __name__)

@auth_routes.route("/log_in", methods=["POST"])

def log_in(): 
    try:
        #getting username and password from frontend request 
        data = request.get_json()
        username = data["username"]
        password = data["password"]

        #user is an object of UserModel class that gives access to method "find_user_by_username" that allows it to access any username/password in database 
        user = UserModel(current_app.mongo)
        user_database = user.find_user_by_username(username)

        #if username wrong, returns error message of incorrect username 
        if not user_database:
            return jsonify({"error": "Error incorrect username"}), 401
        bcrypt = Bcrypt(current_app)
        # bcrypt is a package we use to "hash" password when account is created so that we cannot see their password
        # retrieve hashed password from database for login purposes
        hashed_password = user_database["password"]

        is_valid = bcrypt.check_password_hash(hashed_password, password)
        if is_valid and user_database["username"].lower() == username.lower():
            user_database.pop("password", None) 

            return jsonify(
                {
                    "user_database": user_database,
                }
            ), 200
        else:
            return jsonify({"error": "Error incorrect password or username"}), 401
    except Exception as error:
        print(error)
        return jsonify({"error": str(error)}), 400
    
@auth_routes.route("/log_out")
def log_out():
    return jsonify({"message": "List will be here"})

@auth_routes.route("/refresh/", methods=["POST"])
@jwt_required(refresh=True) #ensures only refresh tokens can be used
def refresh():
    try:
        # get the identity from the refresh token
        user_id = get_jwt_identity()

        #create a new access token
        new_access_token = create_access_token(identity=user_id)

        return jsonify({"access_token": new_access_token}), 200
    except Exception as error:
        return jsonify({"error": str(error)}), 400

        
        
