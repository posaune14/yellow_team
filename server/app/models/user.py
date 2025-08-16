from flask_pymongo import PyMongo

class UserModel:
    def __init__(self, mongo: PyMongo):
        #syntax from mongo stating which colection in the database that we want to use
        self.collection = mongo.cx["test"]["users"]
        

    def create_user(self, password, username, first_name, last_name, email, phone_number): 
        user_data = {
            "password": password, 
            "username": username,
            "first_name": first_name, 
            "last_name": last_name, 
            "email": email, 
            "phone_number": phone_number, 
        }
        #Sends the users data into the database
        result = self.collection.insert_one(user_data)
        #Returns the id of the document as a string
        return str(result.inserted_id)
    
