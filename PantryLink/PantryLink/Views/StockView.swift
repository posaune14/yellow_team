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
// StockPageView - Full page version for TabView
struct StockPageView: View {
    @StateObject var streamViewViewModel = StreamViewViewModel()
    @State var pantries: [Pantry]?
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Colors.flexibleWhite)
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
                            PantryStockCard(pantry: pantry)
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

// Legacy StockView (keeping for compatibility)
struct StockView: View{
    @StateObject var streamViewViewModel = StreamViewViewModel()
    @State var pantries: [Pantry]?
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Colors.flexibleWhite)
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
                            PantryStockCard(pantry: pantry)
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

// Helper view to display a single pantry's stock card
struct PantryStockCard: View {
    let pantry: Pantry
    
    var topItems: [PantryItem] {
        guard let stock = pantry.stock, !stock.isEmpty else { return [] }
        return Array(stock.prefix(3))
    }
    
    var body: some View {
        if !topItems.isEmpty {
            StockItemView(pantryName: pantry.name, topItems: topItems, pantryAddress: pantry.address)
        }
    }
}
                                            
#Preview {
    StockView()
}

                            
