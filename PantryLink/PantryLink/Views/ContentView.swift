//
//  ContentView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    //creating class object
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    //gives access to appdelegate here

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isGuest") private var isGuest = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        ZStack {
            // App-wide background that adapts to dark mode - extends behind tab bar
            PL.background
                .ignoresSafeArea(.all)

            if !hasCompletedOnboarding {
                // First-launch tour. Location permission is requested later,
                // when the Home screen actually needs it.
                OnboardingView()
            } else if isLoggedIn {
                // Show main tab view when authenticated
                MainTabView()
                    .onAppear {
                        appDelegate.app = self
                    }
            } else {
                // Show sign in view
                NavigationStack(path: $path) {
                    SignInView(path: $path, isLoggedIn: $isLoggedIn, isGuest: $isGuest)
                        .onAppear(perform: {
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
