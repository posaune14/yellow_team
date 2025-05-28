from flask import Flask



if __name__ == "__main__": 
    print("Starting the server...")
    app = Flask("FoodSecurityServer")
    @app.route("/")
    def hello_world():
        return "<p>Hello, World!</p>"
<<<<<<< Updated upstream
    
=======
    @app.route("/")
    def test():
        return "<p>Refwljbnfn</p>"
>>>>>>> Stashed changes
    app.run(port=3000, debug=True)