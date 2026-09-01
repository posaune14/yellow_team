//
//  SearchView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 1/24/26.
//
import SwiftUI

/// Tappable search entry point. Looks like a search bar; opens the full
/// pantry search screen when tapped.
struct SearchView: View {
    var body: some View {
        NavigationLink(destination: SearchPantryView()) {
            HStack(spacing: PL.spacingS) {
                Image(systemName: "magnifyingglass")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)

                Text("Search by name, city, zip code, or item")
                    .font(.body)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding(PL.spacingM)
            .frame(maxWidth: .infinity, minHeight: PL.tapTarget)
            .background(PL.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: PL.cornerRadius))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Search pantries by name, city, zip code, or item")
    }
}

#Preview {
    NavigationStack {
        SearchView()
            .padding()
            .background(PL.background)
    }
}
