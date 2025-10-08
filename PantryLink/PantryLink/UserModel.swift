//
//  User_model.swift
//  PantryLink
//
//  Created by Nupur on 8/20/25.
//

import Foundation

struct User: Codable {
    // form 1 fields
    var username: String
    var password: String
    
    
    var alert_message: String
    var show_alert: Bool
}
