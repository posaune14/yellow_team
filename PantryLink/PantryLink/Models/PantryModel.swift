//
//  StreamModel.swift
//  PantryLink
//
//  Created by Joshua Sambol on 9/27/25.
//

import Foundation

struct PantryModel: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let email: String
    let phoneNumber: String
    let password: String
    let username: String
    let stream: [StreamEntry]
    let stock: [StockItem]
    
    
    enum id: String, CodingKey {
        case id = "_id"
        case name, address, email, username, stream, stock
        case phoneNumber = "phone_number"
        case password
    }
    
    
    
    init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           
           // Handle ObjectId - it might come as a string or object
           if let objectId = try? container.decode(ObjectId.self, forKey: .id) {
               self.id = objectId.oid
           } else {
               self.id = try container.decode(String.self, forKey: .id)
           }
           
           self.name = try container.decode(String.self, forKey: .name)
           self.address = try container.decode(String.self, forKey: .address)
           self.email = try container.decode(String.self, forKey: .email)
           self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
           self.password = try container.decode(String.self, forKey: .password)
           self.username = try container.decode(String.self, forKey: .username)
           self.stream = try container.decode([StreamEntry].self, forKey: .stream)
           self.stock = try container.decode([StockItem].self, forKey: .stock)
       }
   }
struct StreamEntry: Codable, Identifiable {
    let id = UUID()
    let date: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case date, message
    }
}
struct StockItem: Codable, Identifiable {
    let id = UUID()
    let name: String
    let current: Int
    let full: Int
    let type: String
    
    enum CodingKeys: String, CodingKey {
            case name = "name"
            case current
            case type = "type"
            case full
        }
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            self.full = try container.decodeIfPresent(Int.self, forKey: .full) ?? 0
            self.current = try container.decodeIfPresent(Int.self, forKey: .current) ?? 0
            self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        }
}
struct ObjectId: Codable {
    let oid: String
    
    enum CodingKeys: String, CodingKey {
        case oid = "$oid"
    }
}
struct PantryResponse: Codable {
    let pantrys: [PantryModel]
    let totalCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case pantrys
        case totalCount = "total_count"
    }
}

struct SinglePantryResponse: Codable {
    let pantry: PantryModel
    let success: Bool?
    let message: String?
}
