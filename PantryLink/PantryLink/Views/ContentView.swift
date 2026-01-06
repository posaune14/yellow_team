//
//  ContentView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//

import SwiftUI

//create colors
struct Colors {
    static let brownBlack: Color = Color("brownBlack")
    static let flexibleGreen: Color = Color("flexibleGreen")
    static let flexibleLightGray: Color = Color("flexibleLightGray")
    static let flexibleDarkGray: Color = Color("flexibleDarkGray")
    static let flexibleBlack: Color = Color("flexibleBlack")
    static let flexibleRed: Color = Color("flexibleRed")
    static let flexibleOrange: Color = Color("flexibleOrange")
    static let flexibleBlue: Color = Color("flexibleBlue")
    static let flexibleWhite: Color = Color("flexibleWhite")
    static let stockLightTan: Color = Color("stockLightTan")
    static let stockDarkTan: Color = Color("stockDarkTan")
    static let flexibleDarkBrown: Color = Color("flexibleDarkBrown")
    static let maroonWhite: Color = Color("maroonWhite")
    static let stockRed: Color = Color("stockRed")
    static let stockOrange: Color = Color("stockOrange")
    static let clearBlack: Color = Color("clearBlack")
    //nomenclature (someone should probably change this):
    //flexible: changes shades from light to dark for darkmode
    //view+color: only used in that view
    //two colors: switches from one color to that color
}

struct ContentView: View {
    @State private var path = NavigationPath()
    //creating class object
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    //gives access to appdelegate here
    
    //Location Authentication 
    @StateObject private var locationManager = LocationManager()
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isGuest") private var isGuest = false
    
    var body: some View {
        ZStack {
            // App-wide background that adapts to dark mode - extends behind tab bar
            Colors.flexibleWhite
                .ignoresSafeArea(.all)
            
            if isLoggedIn {
                // Show main tab view when authenticated
                MainTabView()
                    .onAppear {
                        locationManager.checkLocationAuthorization()
                        appDelegate.app = self
                    }
            } else {
                // Show sign in view
                NavigationStack(path: $path) {
                    SignInView(path: $path, isLoggedIn: $isLoggedIn, isGuest: $isGuest)
                        .onAppear(perform: {
                            locationManager.checkLocationAuthorization()
                            appDelegate.app = self
                        })
                        .navigationDestination(for: String.self) { value in
                            if value == "SignUp" {
                                SignUpView(path: $path)
                            } else {
                                // Fallback - should not reach here if login is handled properly
                                EmptyView()
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
