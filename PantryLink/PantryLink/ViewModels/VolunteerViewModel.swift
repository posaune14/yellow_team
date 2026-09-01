//
//  VolunteerViewModel.swift
//  PantryLink
//
//  Created by Michael Youtz on 8/5/25.
//

import Foundation
import SwiftUI

// Extension for VolunteerContentView (current implementation)
extension VolunteerContentView {
    //allows you to edit the properties of another view/class in a different structure, so in here, lets us edit alert_message
    
    func check_volunteer_exists(username: String) async -> Bool {
        guard let url = URL(string: "\(API.baseURL)/volunteer/check/\(username)") else {
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return false
            }
            
            // Parse the response
            if let json = try? JSONDecoder().decode([String: Bool].self, from: data),
               let exists = json["exists"] {
                return exists
            }
            
            return false
        } catch {
            print("Error checking volunteer: \(error)")
            return false
        }
    }
    
    func register_volunteer(volunteer: Volunteer, show_success: Binding<Bool>){
        guard let url = URL(string: "\(API.baseURL)/volunteer/create") else
        { return }
        
        //request: takes inputed data, changes it to json, and sends it to the database
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(volunteer)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let error = error{
                    DispatchQueue.main.async {
                        self.alert_message = "Failed to send feedback: \(error.localizedDescription)"
                        self.show_alert = true
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    DispatchQueue.main.async {
                        self.alert_message = "Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                        self.show_alert = true
                    }
                    return
                }
                
                // Success! Show confirmation popup
                DispatchQueue.main.async {
                    show_success.wrappedValue = true
                }
                
            }.resume()
        }
        
        catch{
            DispatchQueue.main.async {
                self.alert_message = "Error uploading volunteer data"
                self.show_alert = true
            }
        }
    }
}

// Legacy extension for VolunteerView (keeping for compatibility)
extension VolunteerView {
    func register_volunteer(volunteer: Volunteer){
        guard let url = URL(string: "\(API.baseURL)/volunteer/create") else
        { return }
        
        //request: takes inputed data, changes it to json, and sends it to the database
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(volunteer)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let error = error{
                    DispatchQueue.main.async {
                        self.alert_message = "Failed to send feedback: \(error.localizedDescription)"
                        self.show_alert = true
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    DispatchQueue.main.async {
                        self.alert_message = "Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                        self.show_alert = true
                    }
                    return
                }
                
                // Success - for legacy view, just show a message
                DispatchQueue.main.async {
                    self.alert_message = "Thank you! Your volunteer application has been successfully submitted."
                    self.show_alert = true
                }
                
            }.resume()
        }
        
        catch{
            DispatchQueue.main.async {
                self.alert_message = "Error uploading volunteer data"
                self.show_alert = true
            }
        }
    }
}

