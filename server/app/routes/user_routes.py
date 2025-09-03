from flask import Blueprint, jsonify, current_app, request
#Check these lines of code (lines 4+)
#These lines should "register the blueprint"
from flask import Flask
from flask_bcrypt import Bcrypt
#import cloudinary 
#from cloudinary.utils import cloudinary_url
#from flask_jwt_extended import jwt_required
from app.models.user import UserModel
#from app.models.judge import JudgeModel - we don't have this, what does it do and do we need it??
#from bson import ObjectId
user_routes = Blueprint("user_routes", __name__)

app = Flask(__name__)


#This is the GET endpoint
@user_routes.route("/", methods=["GET"])

#getting users in database
def get_users():
    
    return "<p>returning users</p>"


#A post route for posting the users into the database
@user_routes.route("/create", methods=["POST"])
def post_users(): 
   
    #try takes the data and puts it into variables
    try: 
        data = request.get_json()
        password = data["password"]
        username = data["username"]
        first_name = data["first_name"]
        last_name = data["last_name"]
        email = data["email"]
        phone_number = data["phone_number"]

        bcrypt = Bcrypt(current_app)
        hashed_password = bcrypt.generate_password_hash(password).decode("utf-8")

        #creating an object from UserModel
        new_user = UserModel(current_app.mongo)
        
        #creates the new user
        response = new_user.create_user(first_name, last_name, email, phone_number, username, hashed_password)
    
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