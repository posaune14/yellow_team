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
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack{
            Text("Create Account")
                .multilineTextAlignment(.center)
                .font(.system(size: 58, weight: .bold))
                .foregroundColor(.maroonWhite)
                .frame(maxWidth: .infinity, alignment: .center)
            Form{
                Section(header: Text("Login Details").foregroundStyle(.flexibleBlack).fontWeight(.bold)){
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }
                Section(header:Text("Account Information").foregroundStyle(.flexibleBlack).fontWeight(.bold)){
                    TextField("First Name", text: $firstname)
                    TextField("Last Name", text: $lastname)
                    TextField("Email (Optional", text: $email)
                    TextField("Phone Number (Optional)", text: $phonenumber)
                }
                Section(header: Button(action: {
                    path.removeLast()
                    path.append("Home")
                }){
                    Text("Sign Up")
                    // Rectangle()
                    // .fill(Color(red: 255/255, green: 178/255, blue: 102/255))
                    //.frame(width: 350, height: 80)
                    
                }
                .frame(width: 350, height: 80)
                .font(.system(size: 30, weight: .bold))
                .background(.flexibleOrange)
                .tint(.white)
                .cornerRadius(15)){}
                
                /*Section(header:HStack{
                    Text("Already have an account?").foregroundStyle(.flexibleBlack).fontWeight(.bold)
                    Button("Sign In"){
                        print("Sign in button pressed")
                    }
                        .buttonStyle(.plain)
                        .foregroundStyle(.flexibleBlue)
                        .fontWeight(.bold)
                }){
                    
                }*/
            }
        }
    }
}
        /*#Preview {
            SignUpView()
        }
*/
