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
    @State private var isLoading = false
    
    @State var empty_field = false
    //@StateObject var viewModel = SignInViewModel()
    @Binding var path: NavigationPath
    @Binding var isLoggedIn: Bool
    @Binding var isGuest: Bool
    
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
            
            Group {
                if isIPad {
                    HStack {
                        Spacer()
                        signInContent
                            .frame(maxWidth: 600)
                        Spacer()
                    }
                } else {
                    signInContent
                }
            }
            
            // ProgressView overlay when loading
            if isLoading {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        
                        Text("Signing in...")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.8))
                    )
                }
            }
        }
        .alert("Sign In Error", isPresented: $show_alert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alert_message)
        }
    }
    
    private var signInContent: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Sign In To Your Account")
                    .font(.title)
                    .foregroundColor(Colors.flexibleBlack)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .fontWeight(.bold)
                Spacer()
                    .frame(height: 20)
                Text("Please enter your details to Sign In")
                    .foregroundColor(Colors.flexibleDarkGray)
                Spacer()
                    .frame(height: 50)
                //Text("Sign In")
                    //.font(.title)
                    //.foregroundColor(.orange)
                    //.fontWeight(.bold)
                Spacer()
                    .frame(height: 40)
                TextField("Username", text: $username)
                    .foregroundColor(Colors.flexibleBlack)
                    .padding()
                    .background(Colors.flexibleWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Colors.flexibleOrange, lineWidth: 1.5)
                            )
                Spacer()
                    .frame(height: 25)
                SecureField("Password", text: $password)
                    .foregroundColor(Colors.flexibleBlack)
                    .padding()
                    .background(Colors.flexibleWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Colors.flexibleOrange, lineWidth: 1.5)
                            )
            }
            .frame(maxWidth: isIPad ? 500 : .infinity)
            .padding(20)
            Spacer()
                .frame(height: 100)
            Button(action: {
                Task{
                    print("Sign In")
                    guard !username.isEmpty, !password.isEmpty else {
                        empty_field = true
                        alert_message = "Please fill in all fields"
                        show_alert = true
                        print("Fill in all fields")
                        return
                    }
                    
                    // Show loading overlay
                    isLoading = true
                    
                    // Create user object for authentication
                    let authData = AuthData(
                        username: username,
                        password: password
                    )
                    
                    // Call your authentication function here
                    let result = await login_user(authData: authData)
                    
                    // Hide loading overlay
                    isLoading = false
                    
                    switch result {
                    case .success:
                        // Mark as logged in - ContentView will show MainTabView
                        isLoggedIn = true
                    case .failure(let errorMessage):
                        // Show error alert
                        alert_message = errorMessage
                        show_alert = true
                    }
                    
                }
                
            }) {
                Text("Sign In")
                    .frame(width: isIPad ? 500 : 350, height: 40)
                    .font(.system(size: 27, weight: .bold))
                    .background(Colors.flexibleOrange)
                    .foregroundColor(Colors.flexibleWhite)
                    .cornerRadius(10)
            }
            .disabled(isLoading)
            
            // Guest Sign In Button
            Button(action: {
                // Navigate to home as guest
                isLoggedIn = true
                isGuest = true
            }) {
                Text("Continue as Guest")
                    .frame(width: isIPad ? 500 : 350, height: 40)
                    .font(.system(size: 20, weight: .semibold))
                    .background(Colors.flexibleLightGray)
                    .foregroundColor(Colors.flexibleBlack)
                    .cornerRadius(10)
            }
            .disabled(isLoading)
            
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
                        path.append("SignUp") // Go back to sign in view
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Colors.flexibleOrange)
                    .fontWeight(.bold)
                    .padding(27)
            }
        }
        .frame(maxWidth: isIPad ? 600 : .infinity, maxHeight: .infinity)
    }
}
