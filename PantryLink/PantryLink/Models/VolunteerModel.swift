//
//  VolunteerModel.swift
//  PantryLink
//
//  Created by Michael Youtz on 8/5/25.
//

import Foundation

struct Volunteer: Codable {
    //form 1 data fields
    let first_name: String
    let last_name: String
    let date_of_birth: String
    let email: String
    let phone_number: String
    let zipcode: String
    
    //form 2 data fields
    let roles: String
    let availability: String
    let emergency_name: String
    let emergency_number: String
}
