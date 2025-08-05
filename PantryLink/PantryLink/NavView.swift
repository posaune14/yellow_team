//
//  NavView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/28/25.
//

import SwiftUI

struct NavView: View {
    @State private var searchText = ""
    var body: some View {
        ZStack {
            Color(red: 238/255, green: 222/255, blue: 215/255)
                       .ignoresSafeArea()
            NavigationView {
                VStack {
                    HStack{
                        Button{print("home button clicked")}
                        label:{Text("Home")
                            .bold()}
                            
                            .padding()
                            .foregroundColor(Color(red: 236/255, green: 120/255, blue: 93/255))
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 4)
                            )
                        Button {print("volunteer button clicked")} label: {Text("Volunteer").bold()}
                            .padding()
                            .foregroundColor(Color(red: 236/255, green: 120/255, blue: 93/255))
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 4)
                            )
                        Button {print("order button clicked")} label: {Text("Order").bold()}
                            .padding()
                            .foregroundColor(Color(red: 236/255, green: 120/255, blue: 93/255))
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.black, lineWidth: 4)
                            )
                    }
                }
            }
        }
    }
}
    
#Preview {
    NavView()
}
