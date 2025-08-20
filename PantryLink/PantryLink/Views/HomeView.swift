
//  HomeView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//
import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(){
            ScrollView{
                NavView()
                StreamView()
                
            }
        }
    }
}

#Preview {
    HomeView()
}
