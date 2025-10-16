//
//  StockItemView.swift
//  PantryLink
//
//  Created by Jared Sinai Hernandez Adame on 10/14/25.
//
import SwiftUI

struct StockItemView:View {
    let pantryName: String
    let itemName: String
    let current: Int
    let full: Int
    let type: String
    let ratio: Double
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0))
                .frame(width: 350, height: 175)
            VStack{
                        Text(pantryName).fontWeight(.bold)
                        Text(itemName)
                        Text("\(current)")
                        Text("\(full)")
                        Text("\(type)")
                        Text("\(ratio, format:.percent)")
                    }
                
        }
//
    }
}
#Preview {
    StockItemView(
        pantryName: "Main Pantry",
        itemName: "Canned Beans",
        current: 3,
        full: 10,
        type: "Cans",
        ratio: 0.3
    )
}
