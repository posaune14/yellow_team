from .volunteer_routes import volunteer_routes
from .pantryauth_route import pantryauth_route
from .user_routes import user_routes

def init_routes(app):
    app.register_blueprint(volunteer_routes, url_prefix="/volunteer")
    app.register_blueprint(pantryauth_route, url_prefix="/pantry_login")
    app.register_blueprint(user_routes, url_prefix="/user")

    
