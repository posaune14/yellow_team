//
//  SignUpView.swift
//  PantryLink
//
//  Created by Naisha Singh on 6/7/25.
//

import SwiftUI
import UserNotifications

struct SignUpView: View {
    //navigation
    @Binding var path: NavigationPath
    
    //user
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var date_of_birth: String = ""
    @State var email: String = ""
    @State var phone_number: String = ""
    //unfinished
    @State var empty_field = false
    //alert
    @State var alert_message = ""
    @State var show_alert = false
    let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some View {
        VStack{
            Text("Create Account")
                .multilineTextAlignment(.center)
                .font(.system(size: 58, weight: .bold))
                .foregroundColor(.red) // Changed from .maroonWhite to standard color
                .frame(maxWidth: .infinity, alignment: .center)
            
            Form{
                Section(header: Text("Login Details")
                    .foregroundStyle(.black) // Changed from .flexibleBlack
                    .fontWeight(.bold)) {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }
                
                Section(header: Text("Account Information")
                    .foregroundStyle(.black) // Changed from .flexibleBlack
                    .fontWeight(.bold)) {
                    TextField("First Name", text: $first_name)
                    TextField("Last Name", text: $last_name)
                    TextField("Email", text: $email)
                    TextField("Phone Number (Optional)", text: $phone_number)
                }
                
                // Fixed: Moved the button inside a proper Section
                Section {
                    Button(action: {
                        guard !username.isEmpty, !password.isEmpty, !first_name.isEmpty, !last_name.isEmpty, !email.isEmpty else {
                            empty_field = true
                            alert_message = "Please fill in all required fields"
                            show_alert = true
                            return
                        }
                        
                        // Create user data dictionary instead of User object to avoid conflicts
                        let userData = [
                            "firstname": first_name,
                            "lastname": last_name,
                            "email": email,
                            "username": username,
                            "password": password,
                            "phonenumber": phone_number
                        ]
                        
                        // Call your signup function
                        signUpUser(with: userData)
                        
                        // Navigate after successful signup
                        Task {
                            do {
                                try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) }
                            catch {
                                print("Request authorization error")
                            }
                        }
                        path.append("Home")
                    }) {
                        Text("Sign Up")
                            .frame(width: 350, height: 80)
                            .font(.system(size: 30, weight: .bold))
                            .background(.orange) // Changed from .flexibleOrange
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
                
                Section(header: Text("Already have an account?")
                    .foregroundStyle(.black) // Changed from .flexibleBlack
                    .fontWeight(.bold)) {
                        Button("Sign In") {
                            print("Sign in button pressed")
                            path.removeLast()
                        }// Go back to sign in view
                    .buttonStyle(.plain)
                    .foregroundStyle(.blue) // Changed from .flexibleBlue
                    .fontWeight(.bold)
                }
            }
        }
        .alert(isPresented: $show_alert) {
            Alert(
                title: Text("Error"),
                message: Text(alert_message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Helper function for signup
    private func signUpUser(with userData: [String: String]) {
        // Implement your signup logic here
        // This replaces the problematic User object creation
        print("Signing up user: \(userData["username"] ?? "")")
    }
}

/*#Preview {
    SignUpView(path: .constant(NavigationPath()))
}*/
