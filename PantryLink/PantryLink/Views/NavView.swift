//
//  NavView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/28/25.
//

import SwiftUI

struct NavView: View {
    @State private var searchText = ""
    @State var go_to_volunteer = false
    @State private var path = NavigationPath()
    
    var body: some View {
        ZStack {
            Color(red: 238/255, green: 222/255, blue: 215/255)
                .ignoresSafeArea()
            NavigationStack(path: $path){
                VStack {
                    HStack{
                        Button(action: {
                            print("home button clicked")
                        }) {
                            Text("Home")
                        }
                        .bold()
                        .padding()
                        .foregroundColor(Color(red: 236/255, green: 120/255, blue: 93/255))
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.customBlack, lineWidth: 4)
                        )
                        Button(action: {
                            go_to_volunteer = true
                            path.append("Volunteer")
                        }){Text("Volunteer")}/*.navigationDestination(isPresented: $go_to_volunteer){
                            VolunteerView(path: $path)
                        }*/
                            .bold()
                            .padding()
                            .foregroundColor(Color(red: 236/255, green: 120/255, blue: 93/255))
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.customBlack, lineWidth: 4)
                            )
                        Button {print("order button clicked")} label: {Text("Order").bold()}
                            .padding()
                            .foregroundColor(Color(red: 236/255, green: 120/255, blue: 93/255))
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.customBlack, lineWidth: 4)
                            )
                    }.navigationDestination(for: String.self) {value in
                        if value == "Volunteer" {
                            VolunteerView(path: $path)
                        } else {
                            HomeView()
                        }
                    }
                }
            }
        }
    }
}
    
#Preview {
    NavView()
}
