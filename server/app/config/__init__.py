from flask_pymongo import PyMongo
from dotenv import load_dotenv
import os

load_dotenv()

def init_config(app):
    app.config["MONGO_URI"] = os.getenv("URI")

    mongo = PyMongo(app)
    app.mongo = mongo 
    app.db = mongo.cx["test"]
    try:
        mongo.cx.admin.command("ping")
        print("MongoDB connected")

    except Exception as e:
        print(f"Mongo DB Connection Failed: {e}")
