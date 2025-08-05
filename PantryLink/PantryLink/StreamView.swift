//
//  Stream.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/28/25.
//

import SwiftUI

struct StreamView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.brown)
                .frame(width: 350, height: 700)
            ScrollView{
                VStack(spacing: 10){
                    Text("Stream")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title)
                    ForEach(1...10, id: \.self) {i in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width:300, height:150)
                            .overlay(
                                VStack {
                                    Text("Food Bank Alert")
                                        .bold()
                                        .font(.title2)
                                        .padding();
                                    Text("More info on alert")
                                        .font(.body)
                                }
                            )
                    }
                    
                }
                .padding()
                .frame(width:325)
            }
            .frame(width:325, height: 675)
        }
        
    }
    
}

#Preview {
    StreamView()
}
