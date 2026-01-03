//
//  SignUpView2.swift
//  PantryLink
//
//  Created by Naisha Singh on 10/4/25.
//

import SwiftUI
import UserNotifications

struct SignUpView: View {
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
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        ZStack {
            // Background that adapts to dark mode
            Rectangle()
                .fill(Colors.flexibleWhite)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading){
                    Text("Create Your Account")
                        .font(.title)
                        .foregroundColor(Colors.flexibleBlack)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: isIPad ? 500 : .infinity)
                .padding(20)
                
                VStack(alignment: .leading){
                    Spacer()
                        .frame(height: 5)
                    Text("Please enter your details to Sign Up")
                        .foregroundColor(Colors.flexibleDarkGray)
                    Spacer()
                        .frame(height:25)
                    Text("Sign Up")
                        .font(.title)
                        .foregroundColor(Colors.flexibleOrange)
                        .fontWeight(.bold)
                    Spacer()
                        .frame(height: 27)
                    TextField("Username", text: $username)
                        .foregroundColor(Colors.flexibleBlack)
                        .padding()
                        .background(Colors.flexibleWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Colors.flexibleOrange, lineWidth: 1.5)
                        )
                    Spacer()
                        .frame(height: 15)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .foregroundColor(Colors.flexibleBlack)
                        .padding()
                        .background(Colors.flexibleWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Colors.flexibleOrange, lineWidth: 1.5)
                        )
                    Spacer()
                        .frame(height: 15)
                    TextField("First Name", text: $first_name)
                        .foregroundColor(Colors.flexibleBlack)
                        .padding()
                        .background(Colors.flexibleWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Colors.flexibleOrange, lineWidth: 1.5)
                        )
                    Spacer()
                        .frame(height: 15)
                    TextField("Last Name", text: $last_name)
                        .foregroundColor(Colors.flexibleBlack)
                        .padding()
                        .background(Colors.flexibleWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Colors.flexibleOrange, lineWidth: 1.5)
                        )
                    Spacer()
                        .frame(height: 15)
                    TextField("Email", text: $email)
                        .foregroundColor(Colors.flexibleBlack)
                        .padding()
                        .background(Colors.flexibleWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Colors.flexibleOrange, lineWidth: 1.5)
                        )
                    Spacer()
                        .frame(height: 15)
                    // SwiftUI does not have a built-in phone number formatter or masked text field as of iOS 17. You need to manually format the input, as in the previous implementation.
                    TextField("Phone Number (Optional)", text: Binding(
                        get: {
                            phone_number
                        },
                        set: { newValue in
                            // Allow only numeric input and format as (111)111-1111
                            let digits = newValue.filter { $0.isWholeNumber }
                            let maxLength = 10
                            let limited = digits.prefix(maxLength)
                            var formatted = ""
                            if limited.count > 0 {
                                formatted += "("
                                formatted += limited.prefix(3)
                            }
                            if limited.count > 3 {
                                formatted += ")"
                                formatted += limited.dropFirst(3).prefix(3)
                            }
                            if limited.count > 6 {
                                formatted += "-"
                                formatted += limited.dropFirst(6)
                            }
                            phone_number = formatted
                        }
                    ))
                    .keyboardType(.numberPad)
                    .foregroundColor(Colors.flexibleBlack)
                    .padding()
                    .background(Colors.flexibleWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Colors.flexibleOrange, lineWidth: 1.5)
                    )
                    Spacer()
                        .frame(height:60)
                    
                    Button(action: {
                        Task{
                            guard !username.isEmpty, !password.isEmpty, !first_name.isEmpty, !last_name.isEmpty, !email.isEmpty else {
                                empty_field = true
                                alert_message = "Please fill in all required fields"
                                show_alert = true
                                return
                            }
                            
                            // Create user data dictionary instead of User object to avoid conflicts
                            let userData = User(
                                username: username,
                                password: password,
                                first_name: first_name,
                                last_name: last_name,
                                email: email,
                                phone_number: phone_number
                            )
                            
                            // Call your signup function
                            let loggedIn = await signUp(user: userData)
                            
                            if (loggedIn == true){
                                // Store user data in UserManager (without password)
                                let userToStore = User(
                                    username: userData.username,
                                    password: "", // Don't store password
                                    first_name: userData.first_name,
                                    last_name: userData.last_name,
                                    email: userData.email,
                                    phone_number: userData.phone_number
                                )
                                UserManager.shared.setUser(userToStore)
                                isLoggedIn = true
                            }
                        }
                        
                    }) {
                        Text("Sign Up")
                            .frame(width: isIPad ? 500 : 350, height: 40)
                            .font(.system(size: 27, weight: .bold))
                            .background(Colors.flexibleOrange)
                            .foregroundColor(Colors.flexibleWhite)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: isIPad ? 500 : .infinity)
                .padding(20)
                
                HStack(spacing: 0){
                    Text("Already have an account?")
                        .foregroundStyle(Colors.flexibleBlack)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.leading,30)
                        .fontWeight(.bold)
                    
                    Button("Sign In") {
                        print("Sign in button pressed")
                        path.removeLast() // Go back to sign in view
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Colors.flexibleOrange)
                    .fontWeight(.bold)
                    .padding(.trailing,36)
                }
            }
        }
    }
}


/*#Preview {
    SignUpView(path: .constant(NavigationPath()))
}*/
