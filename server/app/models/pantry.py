from flask_pymongo import PyMongo
from datetime import datetime

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
            "stream": []
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
        # Use a simple projection; convert ObjectId to string at the route level
        return self.collection.find_one(
            {"username": username},
            {"username": 1, "password": 1, "_id": {"$toString": "$_id"}},
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
            {"name": 1, "address": 1, "email": 1, "phone_number": 1, "username": 1, "stream": 1, "_id": 0}
        )
        return pantry

    def post_stream_message(self, pantry_id, message: str):
        """Post a message to the pantry's stream and return the updated stream."""
        now = datetime.now().strftime("%m/%d/%Y %I:%M %p")
        result = self.collection.update_one(
            {"_id": pantry_id},
            {"$push": {"stream": {"date": now, "message": message}}}
        )
        if result.matched_count == 0:
            return None
        pantry = self.collection.find_one({"_id": pantry_id}, {"stream": 1, "_id": 0})
        return pantry.get("stream", [])

    def delete_stream_item(self, pantry_id, index: int):
        """Delete a stream item by index and return the updated stream."""
        # First unset the array element at index, then pull nulls
        unset_result = self.collection.update_one(
            {"_id": pantry_id},
            {"$unset": {f"stream.{index}": 1}}
        )
        if unset_result.matched_count == 0:
            return None
        self.collection.update_one({"_id": pantry_id}, {"$pull": {"stream": None}})
        pantry = self.collection.find_one({"_id": pantry_id}, {"stream": 1, "_id": 0})
        return pantry.get("stream", [])

    # --- Volunteer Schedules ---
    def get_schedule_for_date(self, pantry_id, date_key: str):
        """Return schedule array for a specific date key (YYYY-MM-DD)."""
        pantry = self.collection.find_one(
            {"_id": pantry_id},
            {f"schedules.{date_key}": 1, "_id": 0}
        )
        schedules = pantry.get("schedules", {}) if pantry else {}
        return schedules.get(date_key, [])

    def save_schedule_for_date(self, pantry_id, date_key: str, schedule_array):
        """Save schedule array for a specific date key (YYYY-MM-DD)."""
        result = self.collection.update_one(
            {"_id": pantry_id},
            {"$set": {f"schedules.{date_key}": schedule_array}}
        )
        return result.matched_count > 0

    def delete_schedule_for_date(self, pantry_id, date_key: str):
        """Delete schedule for a specific date key (YYYY-MM-DD)."""
        result = self.collection.update_one(
            {"_id": pantry_id},
            {"$unset": {f"schedules.{date_key}": ""}}
        )
        return result.matched_count > 0

    def cleanup_past_schedules(self, pantry_id, today_key: str) -> int:
        """Unset any schedules with a key older than today_key (YYYY-MM-DD). Returns number removed."""
        pantry = self.collection.find_one({"_id": pantry_id}, {"schedules": 1})
        if not pantry:
            return 0
        schedules = pantry.get("schedules")
        if not isinstance(schedules, dict):
            return 0
        to_remove = [k for k in schedules.keys() if isinstance(k, str) and k < today_key]
        if not to_remove:
            return 0
        unset_spec = {f"schedules.{k}": "" for k in to_remove}
        self.collection.update_one({"_id": pantry_id}, {"$unset": unset_spec})
        return len(to_remove)
    
    def get_pantries(self):
        """Swift stream view functionality"""
        return list(
            self.collection.aggregate([
                {
                    "$addFields":{ #Calculate ratios
                        "stock":{ #replace old stock array with new stock array
                            "$map":{ #lets you transform element in array
                                "input":"$stock", #current stock array
                                "as":"s", #s represents each item in stock array
                                "in":{ #defines what each new element will look like
                                    "name": "$$s.name",
                                    "current":"$$s.current",
                                    "full":"$$s.full",
                                    "type":"$$s.type",
                                    "ratio":{
                                        "$round":[
                                            {"$divide":["$$s.current", "$$s.full"]},
                                            1
                                        ]
                                    }
                                }
                            }
                        }
                    }
                },
                {
                    "$addFields":{ #sort by descending ratio
                        "stock":{
                            "$sortArray":{
                                "input":"$stock",
                                "sortBy":{
                                    "ratio": -1
                                }
                            }
                        }
                    }
                },
                {
                    "$project":{
                        "_id": {"$toString": "$_id"},
                        "name":1,
                        "address":1,
                        "email":1,
                        "phone_number":1,
                        "stock":{"$slice":["$stock", 3]}, #only get the top 3 ratio items
                        "stream":1,
                    }
                }
            ])
        )
