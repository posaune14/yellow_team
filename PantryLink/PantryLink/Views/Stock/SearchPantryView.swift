//
//  SearchPantryView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 1/24/26.
//

import SwiftUI
import MapKit

struct SearchPantryView: View {
    @StateObject private var viewModel = StreamViewViewModel()
    @ObservedObject var locationManager = LocationManager.shared
    @State private var searchText = ""
    @State private var pantryLinkPantries: [Pantry] = [] // Pantries with stock from API
    @State private var googleSheetPantries: [MKMapItem] = [] // Pantries from Google Sheets only
    @State private var isLoading = true
    @State private var loadFailed = false
    @State private var selectedPantry: Pantry?
    @State private var selectedMapItem: MKMapItem?
    @State private var showDetailView = false
    @State private var showMapItemPopup = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // Filter PantryLink pantries based on search text
    var filteredPantryLinkPantries: [Pantry] {
        if searchText.isEmpty {
            return pantryLinkPantries
        }

        let lowercasedSearch = searchText.lowercased()

        return pantryLinkPantries.filter { pantry in
            // Search by pantry name
            let nameMatch = pantry.name.lowercased().contains(lowercasedSearch)

            // Search by address (includes city, state, zip)
            let addressMatch = pantry.address?.lowercased().contains(lowercasedSearch) ?? false

            // Extract and search by zip code specifically
            let zipMatch = extractZipCode(from: pantry.address ?? "").contains(searchText)

            // Search by items in stock
            let itemMatch = pantry.stock?.contains { item in
                item.name.lowercased().contains(lowercasedSearch) ||
                item.type.lowercased().contains(lowercasedSearch)
            } ?? false

            return nameMatch || addressMatch || zipMatch || itemMatch
        }
    }

    // Filter Google Sheet pantries based on search text (no item search)
    var filteredGoogleSheetPantries: [MKMapItem] {
        if searchText.isEmpty {
            return googleSheetPantries
        }

        let lowercasedSearch = searchText.lowercased()

        return googleSheetPantries.filter { mapItem in
            // Search by pantry name
            let nameMatch = mapItem.name?.lowercased().contains(lowercasedSearch) ?? false

            // Search by city
            let cityMatch = mapItem.placemark.locality?.lowercased().contains(lowercasedSearch) ?? false

            // Search by state
            let stateMatch = mapItem.placemark.administrativeArea?.lowercased().contains(lowercasedSearch) ?? false

            // Search by zip code
            let zipMatch = mapItem.placemark.postalCode?.contains(searchText) ?? false

            return nameMatch || cityMatch || stateMatch || zipMatch
        }
    }

    // Get matching items for a pantry (for display purposes)
    func getMatchingItems(for pantry: Pantry) -> [PantryItem] {
        guard !searchText.isEmpty,
              let stock = pantry.stock else {
            return []
        }

        let lowercasedSearch = searchText.lowercased()
        return stock.filter { item in
            item.name.lowercased().contains(lowercasedSearch) ||
            item.type.lowercased().contains(lowercasedSearch)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PL.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Search Bar
                    HStack(spacing: PL.spacingS) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                            .accessibilityHidden(true)

                        TextField("Search by name, item, city, or zip code", text: $searchText)
                            .font(.body)
                            .frame(minHeight: PL.tapTarget)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                                    .frame(minWidth: PL.tapTarget, minHeight: PL.tapTarget)
                            }
                            .accessibilityLabel("Clear search")
                        }
                    }
                    .padding(.horizontal, PL.spacingM)
                    .background(PL.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: PL.cornerRadius))
                    .padding(.horizontal, PL.spacingM)
                    .padding(.bottom, PL.spacingM)
                    .frame(maxWidth: 700)

                    // Results
                    if isLoading {
                        PLLoadingView(message: "Loading pantries...")
                        Spacer()
                    } else if loadFailed {
                        PLEmptyState(
                            icon: "wifi.exclamationmark",
                            title: "We couldn't load pantries",
                            message: "Please check your internet connection and try again.",
                            actionTitle: "Try Again",
                            action: { Task { await loadPantries() } }
                        )
                        Spacer()
                    } else if filteredPantryLinkPantries.isEmpty && filteredGoogleSheetPantries.isEmpty {
                        if searchText.isEmpty {
                            PLEmptyState(
                                icon: "building.2",
                                title: "No pantries yet",
                                message: "No pantries are available right now. Please check back soon.",
                                actionTitle: "Try Again",
                                action: { Task { await loadPantries() } }
                            )
                        } else {
                            PLEmptyState(
                                icon: "magnifyingglass",
                                title: "No pantries match",
                                message: "Please check the spelling, or try a different name, item, city, or zip code."
                            )
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: PL.spacingM) {
                                // Show count of results
                                if !searchText.isEmpty {
                                    let totalResults = filteredPantryLinkPantries.count + filteredGoogleSheetPantries.count
                                    Text("\(totalResults) result\(totalResults == 1 ? "" : "s") found")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                // PantryLink Pantries Section
                                if !filteredPantryLinkPantries.isEmpty {
                                    PLSectionHeader(
                                        title: "PantryLink Pantries",
                                        subtitle: "These pantries share what food they have."
                                    )

                                    ForEach(filteredPantryLinkPantries) { pantry in
                                        PantrySearchCard(
                                            pantry: pantry,
                                            searchText: searchText,
                                            matchingItems: getMatchingItems(for: pantry)
                                        ) {
                                            selectedPantry = pantry
                                            showDetailView = true
                                        }
                                    }
                                }

                                // Google Sheet Pantries Section
                                if !filteredGoogleSheetPantries.isEmpty {
                                    PLSectionHeader(
                                        title: "Other Pantries",
                                        subtitle: "These pantries don't share their food list yet."
                                    )
                                    .padding(.top, filteredPantryLinkPantries.isEmpty ? 0 : PL.spacingS)

                                    ForEach(Array(filteredGoogleSheetPantries.enumerated()), id: \.offset) { _, mapItem in
                                        BasicPantryCard(mapItem: mapItem) {
                                            selectedMapItem = mapItem
                                            showMapItemPopup = true
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, PL.spacingM)
                            .padding(.bottom, PL.spacingXL)
                            .frame(maxWidth: 700)
                            .frame(maxWidth: .infinity)
                            .animation(reduceMotion ? nil : .default, value: searchText)
                        }
                    }
                }
            }
            .navigationTitle("Search Pantries")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showDetailView) {
                if let pantry = selectedPantry {
                    PantryDetailView(pantry: pantry)
                }
            }
            .sheet(isPresented: $showMapItemPopup) {
                if let mapItem = selectedMapItem {
                    BasicPantryPopUpView(mapItem: mapItem)
                        .presentationDetents([.medium, .large])
                }
            }
        }
        .task {
            await loadPantries()
        }
    }

    // Load pantries from both API and Google Sheets
    private func loadPantries() async {
        isLoading = true
        loadFailed = false
        do {
            // Load PantryLink pantries from API
            let response = try await viewModel.getStreams()
            pantryLinkPantries = response.pantries

            // Get Google Sheet pantries from LocationManager
            let allGooglePantries = locationManager.knownNJPantries

            // Filter out pantries that are already on PantryLink
            // Compare by name (case-insensitive)
            let pantryLinkNames = Set(pantryLinkPantries.map { $0.name.lowercased() })
            googleSheetPantries = allGooglePantries.filter { mapItem in
                guard let name = mapItem.name else { return false }
                return !pantryLinkNames.contains(name.lowercased())
            }

            isLoading = false
        } catch {
            loadFailed = true
            isLoading = false
        }
    }

    // Extract zip code from address string
    private func extractZipCode(from address: String) -> String {
        // Look for 5-digit zip code pattern
        let zipPattern = "\\b\\d{5}\\b"
        if let range = address.range(of: zipPattern, options: .regularExpression) {
            return String(address[range])
        }
        return ""
    }
}

// Helper view to display a single pantry in search results
struct PantrySearchCard: View {
    let pantry: Pantry
    let searchText: String
    let matchingItems: [PantryItem]
    let onTap: () -> Void

    // Show matching items if search found items, otherwise show top 3 items
    var displayItems: [PantryItem] {
        if !matchingItems.isEmpty {
            // Show up to 3 matching items
            return Array(matchingItems.prefix(3))
        } else {
            // Show top 3 items as default
            guard let stock = pantry.stock, !stock.isEmpty else { return [] }
            return Array(stock.prefix(3))
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: PL.spacingXS) {
                StockItemView(
                    pantryName: pantry.name,
                    topItems: displayItems,
                    pantryAddress: pantry.address
                )

                // Show indicator if items were matched by search
                if !matchingItems.isEmpty && !searchText.isEmpty {
                    HStack(spacing: PL.spacingXS) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(PL.good)
                            .accessibilityHidden(true)
                        Text("Has \(matchingItems.count) matching item\(matchingItems.count == 1 ? "" : "s")")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(PL.good)
                        Spacer()
                    }
                    .padding(.horizontal, PL.spacingM)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// Basic card for Google Sheet pantries (not on PantryLink yet)
struct BasicPantryCard: View {
    let mapItem: MKMapItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            PLCard {
                VStack(alignment: .leading, spacing: PL.spacingS) {
                    HStack(alignment: .top, spacing: PL.spacingS) {
                        VStack(alignment: .leading, spacing: PL.spacingXS) {
                            Text(mapItem.name ?? "Unknown Pantry")
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.leading)

                            if let city = mapItem.placemark.locality,
                               let state = mapItem.placemark.administrativeArea {
                                Text("\(city), \(state)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer(minLength: PL.spacingS)

                        // Directions button
                        Button {
                            openInMaps(mapItem: mapItem)
                        } label: {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                .font(.title3)
                                .foregroundStyle(PL.accent)
                                .frame(minWidth: PL.tapTarget, minHeight: PL.tapTarget)
                        }
                        .buttonStyle(.bordered)
                        .tint(PL.accent)
                        .accessibilityLabel("Get directions to \(mapItem.name ?? "this pantry")")
                    }

                    // Address
                    if let street = mapItem.placemark.thoroughfare {
                        Label(street, systemImage: "location.fill")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // Phone
                    if let phone = mapItem.phoneNumber {
                        Label(phone, systemImage: "phone.fill")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // Website
                    if let url = mapItem.url {
                        Label(url.absoluteString, systemImage: "globe")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    // Info indicator
                    HStack(spacing: PL.spacingXS) {
                        Spacer()
                        Text("More info")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(PL.accent)
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundStyle(PL.accent)
                            .accessibilityHidden(true)
                    }
                }
            }
            .accessibilityElement(children: .combine)
        }
        .buttonStyle(.plain)
    }

    func openInMaps(mapItem: MKMapItem) {
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

// Popup view for basic pantry information
struct BasicPantryPopUpView: View {
    let mapItem: MKMapItem
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: PL.spacingM) {
                    // Name
                    Text(mapItem.name ?? "Unknown Pantry")
                        .font(.title2.bold())
                        .foregroundStyle(.primary)

                    // Address Section
                    PLCard {
                        VStack(alignment: .leading, spacing: PL.spacingS) {
                            Label("Address", systemImage: "location.fill")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            if let street = mapItem.placemark.thoroughfare,
                               let city = mapItem.placemark.locality,
                               let state = mapItem.placemark.administrativeArea,
                               let zip = mapItem.placemark.postalCode {
                                Text("\(street)\n\(city), \(state) \(zip)")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            } else if let street = mapItem.placemark.thoroughfare {
                                Text(street)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Not provided")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }

                            PLPrimaryButton(
                                title: "Get Directions",
                                systemImage: "arrow.triangle.turn.up.right.diamond"
                            ) {
                                mapItem.openInMaps(launchOptions: [
                                    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                                ])
                            }
                        }
                    }

                    // Phone Section
                    PLCard {
                        VStack(alignment: .leading, spacing: PL.spacingS) {
                            Label("Phone", systemImage: "phone.fill")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            if let phone = mapItem.phoneNumber {
                                if let phoneURL = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: ""))") {
                                    Link(destination: phoneURL) {
                                        HStack {
                                            Text(phone)
                                                .font(.body)
                                            Spacer()
                                            Image(systemName: "phone.circle.fill")
                                                .accessibilityHidden(true)
                                        }
                                        .foregroundStyle(PL.accent)
                                        .frame(minHeight: PL.tapTarget)
                                    }
                                    .accessibilityLabel("Call \(mapItem.name ?? "this pantry") at \(phone)")
                                } else {
                                    Text(phone)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                }
                            } else {
                                Text("Not provided")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    // Website Section
                    if let url = mapItem.url {
                        PLCard {
                            VStack(alignment: .leading, spacing: PL.spacingS) {
                                Label("Website", systemImage: "globe")
                                    .font(.headline)
                                    .foregroundStyle(.primary)

                                Link(destination: url) {
                                    HStack {
                                        Text(url.absoluteString)
                                            .font(.body)
                                            .lineLimit(2)
                                        Spacer()
                                        Image(systemName: "arrow.up.right.square")
                                            .accessibilityHidden(true)
                                    }
                                    .foregroundStyle(PL.accent)
                                    .frame(minHeight: PL.tapTarget)
                                }
                                .accessibilityLabel("Open website for \(mapItem.name ?? "this pantry")")
                            }
                        }
                    }

                    // Info note
                    PLCard {
                        VStack(alignment: .leading, spacing: PL.spacingS) {
                            Label("Not on PantryLink yet", systemImage: "info.circle")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text("This pantry hasn't listed its food yet, so we can't show what's in stock. You can call ahead or stop by to see what they have.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(PL.spacingM)
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
            }
            .background(PL.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .tint(PL.accent)
                }
            }
        }
    }
}

#Preview {
    SearchPantryView()
}
