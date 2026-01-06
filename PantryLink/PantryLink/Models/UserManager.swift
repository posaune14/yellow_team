//
//  UserManager.swift
//  PantryLink
//
//  Created for managing logged-in user data
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var currentUser: User?
    
    private init() {
        loadUser()
    }
    
    func setUser(_ user: User) {
        currentUser = user
        saveUser(user)
    }
    
    func clearUser() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: "loggedInUser")
    }
    
    private func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "loggedInUser")
        }
    }
    
    private func loadUser() {
        if let data = UserDefaults.standard.data(forKey: "loggedInUser"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
        }
    }
}

