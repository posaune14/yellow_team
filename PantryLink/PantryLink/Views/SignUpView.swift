//
//  SignUpView.swift
//  PantryLink
//
//  Created by Naisha Singh on 6/7/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var username: String = ""
    @State private var phonenumber: String = ""
    
    var body: some View {
        VStack{
            Text("Create Account")
                .multilineTextAlignment(.center)
                .font(.system(size: 58, weight: .bold))
                .foregroundColor(Color(red: 175/255, green: 0/255, blue: 0/255))
                .frame(maxWidth: .infinity, alignment: .center)
            Form{
                Section(header:Text("Login Details")){
                    TextField("Email (Optional)", text: $email)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }
                Section(header:Text("Account Information")){
                    TextField("First Name", text: $firstname)
                    TextField("Last Name", text: $lastname)
                    TextField("Username", text: $username)
                    TextField("Phone Number (Optional)", text: $phonenumber)
                }
                Section(header:Button("Sign Up"){
                    print("sign up button pessed")
                }){
                    // Rectangle()
                    // .fill(Color(red: 255/255, green: 178/255, blue: 102/255))
                    //.frame(width: 350, height: 80)
                    
                }
                .frame(width: 250, height: 65)
                .font(.system(size: 30, weight: .bold))
                .background(Color.orange)
                .tint(.white)
                .cornerRadius(15)
                .frame(maxWidth: .infinity, alignment: .center)
                
                Section(header:HStack{
                    Text("Already have an account?")
                    Button("Sign In"){
                        print("Sign in button pressed")
                    }
                        .buttonStyle(.plain)
                        .foregroundStyle(.blue)
                }){
                    
                }
            }
        }
    }
}
        #Preview {
            SignUpView()
        }
