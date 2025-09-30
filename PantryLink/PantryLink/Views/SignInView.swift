//
//  SignInView.swift
//  PantryLink
//
//  Created by Nupur on 6/3/25.
//

import SwiftUI

struct SignInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State var alert_message = ""
    @State var show_alert = false
    
    @State var empty_field = false
    //@StateObject var viewModel = SignInViewModel()
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("Sign In")
                .font(.system(size: 58, weight: .bold))
                .foregroundColor(Color(red: 175/255, green: 0/255, blue: 0/255))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
            
            Form {
                // User Info Section
                Section(header: Text("User Info")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(username.isEmpty && password.isEmpty && empty_field ? .red : .black)) {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                }
                
                // Sign In Section
                Section {
                    Button(action: {
                        print("Sign In")
                        guard !username.isEmpty, !password.isEmpty else {
                            empty_field = true
                            alert_message = "Please fill in all fields"
                            show_alert = true
                            return
                        }
                        
                        // Create user object for authentication
                        let userData = [
                            "username": username,
                            "password": password
                        ]
                        
                        // Call your authentication function here
                        authenticateUser(with: userData)
                        
                        // Navigate to home on successful sign in
                        path.append("Home")
                    }) {
                        Text("Sign In")
                            .frame(width: 350, height: 80)
                            .font(.system(size: 30, weight: .bold))
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .padding()
                    }
                    
                    
                }
                
                // Sign Up Prompt Section
                Section(header: Text("Don't have an account?")
                            .font(.system(size: 20, weight: .bold))) {
                    // Empty section body
                }
                
                Section {
                    Button(action: {
                        path.append("SignUp")
                    }) {
                        Text("Create One Today")
                            .frame(width: 250, height: 50)
                            .font(.system(size: 20, weight: .bold))
                            .background(Color(red: 250/255, green: 250/255, blue: 250/255))
                            .foregroundColor(Color(red:128/255, green: 0/255, blue: 0/255))
                            .cornerRadius(15)
                            .padding()
                    }
                }
            }
            .background(Color.white)
            .alert(isPresented: $show_alert) {
                Alert(title: Text("Error"), message: Text(alert_message), dismissButton: .default(Text("OK")))
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.white.ignoresSafeArea())
    }
    
    // Helper function for authentication
    private func authenticateUser(with userData: [String: String]) {
        // Implement your authentication logic here
        // This replaces the problematic User object creation
        print("Authenticating user: \(userData["username"] ?? "")")
    }
}

#Preview {
    SignInView(path: .constant(NavigationPath()))
}
