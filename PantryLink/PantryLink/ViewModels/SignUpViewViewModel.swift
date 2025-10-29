//
//  SignUpViewViewModel.swift
//  PantryLink
//
//  Created by Naisha Singh on 8/30/25.
//

import Foundation


extension SignUpView{    
    
     func signUp(user: User) async -> Bool{
        
        
        // Add new code
        //Checks for URL
        guard let url = URL(string: "https://yellow-team.onrender.com/user/create") else
         {
            print("Error with URL")
            return false
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
            
            let (_, response) = try await URLSession.shared.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse else { return false }
                    return httpResponse.statusCode == 201
        }
        catch{
            print("error uploading user data")
            return false
        }
    }
}
