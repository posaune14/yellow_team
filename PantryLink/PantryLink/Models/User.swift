//
//  Created by Naisha Singh on 7/26/25.
//
//
import Foundation

struct User: Codable {
    // form 1 fields
    var username: String
    var password: String
    let first_name: String
    let last_name: String
    let email: String
    let phone_number: String
}

struct AuthData: Codable{
    let username: String
    let password: String
}
