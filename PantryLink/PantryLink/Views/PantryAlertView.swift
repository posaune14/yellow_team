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
            
            
            //message of pantry aligned to the left
            
                
        ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 25)
                .fill(Colors.flexibleWhite.opacity(0.85))
                
            VStack(spacing:8) {
                    //message header with name of pantry
                    Text(pantryName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Colors.flexibleBlack)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(date)
                        .font(.caption2)
                        .foregroundColor(Colors.flexibleDarkGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Colors.flexibleWhite)
                    .frame(width: 250, height: 70)
                    .overlay(
                        Text(message)
                            .padding(1)
                        .font(.caption)
                        .foregroundColor(Colors.flexibleBlack)
//                            .frame(maxWidth: .infinity, alignment: .leading)
                        )
                
                
                
                }.padding()
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

#Preview {
    PantryAlertView(pantryName: "Pantry 1", message: "hello ", date: "10/14/25")
}
