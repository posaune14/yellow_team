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
                    .fill(Color.gray.opacity(0.067))
                
            VStack(spacing:8) {
                    //message header with name of pantry
                    Text(pantryName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(date)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack{
                    
                        Text("Announcement: ")
                            .font(.title2)
                            .fontWeight(.bold)
                            
                        
                       
                            Text(message)
                                .font(.title3)
    //                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                }.frame(maxWidth:.infinity,alignment: .leading)
                
                
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
