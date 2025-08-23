from flask import Blueprint, jsonify, current_app, request
#Check these lines of code (lines 4+)
#These lines should "register the blueprint"
from flask import Flask
from app.models.user import UserModel
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
    user = UserModel()
    user.create_user("password", "joesmith1", "Joe", "Smith", "joesmith@gmail.com", 1234567890)
    return "<p>posting users</p>"
