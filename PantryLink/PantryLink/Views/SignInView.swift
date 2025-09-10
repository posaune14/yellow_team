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
    
    //unfinished
    @State var empty_field  = false
    //@StateObject var viewModel = SignInViewModel()
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("Sign In")
                //.multilineTextAlignment(.center)
                .font(.system(size: 58, weight: .bold))
                .foregroundColor(Color(red: 175/255, green: 0/255, blue: 0/255))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()

            //HStack {
                //Text("Username")
                    //.font(.system(size: 20))
                    //.foregroundColor(.black)
                    //.padding()
                //Spacer()
                //}
                //RoundedRectangle(cornerRadius: (15))
                //.fill(Color(red: 191/255, green: 191/255, blue: 191/255))
                //.frame(width: 350, height: 100)
                //.ignoresSafeArea()
//            if !viewModel.errorMessage.isEmpty {
//                Text(viewModel.errorMessage)
//                    .foregroundColor(Color.red)
//        
            //}
            
            Form{
                Section(header:Text("User Info").font(.system(size: 20, weight: .bold)).foregroundStyle(username.isEmpty && password.isEmpty && empty_field ? .red: .black)){
                    TextField("Username",text:$username)
                    TextField("Password",text:$password)
                }
                
                    Section(header:Button("Sign In"){
                        print("Sign In")
                        //viewModel.login()
                        guard !username.isEmpty, !password.isEmpty else {
                            empty_field = true
                            return
                            
                        }
                        let user = User(username: username, password: password, alert_message: alert_message, show_alert: show_alert)
                        
                    register_user(user: user)
                Section(header:Button(action: {
                    path.append("Home")
                }){
                    Text("Sign In")
                }
                    
                    .frame(width: 350, height: 80)
                    .font(.system(size: 30, weight: .bold))
                    .background(Color.orange)
                    .cornerRadius(15)
                    .tint(.white)
                    .padding()
                ){
    
                    
                }
                
                
                Section(header:Button("Sign In With Google"){
                    print("Sign In With Google")
                    
            }
                
                .frame(width: 300, height: 60)
                .font(.system(size: 25, weight: .bold))
                .background(Color(red: 248/255, green: 248/255, blue: 248/255))
                .tint(.black)
                .padding()
            ){

                
            }

                    Section(header:Text("Don't have an account?").font(.system(size: 20, weight: .bold))){

                        
                    }
                    .foregroundColor(.black)
                
                    
                
                Section(header:Button(action: {
                    path.append("SignUp")
                }){
                    Text("Create One Today")
                }
                    
                    .frame(width: 250, height: 50)
                    .font(.system(size: 20, weight: .bold))
                    .background(Color(red: 250/255, green: 250/255, blue: 250/255))
                    .cornerRadius(15)
                    .tint(Color(red:128/255, green: 0/255, blue: 0/255))
                    .padding()
                ){
    
                    
                }
                
                
                
                        
        
                
            } //move this and close the form after the creation of the "remember me" and "sign in" buttons
            .background(Color.white) //figure out how to change this so the background will be white
            .alert(isPresented: $show_alert){
                Alert(title: Text("Error"), message: Text(alert_message))
            }
            
            
            
            
//            //HStack {
//                //Text("Password")
//                    //.font(.system(size: 20))
//                    //.foregroundColor(.black)
//                    //.padding()
//                //Spacer()
//            //}
//            //RoundedRectangle(cornerRadius: (15))
//                //.fill(Color(red: 191/255, green: 191/255, blue: 191/255))
//                //.frame(width: 350, height: 100)
//                //.ignoresSafeArea()
//            HStack {
//                Spacer().frame(maxWidth:50)
//                Rectangle()
//                    .fill(Color(red: 191/255, green: 191/255, blue: 191/255))
//                    .frame(width: 20, height: 20)
//                Text("Remember Me")
//                    .font(.system(size: 15))
//                    .foregroundColor(.black)
//                    .padding()
//                Spacer()
//            }
//            Spacer()
//
//            ZStack {
//                Rectangle()
//                    .fill(Color(red: 255/255, green: 178/255, blue: 102/255))
//                    .frame(width: 350, height: 80)
//                
//                Text("Sign In")
//                    .font(.system(size: 30, weight: .bold))
//                    .foregroundColor(.white)
//                
//                
//                
//            }
        .frame(maxHeight: .infinity, alignment: .top) //***aligns VStack containing ALL objects to top center of screen, DO NOT DELETE***
            
        }
    }
}

                
   
/*#Preview {
    SignInView()
}
*/
