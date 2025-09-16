from flask_pymongo import PyMongo

class pantry_model: 
    def __init__(self, mongo: PyMongo):
        self.collection = mongo.cx["test"]["pantries"]

    def create_pantry(self, name, address, email, phone_number, password, username=None):
        pantry_data = {
            "name": name,
            "address": address, 
            "email": email,
            "phone_number": phone_number,
            "password": password,
            "username": username or email,  # Use email as username if not provided
        }
        result = self.collection.insert_one(pantry_data)
        return str(result.inserted_id)

    def update_pantry(self, pantry_id, update_data):
        result = self.collection.update_one({"_id": pantry_id}, {"$set": update_data})
        return result
    
    def get_stock(self, pantry_id):
        return (
            self.collection.aggregate(
                [
                    {
                        "$match": {"_id": pantry_id}
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
    def find_user_by_username(self, username):
        return self.collection.find_one(
            {"username": username},
            {
                "_id": {"$toString": "$_id"},
                "username": 1,
                "password": 1,
                
            },
        )
    
    def add_inventory_item(self, pantry_id, item):
        """Add a new inventory item to the pantry"""
        # Use upsert to create the stock array if it doesn't exist
        result = self.collection.update_one(
            {"_id": pantry_id},
            {"$push": {"stock": item}},
            upsert=False
        )
        # If the document exists but stock field doesn't, create it
        if result.matched_count > 0 and result.modified_count == 0:
            # Check if stock field exists
            pantry = self.collection.find_one({"_id": pantry_id}, {"stock": 1})
            if pantry and "stock" not in pantry:
                # Create the stock array with the first item
                result = self.collection.update_one(
                    {"_id": pantry_id},
                    {"$set": {"stock": [item]}}
                )
        return result.modified_count > 0
    
    def update_inventory_item(self, pantry_id, item_name, new_quantities):
        """Update an inventory item's quantities"""
        result = self.collection.update_one(
            {"_id": pantry_id, "stock.name": item_name},
            {"$set": {"stock.$.current": new_quantities["current"], "stock.$.full": new_quantities["full"]}}
        )
        return result.modified_count > 0
    
    def delete_inventory_item(self, pantry_id, item_name):
        """Remove an inventory item from the pantry"""
        result = self.collection.update_one(
            {"_id": pantry_id},
            {"$pull": {"stock": {"name": item_name}}}
        )
        return result.modified_count > 0
    
    def get_all_inventory(self, pantry_id):
        """Get all inventory items for a pantry"""
        pantry = self.collection.find_one(
            {"_id": pantry_id},
            {"stock": 1, "_id": 0}
        )
        return pantry.get("stock", []) if pantry else []
    
    def get_pantry_info(self, pantry_id):
        """Get pantry information (name, address, email, phone)"""
        pantry = self.collection.find_one(
            {"_id": pantry_id},
            {"name": 1, "address": 1, "email": 1, "phone_number": 1, "username": 1, "_id": 0}
        )
        return pantry