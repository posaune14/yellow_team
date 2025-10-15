//
//  PantryAlertView.swift
//  PantryLink
//
//  Created by Jared Sinai Hernandez Adame on 10/14/25.
//

import SwiftUI

struct PantryAlertView: View {
    let pantryName: String
    let message: String
    let date: String
    var body: some View {
        VStack{
            //message header with name of pantry
            Text(pantryName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            
            //message of pantry aligned to the left
            Text(message)
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
            ZStack{
                
                
                
            }
                
            
            //        RoundedRectangle(cornerRadius: 10)
            //            .fill(.white)
            //            .frame(width:300, height:150)
            //            .overlay(
            //                VStack {
            //                    Text(pantryName)
            //                        .bold()
            //                        .font(.title2)
            //                        .padding();
            //                    Text(message)
            //                        .font(.body)
            //                    Text("Time: \(date)")
            //                        .font(.body)
            //                }
            //            )
        }
    }
}

#Preview {
    PantryAlertView(pantryName: "Pantry 1", message: "hello ", date: "10/14/25")
}
