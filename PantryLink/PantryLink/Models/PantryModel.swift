//
//  PantryModel.swift
//  PantryLink
//
//  Created by Jared Sinai Hernandez Adame on 10/13/25.
//

import Foundation

struct Pantry: Codable, Identifiable {
    let _id: String
    let name: String
    let stock: [PantryItem]?
    let address: String?
    let stream: [StreamAlert]?
    var id: String {_id}
}

struct PantryItem: Codable, Identifiable{
    let name: String
    let current: Int
    let full: Int
    let type: String
    let ratio: Double
    var id: String{name}
}

struct StreamAlert: Codable, Identifiable{
    let date: String
    let message: String
    var id: String {message}
}
