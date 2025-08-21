
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
        VStack(){
            ScrollView{
                NavView(path: $path)
                StreamView()
                StockView()
            }
        }.toolbar(.hidden)
    }
}

/*#Preview {
    HomeView()
}
*/
