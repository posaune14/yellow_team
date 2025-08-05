from flask_cors import CORS
from flask import Flask
from routes import init_routes
from .config import init_config

def create_app():
    #temperary name of project
    app = Flask("Foodbank project")
    CORS(app)
    init_config(app)
    init_routes(app)
    return app