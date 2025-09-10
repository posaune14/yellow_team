//
//  SignInViewModel.swift
//  PantryLink
//
//  Created by Nupur on 8/5/25.
//


import Foundation
extension SignInView {
    //allows you to edit the properties of another view/class in a different structure, lets us edit aler_message in this context
    
    func register_user(user: User){
        guard let url = URL(string: "http://127.0.0.1:5000/auth/log_in") else //change url
        { return }
        
        //request: takes inputed data, changes it to json, and sends it to the database
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //confirm POST
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) {
                data, response, error in
                if let error = error{
                    DispatchQueue.main.async {
                        self.alert_message = "Failed to send feedback: \(error.localizedDescription)" //alert_message not set up?
                        self.show_alert = true
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { //is 200 correct? might change
                    DispatchQueue.main.async {
                        self.alert_message = "Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? 500)"  //500 or -1?
                        self.show_alert = true
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
    
    

