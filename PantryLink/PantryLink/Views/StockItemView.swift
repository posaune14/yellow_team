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
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0))
                .frame(width: 360, height: 210)
            VStack{
                HStack{
                    Text(pantryName)
                        .fontWeight(.bold)
                        .font(.title3)
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 1.0))
                    Spacer()
                    Button(action: {
                        print("directions button clicked")
                    }) {
                        HStack(spacing: 4) {
                               Text("Directions")
                                   .font(.caption)
                               Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                   .font(.caption)
                           }
                            .padding(6)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(6)
                    }
                }
                    HStack{
                        Text("\(ratio, format:.percent) Capacity")
                            .font(Font.title3)
                            .foregroundColor(Color(red: 0.8, green: 0.3, blue: 0.3, opacity: 1.0))
                        Spacer()
                    }
                    Text("Top Items:")
                    HStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 214/255, green: 214/255, blue: 214/255))
                            .frame(width: 120, height: 30)
                            .overlay(
                                Text(itemName)
                                    .font(.caption2)
                                
                            )
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 214/255, green: 214/255, blue: 214/255))
                            .frame(width: 115, height: 30)
                            .overlay(
                                Text("Frozen Vegis")
                                    .font(.caption)
                                
                            )
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 214/255, green: 214/255, blue: 214/255))
                            .frame(width: 85, height: 30)
                            .overlay(
                                Text("Potatoes")
                                    .font(.caption)
                                
                            )
                    }
                    //                Text(itemName)
                    //                Text("\(current)")
                    //                Text("\(full)")
                    //                Text("\(type)")
                    //                Text("\(ratio, format:.percent)")
                }
                .frame(width: 310)
                
            }
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
