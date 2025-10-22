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
        VStack{
            Text(pantryName).fontWeight(.bold)
            Text(itemName)
            Text("\(current)")
            Text("\(full)")
            Text("\(type)")
            Text("\(ratio, format:.percent)")
        }
    }
}
