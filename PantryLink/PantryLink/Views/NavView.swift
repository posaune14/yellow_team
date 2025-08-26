//
//  NavView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/28/25.
//

import SwiftUI

struct NavView: View {
    @State private var searchText = ""
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color(red: 238/255, green: 222/255, blue: 215/255)
                .ignoresSafeArea()
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
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.flexibleBlack, lineWidth: 4).fill(.clearBlack)
                    )
                    Button(action: {
                        path.append("Volunteer")
                    }){Text("Volunteer")}/*.navigationDestination(isPresented: $go_to_volunteer){
                        VolunteerView(path: $path)
                    }*/
                        .bold()
                        .padding()
                        .foregroundColor(.stockOrange)
                        .cornerRadius(25)
                        .background(
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
                    Button(action: {
                        path.append("Stock")
                    }){
                        Text("Stock")
                    }.bold().padding().foregroundColor(.stockOrange).cornerRadius(25).background(RoundedRectangle(cornerRadius: 25).stroke(.flexibleBlack, lineWidth: 4).fill(.clearBlack))
                }
            }
        }
    }
}
    
/*#Preview {
    NavView()
}
*/
