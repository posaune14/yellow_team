//
//  MainTabView.swift
//  PantryLink
//
//  Main tab view with native bottom navigation
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var path = NavigationPath()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomePageView(path: $path)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            StockPageView()
                .tabItem {
                    Label("Stock", systemImage: "cube.box.fill")
                }
                .tag(1)
            
            VolunteerPageView(path: $path)
                .tabItem {
                    Label("Volunteer", systemImage: "hand.raised.fill")
                }
                .tag(2)
        }
        .accentColor(Colors.flexibleOrange)
    }
}

#Preview {
    MainTabView()
}

