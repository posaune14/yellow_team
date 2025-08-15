
//  HomeView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//
import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.stockLightTan)
                .ignoresSafeArea()
            ScrollView{
                VStack{
                    
                    NavView()
                    LocalPantryView()
                        .padding()
                    StreamView()
                        .padding()
                    StockView()
                        .padding()
                }
            }
            .padding(1.0)
            
        }
    }
}

#Preview {
    HomeView()
}
