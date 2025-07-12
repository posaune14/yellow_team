from flask_cors import CORS
from flask import Flask
from app.routes import init_routes
from app.config import init_config

def create_app():
    #temperary name of project
    app = Flask("Food Insecurity Co-op")
    CORS(app)
    init_config(app)
    init_routes(app)
    return app