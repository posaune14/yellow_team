//
//  SignInViewModel.swift
//  PantryLink
//
//  Created by Nupur on 8/5/25.
//


import Foundation
extension SignInView {
    //allows you to edit the properties of another view/class in a different structure, lets us edit aler_message in this context
    
    func login_user(authData: AuthData) async -> Bool{
        guard let url = URL(string: "http://127.0.0.1:3000/auth/log_in") else //change url
        { return false }
        
        //request: takes inputed data, changes it to json, and sends it to the database
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //confirm POST
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(authData)
            request.httpBody = jsonData
            
            let (_, response) = try await URLSession.shared.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse else { return false }
                    return httpResponse.statusCode == 200
        }
        
        catch{
            print("error uploading user data")
            return false
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
    
    

