from flask_cors import CORS
from flask import Flask

def create_app():
    #temperary name of project
    app = Flask("Foodbank project")
    CORS(app)