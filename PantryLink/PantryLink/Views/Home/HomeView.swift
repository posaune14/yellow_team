
//  HomeView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//
import SwiftUI

// HomePageView - Full page version for TabView
struct HomePageView: View {
    @Binding var path: NavigationPath

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: PL.spacingL) {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        PLSectionHeader(
                            title: "Pantries near you",
                            subtitle: "Find food pantries close to home."
                        )
                        LocalPantryView()
                    }

                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        PLSectionHeader(
                            title: "Announcements",
                            subtitle: "The latest news from your local pantries."
                        )
                        StreamView()
                    }
                }
                .padding(PL.spacingM)
                .frame(maxWidth: isIPad ? 800 : .infinity)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 80) // Room for the tab bar
            }
            .background(PL.background.ignoresSafeArea())
            .navigationTitle("PantryLink")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AccountView(path: $path)
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title2)
                            .frame(minWidth: PL.tapTarget, minHeight: PL.tapTarget)
                    }
                    .accessibilityLabel("Account")
                    .accessibilityHint("View and manage your account")
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "SignUp" {
                    SignUpView(path: $path)
                }
            }
        }
    }
}

#Preview {
    HomePageView(path: .constant(NavigationPath()))
}
