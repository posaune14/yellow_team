//
//  MainTabView.swift
//  PantryLink
//
//  Main tab view with native bottom navigation
//

import SwiftUI
import UIKit

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var path = NavigationPath()
    
    init() {
        // Customize the tab bar to be transparent and floating
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Make background completely transparent
        appearance.backgroundColor = UIColor.clear
        appearance.backgroundEffect = nil
        
        // Remove all shadows and borders
        appearance.shadowColor = UIColor.clear
        
        // Configure selected tab item with orange accent
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "flexibleOrange") ?? UIColor.systemOrange
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(named: "flexibleOrange") ?? UIColor.systemOrange
        ]
        
        // Configure unselected tab item
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        
        // Apply the appearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().barTintColor = UIColor.clear
        UITabBar.appearance().isTranslucent = true
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
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

