//
//  Stream.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/28/25.
//

import SwiftUI

struct StreamView: View {
//    private let pantries : [Pantry] = [
//        Pantry(_id:"68ed1581783104e82a2790e9",name: "Princeton Mobile", stock: [], address:"1234 main street", stream:[StreamAlert(date:"23 March", message:"New Food available!"), StreamAlert(date:"23 March", message:"New Food available!")]),
//        Pantry(_id:"68ed1581783104e82a2790e9",name: "Princeton Mobile", stock: [], address:"1234 main street", stream:[]),
//    ]
    
    @StateObject var streamViewViewModel = StreamViewViewModel()
    @State var pantries: [Pantry]?
    
    var body: some View {
        ZStack {
            //new colors I created for stock are in dark mode branch, so make sure I (or you) add them
            RoundedRectangle(cornerRadius: 10)
                .fill(.stockDarkTan)
                .frame(width: 350, height: 700)
                .shadow(radius: 10)
            ScrollView{
                VStack(spacing: 10){
                    Text("Stream")
                        .bold()
                        .foregroundColor(.black)
                        .font(.title)
                    
                    if pantries != nil {
                        ForEach(pantries ?? []) {pantry in
                            ForEach(pantry.stream ?? []){alert in
                                PantryAlertView(pantryName:pantry.name, message:alert.message, date: alert.date)
                            }
                            
                        }
                    }else {
                        Text("No alerts at the moment. Please come back at a later time!")
                    }
                }
                .padding()
                .frame(width:325)
            }
            .frame(width:325, height: 675)
        }.task{
            // If request succeeds we get pantries otherwise we get nil and error is ignored
            pantries = try? await streamViewViewModel.getStreams().pantries
        }
    }
    
}

#Preview {
    StreamView(streamViewViewModel: StreamViewViewModel(), pantries: [
        Pantry(_id:"68ed1581783104e82a2790e9",name: "Princeton Mobile", stock: [], address:"1234 main street", stream:[
            StreamAlert(date: "10/25/2023", message: "Hi world")
        ])
    ])
}

