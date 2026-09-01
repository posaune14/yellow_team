from app import create_app


if __name__ == "__main__":
    print("Starting the server...")
    app = create_app()

    @app.route("/")
    def hello_world():
        return "<p>PantryLink server is running.</p>"

    app.run(port=3000, debug=True)
