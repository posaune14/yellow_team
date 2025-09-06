from flask_pymongo import PyMongo

class PantryModel:
    def __init__(self, mongo: PyMongo):
        #syntax from mongo stating which colection in the database that we want to use
        self.collection = mongo.cx["test"]["pantrys"]
        

    def create_user(self, password, pantry_name, pantry_email, phone_number, address): 
        pantry_data = {
            "password": password, 
            "pantry_name": pantry_name, 
            "pantry_email": pantry_email, 
            "phone_number": phone_number, 
            "address": address,
        }
        #Sends the pantrys data into the database
        result = self.collection.insert_one(pantry_data)
        #Returns the id of the document as a string
        return str(result.inserted_id)
    