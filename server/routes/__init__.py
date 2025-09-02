from .volunteer_routes import volunteer_routes
from .user_routes import user_routes
from .auth_routes import auth_routes

def init_routes(app):
    app.register_blueprint(volunteer_routes, url_prefix="/volunteer")
    app.register_blueprint(user_routes, url_prefix="/user")
    app.register_blueprint(auth_routes, url_prefix="/auth")
