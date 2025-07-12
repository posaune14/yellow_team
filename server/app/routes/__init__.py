from .volunteer_routes import volunteer_routes
from .user_routes import user_routes

def init_routes(app):
    app.register_blueprint(volunteer_routes, url_prefix="/volunteer")
    app.register_blueprint(user_routes, url_prefix="/user")
