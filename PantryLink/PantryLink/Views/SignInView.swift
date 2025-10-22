//
//  SignInView2.swift
//  PantryLink
//
//  Created by Naisha Singh on 10/6/25.
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
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sign In To Your Account")
                .font(.title)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity,alignment: .leading)
                .fontWeight(.bold)
            Spacer()
                .frame(height: 20)
            Text("Please enter your details to Sign In")
                .foregroundColor(.gray)
            Spacer()
                .frame(height: 50)
            //Text("Sign In")
                //.font(.title)
                //.foregroundColor(.orange)
                //.fontWeight(.bold)
            Spacer()
                .frame(height: 40)
            TextField("Username", text: $username)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange, lineWidth: 1.5)
                        )
            Spacer()
                .frame(height: 25)
            SecureField("Password", text: $password)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange, lineWidth: 1.5)
                        )
        }
        .padding(20)
        Spacer()
            .frame(height: 100)
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
                .frame(width: 350, height: 40)
                .font(.system(size: 27, weight: .bold))
                .background(.orange) // Changed from .flexibleOrange
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        Spacer()
            .frame(height:30)
        HStack(spacing: 2){
            //Text("Don't Have Account?")
                //.foregroundStyle(.black) // Changed from .flexibleBlack
                //.frame(maxWidth: .infinity,alignment: .leading)
                //.padding()
                //.fontWeight(.bold)
                    Button("Don't Have An Account? Create One Today") {
                        print("Sign up button pressed")
                        path.removeLast() // Go back to sign in view
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.orange) // Changed from .flexibleBlue
                    .fontWeight(.bold)
                    .padding(27)
                }
    }
}

//#Preview {
//    SignInView(path: .constant(NavigationPath()))
//}
