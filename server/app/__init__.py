import os
import warnings

from flask_cors import CORS
from flask import Flask
from flask_jwt_extended import JWTManager
from app.routes import init_routes
from app.config import init_config

def create_app():
    #temperary name of project
    app = Flask("Food Insecurity Co-op")
    CORS(app, resources={r"/*": {"origins": "*", "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"]}})

    # Initialize JWT
    # Secret must come from the environment in production (set JWT_SECRET_KEY
    # on Render). The fallback keeps local dev working but is not safe to deploy.
    jwt_secret = os.getenv("JWT_SECRET_KEY")
    if not jwt_secret:
        warnings.warn("JWT_SECRET_KEY env var not set - using insecure dev fallback")
        jwt_secret = "insecure-dev-only-secret"
    app.config['JWT_SECRET_KEY'] = jwt_secret
    jwt = JWTManager(app)
    
    init_config(app)
    init_routes(app)
    return app