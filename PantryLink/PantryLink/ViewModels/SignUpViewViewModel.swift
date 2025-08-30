//
//  SignUpViewViewModel.swift
//  PantryLink
//
//  Created by Naisha Singh on 8/30/25.
//

import Foundation


class SignUpViewViewModel: ObservableObject{
    @Published  var email: String = ""
    @Published  var password: String = ""
    @Published  var firstname: String = ""
    @Published  var lastname: String = ""
    @Published  var username: String = ""
    @Published  var phonenumber: String = ""
    
    init(){}
    
    func SignUp() {
        guard validate() else{
            return
        }
        //HERE ADD OUR OWN VERSION OF "Auth.auth create user..."
        //self?.insertUserRecord(id: userId)
        
        
    }
    
    private func insertUserRecord(id: String){
        let newUser = User(id: id,
                           firstname: firstname,
                           lastname: lastname,
                           email: email,
                           username: username,
                           password: password,
                           phonenumber: phonenumber,)
        
        
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
            let jsonData = try JSONEncoder().encode(newUser)
            
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
        
        // now insert into database
        
        private func validate() -> Bool{
            //makes sure that the user imputs somthing for each thing
            guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
                  !password.trimmingCharacters(in: .whitespaces).isEmpty,
                  !firstname.trimmingCharacters(in: .whitespaces).isEmpty,
                  !lastname.trimmingCharacters(in: .whitespaces).isEmpty,
                  !username.trimmingCharacters(in: .whitespaces).isEmpty else {
                return false
            }
            
            //makes sure that email contains an "@" and a "."
            guard email.contains("@") && email.contains(".") else {
                return false
            }
            
            //makes sure that password has at least 6 characters
            guard password.count >= 6 else {
                return false
            }
            
            return true
        }
    }
