//
//  Stream.swift
//  PantryLink
//
//  Created by Jared Sinai Hernandez Adame on 10/13/25.
//

import Foundation

struct GetResponseData: Decodable {
    let message: String
    let pantries: [Pantry]
}
