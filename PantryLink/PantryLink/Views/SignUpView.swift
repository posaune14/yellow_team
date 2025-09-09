//
//  SignUpView.swift
//  PantryLink
//
//  Created by Naisha Singh on 6/7/25.
//

import SwiftUI

struct SignUpView: View {
    //navigation
    @Binding var path: NavigationPath
    
    //check volunteerview lines 200 - 208
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
    @State var alert_message = false
    @State var show_alert = false
    
    //@Binding var path: NavigationPath
    
    
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
                    TextField("First Name", text: $first_name)
                    TextField("Last Name", text: $last_name)
                    TextField("Username", text: $username)
                    TextField("Email", text: $email)
                    TextField("Phone Number (Optional)", text: $phone_number)
                }
                Section(header: Button(action: {
                    guard !username.isEmpty, !password.isEmpty, !first_name.isEmpty, !last_name.isEmpty, !phone_number.isEmpty, !email.isEmpty else {
                        empty_field = true
                        return
                    }
                    
                    let new_user = User(firstname: first_name, lastname: last_name, email: email, username: username, password: password, phonenumber: phone_number)
                    
                        signUp(user: new_user)

                    //path.removeLast()
                    //path.append("Home")
                    })  {
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
//        #Preview {
//            SignUpView(path:path)
//        }

