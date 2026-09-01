//
//  DonationView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 1/25/26.
//
import SwiftUI
import MapKit

struct DonationView: View {
    @StateObject var streamViewViewModel = StreamViewViewModel()
    @State var pantries: [Pantry]?
    @State var isLoading = true
    @State var selectedPantry: Pantry?
    @State var showDetailView = false

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    // Only pantries that have stock information can show donation needs
    var pantriesNeedingDonations: [Pantry] {
        (pantries ?? []).filter { !($0.stock ?? []).isEmpty }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PL.spacingM) {
                PLSectionHeader(
                    title: "Help stock the shelves",
                    subtitle: "These items are what pantries need most right now. For money donations, please visit a pantry's website."
                )

                if isLoading {
                    PLLoadingView(message: "Loading donation needs...")
                } else if pantries == nil {
                    PLEmptyState(
                        icon: "wifi.slash",
                        title: "We couldn't load donation needs",
                        message: "Please check your internet connection and try again.",
                        actionTitle: "Try Again",
                        action: { Task { await loadPantries() } }
                    )
                } else if pantriesNeedingDonations.isEmpty {
                    PLEmptyState(
                        icon: "heart",
                        title: "No donation needs right now",
                        message: "The pantries are well stocked — thank you! Check back soon."
                    )
                } else {
                    ForEach(pantriesNeedingDonations) { pantry in
                        PantryDonationCard(pantry: pantry, onTap: {
                            selectedPantry = pantry
                            showDetailView = true
                        })
                    }
                }
            }
            .padding(PL.spacingM)
            .padding(.bottom, 80) // Room for the tab bar
            .frame(maxWidth: isIPad ? 800 : .infinity)
            .frame(maxWidth: .infinity)
        }
        .background(PL.background.ignoresSafeArea())
        .navigationTitle("Donations")
        .navigationDestination(isPresented: $showDetailView) {
            if let pantry = selectedPantry {
                PantryDetailView(pantry: pantry)
            }
        }
        .task {
            await loadPantries()
        }
    }

    func loadPantries() async {
        isLoading = true
        pantries = try? await streamViewViewModel.getStreams().pantries
        isLoading = false
    }
}

// Helper view to display a single pantry's donation needs card
struct PantryDonationCard: View {
    let pantry: Pantry
    var onTap: () -> Void = {}

    var bottomItems: [PantryItem] {
        guard let stock = pantry.stock, !stock.isEmpty else { return [] }
        // Sort by ratio (ascending) to get items with lowest stock
        let sorted = stock.sorted { $0.ratio < $1.ratio }
        return Array(sorted.prefix(3))
    }

    var body: some View {
        if !bottomItems.isEmpty {
            DonationItemView(
                pantryName: pantry.name,
                neededItems: bottomItems,
                pantryAddress: pantry.address,
                onDetails: onTap
            )
        }
    }
}

// Card view for donation needs (volunteer-focused)
struct DonationItemView: View {
    let pantryName: String
    let neededItems: [PantryItem]
    let pantryAddress: String?
    var onDetails: () -> Void = {}

    var body: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingM) {
                Button(action: onDetails) {
                    VStack(alignment: .leading, spacing: PL.spacingS) {
                        Text(pantryName)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)

                        Text("Most needed items")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        ForEach(neededItems) { item in
                            VStack(alignment: .leading, spacing: PL.spacingXS) {
                                Text(item.name)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                PLStockLevel(current: item.current, full: item.full)
                            }
                            .padding(.top, PL.spacingXS)
                        }

                        Text("Tap to see everything this pantry needs")
                            .font(.caption)
                            .foregroundStyle(PL.accent)
                            .padding(.top, PL.spacingXS)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityHint("Shows everything this pantry needs")

                if pantryAddress != nil {
                    PLSecondaryButton(
                        title: "Get Directions",
                        systemImage: "arrow.triangle.turn.up.right.diamond"
                    ) {
                        if let address = pantryAddress {
                            openInMaps(address: address)
                        }
                    }
                }
            }
        }
    }

    // Open Apple Maps with the pantry address
    func openInMaps(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let location = placemarks?.first?.location else {
                return
            }

            let regionDistance: CLLocationDistance = 500
            let coordinates = location.coordinate

            let regionSpan = MKCoordinateRegion(center: coordinates,
                                                latitudinalMeters: regionDistance,
                                                longitudinalMeters: regionDistance)

            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
            mapItem.name = pantryName

            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ])
        }
    }
}

#Preview {
    NavigationStack {
        DonationView()
    }
}
