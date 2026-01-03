//
//  AccountView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 1/2/26.
//

import SwiftUI

struct AccountView: View {
    @Binding var path: NavigationPath
    @State private var showAlert = false
    var body: some View {
        NavigationStack(path: $path){
                
            VStack(){
                Text("Account Information")
                    .font(.title)
                    .padding(.bottom, 20)
                Text("Username")
                RoundedRectangle(cornerRadius: 20)
                    .fill()
                    .stroke(Color.flexibleDarkGray, lineWidth: 5)
                    .frame(width: 300, height: 50)
                    .foregroundStyle(.flexibleLightGray)
                
                Text("First Name")
                RoundedRectangle(cornerRadius: 20)
                    .fill()
                    .stroke(Color.flexibleDarkGray, lineWidth: 5)
                    .frame(width: 300, height: 50)
                    .foregroundStyle(.flexibleLightGray)
                
                Text("Last Name")
                RoundedRectangle(cornerRadius: 20)
                    .fill()
                    .stroke(Color.flexibleDarkGray, lineWidth: 5)
                    .frame(width: 300, height: 50)
                    .foregroundStyle(.flexibleLightGray)
                
                Text("Email")
                RoundedRectangle(cornerRadius: 20)
                    .fill()
                    .stroke(Color.flexibleDarkGray, lineWidth: 5)
                    .frame(width: 300, height: 50)
                    .foregroundStyle(.flexibleLightGray)
                
                Text("Phone Number")
                RoundedRectangle(cornerRadius: 20)
                    .fill()
                    .stroke(Color.flexibleDarkGray, lineWidth: 5)
                    .frame(width: 300, height: 50)
                    .foregroundStyle(.flexibleLightGray)
                
                
                Button{print("Log Out")}label:{
                    RoundedRectangle(cornerRadius: 20)
                        .fill()
                        .stroke(Color.flexibleDarkGray, lineWidth: 5)
                        .frame(width: 300, height: 50)
                        .foregroundStyle(Color.flexibleLightGray)
                        .padding(.top, 50)
                        .overlay(Text("Log Out")
                                .padding(.top, 50)
                                .font(.title3)
                                .bold(true)
                                .foregroundColor(.black)
                        )
                }
                Button{
                    showAlert = true
                }
                label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill()
                        .stroke(Color(red: 216/255, green: 82/255, blue: 82/255), lineWidth: 5)
                        .frame(width: 300, height: 50)
                        .foregroundStyle(Color(red: 255/255, green: 103/255, blue: 103/255))
                        .padding(.top, 10)
                        .overlay(Text("Delete Account")
                                .padding(.top, 10)
                                .font(.title3)
                                .bold(true)
                                .foregroundColor(.black)
                        )
                }
                .alert("Delete Account", isPresented: $showAlert) {
                    Button("Delete", role: .destructive){
                        print("Delete Account")
                    }
                    Button("Cancel", role: .cancel){}
                } message: {
                    Text("Are you sure you want to delete your account? This action is permanent.")
                }
                    
                
                
                
                
                
                
                Spacer()
            }
        }
    }
}

#Preview {
    AccountView(path: .constant(NavigationPath()))
}
