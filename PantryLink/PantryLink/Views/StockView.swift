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



//https://www.programiz.com/swift-programming/classes-objects
//https://developer.apple.com/documentation/swiftui/foreach
struct StockView: View{
    @StateObject var streamViewViewModel = StreamViewViewModel()
    @State var pantries: [Pantry]?
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 15)
                .fill(.stockDarkTan)
                .frame(width:350, height:650)
                .shadow(radius: 10)
            VStack{
                Text("Stock")
                    .foregroundColor(.white)
                    .bold()
                    .font(.largeTitle)
                ScrollView{
                    // Use this spacing for space between stock items
                    VStack(spacing:24){
                        ForEach(pantries ?? []){pantry in
                            ForEach(pantry.stock ?? []){item in
                                StockItemView(pantryName:pantry.name,itemName:item.name,current:item.current, full:item.full, type:item.type, ratio:item.ratio)
                            }
                        }
                    }
                }
                .frame(width: 340, height: 560)
            }
        }
        .task{
            pantries = try? await streamViewViewModel.getStreams().pantries
        }
    }
}
                                            
#Preview {
    StockView()
}

                            
