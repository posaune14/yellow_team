//
//  SignUpViewViewModel.swift
//  PantryLink
//
//  Created by Naisha Singh on 8/30/25.
//

import Foundation


extension SignUpView{    
    
     func signUp(user: User) async -> (success: Bool, message: String?){
        
        
        // Add new code
        //Checks for URL
        guard let url = URL(string: "\(API.baseURL)/user/create") else
         {
            print("Error with URL")
            return (false, "Invalid URL configuration")
        }
        
        //takes inputed data and creates a request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //doing something
        do{
            //turn it into JSON
            let jsonData = try JSONEncoder().encode(user)
            
            //attatching JSON data to the message that is sent to the server
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { 
                return (false, "Invalid server response")
            }
            
            if httpResponse.statusCode == 201 {
                return (true, nil)
            } else if httpResponse.statusCode == 409 {
                // Username already exists
                if let json = try? JSONDecoder().decode([String: String].self, from: data),
                   let message = json["message"] {
                    return (false, message)
                }
                return (false, "Username is already taken. Please choose a different username.")
            } else {
                // Other errors
                if let json = try? JSONDecoder().decode([String: String].self, from: data),
                   let message = json["message"] {
                    return (false, message)
                }
                return (false, "Failed to create account. Please try again.")
            }
        }
        catch{
            print("error uploading user data: \(error)")
            return (false, "Network error. Please check your connection and try again.")
        }
    }
}
