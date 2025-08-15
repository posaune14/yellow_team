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
        
            NavigationView {
                ZStack {
                    Color(red: 238/255, green: 222/255, blue: 215/255)
                            .ignoresSafeArea()
                VStack {
                    HStack{
                        Button{print("home button clicked")}
                        label:{Text("Home")
                            .bold()}
                            
                            .padding()
                            .foregroundColor(.stockOrange)
                            .cornerRadius(25)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.flexibleBlack, lineWidth: 4).fill(.clearBlack)
                            )
                        Button {print("volunteer button clicked")} label: {Text("Volunteer").bold()}
                            .padding()
                            .foregroundColor(.stockOrange)
                            .cornerRadius(25)                         .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.flexibleBlack, lineWidth: 4).fill(.clearBlack)
                            )
                        Button {print("order button clicked")} label: {Text("Order").bold()}
                            .padding()
                            .foregroundColor(.stockOrange)
                            .cornerRadius(25)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.flexibleBlack, lineWidth: 4).fill(.clearBlack)
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
