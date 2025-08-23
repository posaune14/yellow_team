//
//  VolunteerModel.swift
//  PantryLink
//
//  Created by Michael Youtz on 8/5/25.
//

import Foundation

struct Volunteer: Codable {
    //form 1 data fields
    var first_name: String
    var last_name: String
    var date_of_birth: String
    var email: String
    var phone_number: String
    var zipcode: String
    
    //form 2 data fields
    var roles: String
    var availability: String
    var emergency_name: String
    var emergency_number: String
    
    var alert_message: String
    var show_alert: Bool
}
