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
        RoundedRectangle(cornerRadius: 10)
            .fill(.white)
            .frame(width:300, height:150)
            .overlay(
                VStack {
                    Text(pantryName)
                        .bold()
                        .font(.title2)
                        .padding();
                    Text(message)
                        .font(.body)
                    Text("Time: \(date)")
                        .font(.body)
                }
            )
    }
}

//#Preview {
//    PantryAlertView()
//}
