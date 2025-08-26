
//  HomeView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//
import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.stockLightTan)
                .ignoresSafeArea()
            ScrollView{
                VStack{
                    
                    NavView(path: $path)
                    LocalPantryView()
                        .padding()
                    StreamView()
                        .padding()
                    StockView()
                        .padding()
                }
            }
            .padding(1.0)
            
        }.toolbar(.hidden)
    }
}

/*#Preview {
    HomeView()
}
*/
