//
//  SignInViewModel.swift
//  PantryLink
//
//  Created by Nupur on 8/5/25.
//


import Foundation
extension SignInView {
    //allows you to edit the properties of another view/class in a different structure, lets us edit aler_message in this context
    
    enum LoginResult {
        case success
        case failure(String)
    }
    
    func login_user(authData: AuthData) async -> LoginResult {
        guard let url = URL(string: "https://yellow-team.onrender.com/auth/log_in") else {
            return .failure("Invalid server URL")
        }
        
        //request: takes inputed data, changes it to json, and sends it to the database
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //confirm POST
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(authData)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure("Unable to connect to server")
            }
            
            if httpResponse.statusCode == 200 {
                // Parse user data from response
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let userDatabase = json["user_database"] as? [String: Any] {
                    // Create User object from response
                    if let username = userDatabase["username"] as? String,
                       let first_name = userDatabase["first_name"] as? String,
                       let last_name = userDatabase["last_name"] as? String,
                       let email = userDatabase["email"] as? String,
                       let phone_number = userDatabase["phone_number"] as? String {
                        let user = User(
                            username: username,
                            password: "", // Don't store password
                            first_name: first_name,
                            last_name: last_name,
                            email: email,
                            phone_number: phone_number
                        )
                        // Store user data
                        UserManager.shared.setUser(user)
                    }
                }
                return .success
            } else if httpResponse.statusCode == 401 {
                // Parse error message from response
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let error = json["error"] as? String {
                    return .failure(error)
                }
                return .failure("Incorrect username or password")
            } else {
                return .failure("Unable to sign in. Please try again.")
            }
        }
        
        catch{
            print("error uploading user data: \(error.localizedDescription)")
            return .failure("Network error. Please check your connection and try again.")
        }
    }
}



//class LoginViewModel: ObservableObject {
//    @Published var email:String = ""
//    @Published var password:String = ""
//    @Published var errorMessage:String = ""
//    
//    init() {}
//    func login() {
//        guard validate() else{
//            return
//            
//        }
//        
//        //try log in
//        //Auth.auth().signIn(withEmail: email, password: password)
//        
//}
//    private func validate () -> Bool {
//        errorMessage = ""
//        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
//              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
//            
//            errorMessage = "Please fill in all fields."
//            return false
//        }
//        
//        
//        guard email.contains("@") && email.contains(".") else {
//            errorMessage = "Please enter valid email."
//            return false
//                        
//        }
//        
//        return true
//            
//    }
//}
//    
    
    

