from flask_pymongo import PyMongo

class Volunteer_Model:
    def __init__(self, mongo: PyMongo):
        self.collection = mongo.cx["test"]["volunteers"]