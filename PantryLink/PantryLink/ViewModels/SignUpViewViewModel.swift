//
//  SignUpViewViewModel.swift
//  PantryLink
//
//  Created by Naisha Singh on 8/30/25.
//

import Foundation


extension SignUpView{    
    
    private func signUp(user: User){
        
        
        // Add new code
        
        //Checks for URL
        guard let url = URL(string: "http://127.0.0.1:3000") else
        {return}
        
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
            
            //sending messege to server
            URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let error = error{
                    print(error)
//                    DispatchQueue.main.async {
//                        self.alert_message = "Failed to send feedback: \(error.localizedDescription)"
//                        self.show_alert = true
//                    }
                    return
                }
                //waiting for server to respond after we sent the message
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else{
                    DispatchQueue.main.async{
                        //self.alert_message = "Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                        //self.show_alert = true
                        print("Failed with status code")
                    }
                    return
                }
            }.resume()
        }
        
        catch{
            print("error uploading user data")
        }
        
    }
}
