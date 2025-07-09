from flask_cors import CORS
from flask import Flask
from routes import init_routes

def create_app():
    #temperary name of project
    app = Flask("Foodbank project")
    CORS(app)
    init_routes(app)
    return app