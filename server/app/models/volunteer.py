from flask_pymongo import PyMongo

class volunteer_model:
    def __init__(self, mongo: PyMongo):
        self.collection = mongo.cx["test"]["volunteers"]

    def create_volunteer(self, first_name, last_name, date_of_birth, email, phone_number, zipcode, roles, availability, emergency_name, emergency_number, verified):
        volunteer_data = {
            "first_name": first_name,
            "last_name": last_name, 
            "date_of_birth": date_of_birth,
            "email": email,
            "phone_number": phone_number, 
            "zipcode": zipcode,
            "roles": roles,
            "availability": availability,
            "emergency_name": emergency_name, 
            "emergency_number": emergency_number,
            "verified": verified,
        }
        result = self.collection.insert_one(volunteer_data)
        return str(result.inserted_id)
    
    def find_volunteer_by_id(self, id):
        return list(
            self.collection.aggregate(
                [
                    {
                        "$match": {"_id": id}},

                    {
                        "$project": {
                            "_id": 0,
                        }
                    }

                ]
            )
        )
    
    def update_volunteer(self, volunteer_id, update_data):
        result = self.collection.update_one({"_id": volunteer_id}, {"$set": update_data})
        return result

    def delete_volunteer(self, id):
        result = self.collection.delete_one({"_id": id})
        return result 