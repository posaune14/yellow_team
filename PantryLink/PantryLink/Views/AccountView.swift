//
//  AccountView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 1/2/26.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        HStack(){
            Button {
                print("back")
            } label: {
                Image(systemName: "arrowshape.backward.fill")
            }
            .foregroundStyle(.black)
            .padding()

            Text("Account Information")
                .font(.title2)
            Spacer()
        }
        VStack(){
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
            
            
            
            RoundedRectangle(cornerRadius: 20)
                .fill()
                .stroke(Color.flexibleDarkGray, lineWidth: 5)
                .frame(width: 300, height: 50)
                .foregroundStyle(Color.flexibleLightGray)
                .padding(.top, 50)
                .overlay(Button{print("log out")}label:{Text("Log Out")
                        .padding(.top, 50)
                        .font(.title3)
                        .bold(true)
                        .foregroundColor(.black)
                }
                )
            
                RoundedRectangle(cornerRadius: 20)
                .fill()
                .stroke(Color(red: 216/255, green: 82/255, blue: 82/255), lineWidth: 5)
                .frame(width: 300, height: 50)
                .foregroundStyle(Color(red: 255/255, green: 103/255, blue: 103/255))
                .padding(.top, 10)
                .overlay(Button{print("delete account")}label:{Text("Delete Account")
                        .padding(.top, 10)
                        .font(.title3)
                        .bold(true)
                        .foregroundColor(.black)
                }
                                     
                )
            
                
            
            
                
            Spacer()
        }
    }
}

#Preview {
    AccountView()
}
