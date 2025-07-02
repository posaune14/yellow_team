from .volunteer_routes import volunteer_routes

def init_routes(app):
    app.register_blueprint(volunteer_routes, url_prefix="/volunteer")
