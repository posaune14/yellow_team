//
//  StockView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/29/25.
//
import SwiftUI
/*
class Pantry {
    let name = "Princeton Mobile"
    let stock = 78
    let items = ["Beans", "Soup", "Vegis"]
}
 */
struct Pantry {
    let name: String
    let stock: Int
    let items: [String]
}
let pantries = [
    Pantry(name: "Princeton Mobile", stock: 78, items: ["Beans", "Soup", "Vegis"]),
    Pantry(name: "TASK", stock: 72, items: ["Rice", "Pasta", "Milk"]),
    Pantry(name: "Franklin", stock:66 , items: ["Eggs", "Cereal", "Juice"]),
    Pantry(name: "idk man", stock: 50, items: ["Beans", "Soup", "Vegis"]),
    Pantry(name: "idk", stock: 42, items: ["Rice", "Pasta", "Milk"]),
    Pantry(name: "anotha one", stock:22 , items: ["Eggs", "Cereal", "Juice"])
]
//https://www.programiz.com/swift-programming/classes-objects
//https://developer.apple.com/documentation/swiftui/foreach
struct StockView: View{
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.stockLightTan)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 15)
                .fill(.stockDarkTan)
                .frame(width:350, height:650)
                .shadow(radius: 10)
            VStack{
                Text("Stock")
                    .foregroundColor(.stockRed)
                    .bold()
                    .font(.title)
                ScrollView{
                    VStack{
                        ForEach(pantries, id: \.name){ pantry in //this ForEach thing was fairly easy to do with the data structs
                            VStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.flexibleWhite)
                                    .frame(width:325, height:110)
                                    .overlay(
                                        VStack{
                                            Text(pantry.name)
                                                .bold()
                                                .font(.title2)
                                            Text("\(pantry.stock)% Capacity")
                                              /*  if pantry.stock < 50 {
                                                    .foregroundColor(.red)
                                            } else {
                                                .foregroundColor(.green)
                                                }*/
                                                .foregroundColor(pantry.stock < 50 ? .red : .green) //shorthand if kinda like js
                                                .font(.caption)
                                            
                                            HStack{
                                                ForEach(pantry.items, id: \.self){ item in
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(.flexibleLightGray)
                                                        .frame(width: 75, height: 30)
                                                        .overlay(
                                                            Text(item)
                                                                    .scaledToFit()
                                                            
                                                        )
                                                }
                                            }
                                        }
                                    )
                            }
                            
                            
                        }
                    }
                    
                }
                .frame(width: 340, height: 560)
            }
        }
    }
}
                                            
#Preview {
    StockView()
}
