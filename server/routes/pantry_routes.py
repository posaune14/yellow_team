from flask import Blueprint, jsonify, current_app, request
#These lines should "register the blueprint"
from flask import Flask
from flask_bcrypt import Bcrypt
from app.models.pantry import PantryModel
pantry_routes = Blueprint("pantry_routes", __name__)

app = Flask(__name__)


#This is the GET endpoint
@pantry_routes.route("/", methods=["GET"])

#getting pantrys in database
def get_pantrys():
    
    return "<p>returning pantrys</p>"


#A post route for posting the pantrys into the database
@pantry_routes.route("/create", methods=["POST"])
def post_pantrys(): 
   
    #try takes the data and puts it into variables
    try: 
        data = request.get_json()
        password = data["password"]
        username = data["username"]
        pantry_name = data["pantry_name"]
        pantry_email = data["pantry_email"]
        phone_number = data["phone_number"]

        bcrypt = Bcrypt(current_app)
        hashed_password = bcrypt.generate_password_hash(password).decode("utf-8")
        #creating an object from UserModel
        new_pantry = PantryModel(current_app.mongo)
        
        #creates the new user
        response = new_pantry.create_user(pantry_name, pantry_email, phone_number, username, hashed_password)
    
    #Checks to make sure no errors occur and break code
    except Exception as e:
        #if error occurs, then it send a messege to the user
        return jsonify({"message": "Error creating account", "error": str(e)}), 400
    
    #returns to the client
    return jsonify(
        {
            "_id": response 
        }
    ), 201