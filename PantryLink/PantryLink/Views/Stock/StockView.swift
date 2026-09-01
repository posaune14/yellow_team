//
//  StockView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/29/25.
//
import SwiftUI

// StockPageView - Full page version for TabView
struct StockPageView: View {
    @StateObject var streamViewViewModel = StreamViewViewModel()
    @State var pantries: [Pantry]?
    @State var isLoading = true
    @State private var loadFailed = false
    @State var selectedPantry: Pantry?
    @State var showDetailView = false

    var body: some View {
        NavigationStack {
            ZStack {
                PL.background
                    .ignoresSafeArea()

                if isLoading {
                    PLLoadingView(message: "Finding pantries near you...")
                } else if loadFailed {
                    PLEmptyState(
                        icon: "wifi.exclamationmark",
                        title: "We couldn't load pantries",
                        message: "Please check your internet connection and try again.",
                        actionTitle: "Try Again",
                        action: { Task { await loadPantries() } }
                    )
                } else if (pantries ?? []).isEmpty {
                    PLEmptyState(
                        icon: "building.2",
                        title: "No pantries yet",
                        message: "No pantries are sharing their food stock right now. Please check back soon.",
                        actionTitle: "Try Again",
                        action: { Task { await loadPantries() } }
                    )
                } else {
                    ScrollView {
                        VStack(spacing: PL.spacingM) {
                            SearchView()

                            PLSectionHeader(
                                title: "All pantries",
                                subtitle: "Tap a pantry to see its food and announcements."
                            )

                            ForEach(pantries ?? []) { pantry in
                                PantryStockCard(pantry: pantry) {
                                    selectedPantry = pantry
                                    showDetailView = true
                                }
                            }
                        }
                        .padding(PL.spacingM)
                        .padding(.bottom, PL.spacingXL)
                        .frame(maxWidth: 700)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Pantries")
            .navigationDestination(isPresented: $showDetailView) {
                if let pantry = selectedPantry {
                    PantryDetailView(pantry: pantry)
                }
            }
        }
        .task {
            await loadPantries()
        }
    }

    private func loadPantries() async {
        isLoading = true
        loadFailed = false
        do {
            pantries = try await streamViewViewModel.getStreams().pantries
        } catch {
            loadFailed = true
        }
        isLoading = false
    }
}

// Helper view to display a single pantry's stock card
struct PantryStockCard: View {
    let pantry: Pantry
    var onTap: () -> Void = {}

    var topItems: [PantryItem] {
        guard let stock = pantry.stock, !stock.isEmpty else { return [] }
        return Array(stock.prefix(3))
    }

    var body: some View {
        Button(action: onTap) {
            StockItemView(
                pantryName: pantry.name,
                topItems: topItems,
                pantryAddress: pantry.address
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    StockPageView()
}
