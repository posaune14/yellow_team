//
//  StockItemView.swift
//  PantryLink
//
//  Created by Jared Sinai Hernandez Adame on 10/14/25.
//
import SwiftUI

struct StockItemView: View {
    let pantryName: String
    let itemName: String
    let current: Int
    let full: Int
    let type: String
    let ratio: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                .shadow(radius: 10)
            
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Text(pantryName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        print("directions button clicked")
                    }) {
                        HStack(spacing: 4) {
                            Text("Directions")
                                .font(.callout)
                            Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                .font(.caption)
                        }
                        .padding(6)
                        .background(Color.white)
                        .cornerRadius(6)
                        .foregroundColor(.black)
                    }
                }
                
                Text("\(ratio, format: .percent) Capacity")
                    .font(.title3)
                    .foregroundColor(ratio < 0.5 ? .red : .green)
                
                Text("Top Items:")
                    .font(.subheadline)
                
                HStack(spacing: 6) {
                    makeTag(itemName)
                    makeTag("Tomato Soup")
                    makeTag("Pasta")
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity) // stretch to screen width
        .padding(.horizontal)       // keep nice side spacing
        .padding(.vertical, 6)
    }
    
    // Tag builder to reduce repetition
    func makeTag(_ text: String) -> some View {
        Text(text)
            .font(.caption2)
            .lineLimit(1)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 214/255, green: 214/255, blue: 214/255))
            )
    }
}

#Preview {
    StockItemView(
        pantryName: "Flemmington Pantry",
        itemName: "Canned Beans",
        current: 3,
        full: 10,
        type: "Cans",
        ratio: 0.3
    )
}
//VStack{
//    RoundedRectangle(cornerRadius: 15)
//        .fill(Color.white)
//        .frame(width:325, height:110)
//        .overlay(
//            VStack{
//                Text(pantry.name)
//                    .bold()
//                    .font(.title2)
//                Text("\(pantry.stock)% Capacity")
//                  /*  if pantry.stock < 50 {
//                        .foregroundColor(.red)
//                } else {
//                    .foregroundColor(.green)
//                    }*/
//                    .foregroundColor(pantry.stock < 50 ? .red : .green) //shorthand if kinda like js
//                    .font(.caption)
//                
//                HStack{
//                    ForEach(pantry.items, id: \.self){ item in
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(red: 214/255, green: 214/255, blue: 214/255))
//                            .frame(width: 75, height: 30)
//                            .overlay(
//                                Text(item)
//                                        .scaledToFit()
//                                
//                            )
//                    }
//                }
//            }
//        )
//}
