from .volunteer_routes import volunteer_routes
from .pantry_routes import pantry_routes

def init_routes(app):
    app.register_blueprint(volunteer_routes, url_prefix="/volunteer")
    app.register_blueprint(pantry_routes, url_prefix="/pantry")