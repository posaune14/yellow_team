from flask_pymongo import PyMongo

class pantry_model: 
    def __init__(self, mongo: PyMongo):
        self.collection = mongo.cx["test"]["pantries"]

    def create_pantry(self, name, address, email, phone_number, password):
        pantry_data = {
            "name": name,
            "address": address, 
            "email": email,
            "phone_number": phone_number,
            "password": password,
        }
        result = self.collection.insert_one(pantry_data)
        return str(result.inserted_id)

    def update_pantry(self, id, update_data):
        result = self.collection.update_one({"_id": id}, {"$set": update_data})
        return result
    
    def get_stock(self, id):
        return list(
            self.collection.aggregate(
                [
                    {
                        "$match": {"_id": id}
                    },
                    {
                        "$project": {
                            "_id": 0,
                            "name": 0,
                            "address": 0,
                            "email": 0, 
                            "phone_number": 0,
                            "password": 0,
                        }
                    }
                ]
            )
        )