from flask import Flask
from app import create_app


if __name__ == "__main__": 
    print("Starting the server...")
    app = create_app()
    @app.route("/")
    def hello_world():
        return "<p>Hello, World!</p>"
    
    @app.route("/")
    def test():
        return "<p>Refwljbnfn</p>"
    app.run(port=3000, debug=True)