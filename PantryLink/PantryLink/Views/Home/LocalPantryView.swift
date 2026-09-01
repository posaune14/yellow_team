//
//  LocalPantryView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 8/6/25.
//

import SwiftUI
import MapKit

struct LocalPantryView: View {
    @ObservedObject var location = LocationManager.shared
    @State var selectedPantry: IdentifiableMapItem? = nil
    @State private var scrolledIndex: Int? = 0

    private var locationDenied: Bool {
        location.manager.authorizationStatus == .denied
            || location.manager.authorizationStatus == .restricted
    }

    var body: some View {
        VStack(spacing: PL.spacingM) {
            if locationDenied {
                PLEmptyState(
                    icon: "location.slash",
                    title: "Location is turned off",
                    message: "To show pantries near you, please allow location access. Tap the button below, then choose Location and select \"While Using the App\".",
                    actionTitle: "Open Settings",
                    action: openAppSettings
                )
            } else if !location.locationReady {
                PLLoadingView(message: "Finding your location...")
            } else if location.isLoadingPantries {
                PLLoadingView(message: "Looking for pantries near you...")
            } else if location.allPantries.isEmpty {
                PLEmptyState(
                    icon: "mappin.slash",
                    title: "No pantries found nearby",
                    message: "We couldn't find any pantries near you right now. Please try again.",
                    actionTitle: "Try Again",
                    action: { location.findPantries() }
                )
            } else {
                pantryCarousel

                SearchView()
            }
        }
        .frame(maxWidth: .infinity)
        .sheet(item: $selectedPantry) { pantry in
            BasicPantryPopUpView(mapItem: pantry.mapItem)
                .presentationDetents([.medium, .large])
        }
        .onAppear {
            location.checkLocationAuthorization()
        }
        .onChange(of: location.locationReady) { _, newValue in
            if newValue {
                location.findPantries()
            }
        }
    }

    // Swipeable carousel of nearby pantries (sorted by distance, max 20).
    // Cards are slightly narrower than the screen so the next card peeks in
    // from the edge, making it obvious there's more to swipe to.
    private var pantryCarousel: some View {
        VStack(spacing: PL.spacingS) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: PL.spacingM) {
                    ForEach(Array(location.allPantries.enumerated()), id: \.offset) { index, pantry in
                        pantryCard(for: pantry)
                            .containerRelativeFrame(.horizontal) { length, _ in
                                length * 0.85
                            }
                            .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrolledIndex)
            .scrollIndicators(.hidden)

            // Position indicator so users know they can swipe through the list
            HStack(spacing: PL.spacingXS) {
                Image(systemName: "hand.draw")
                    .font(.caption)
                    .accessibilityHidden(true)
                Text("Pantry \((scrolledIndex ?? 0) + 1) of \(location.allPantries.count) — swipe to see more")
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .accessibilityLabel("Pantry \((scrolledIndex ?? 0) + 1) of \(location.allPantries.count). Swipe left or right to browse pantries.")
        }
    }

    private func pantryCard(for pantry: MKMapItem) -> some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingM) {
                Button {
                    selectedPantry = IdentifiableMapItem(mapItem: pantry)
                } label: {
                    VStack(alignment: .leading, spacing: PL.spacingS) {
                        SnapshotImageView(coordinate: pantry.placemark.coordinate, location: location)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .allowsHitTesting(false)

                        Text(pantry.name ?? "Unknown Pantry")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)

                        if let distanceText = distanceText(for: pantry) {
                            Text(distanceText)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Text("Tap for details")
                            .font(.caption)
                            .foregroundStyle(PL.accent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityHint("Shows details about this pantry")

                PLSecondaryButton(
                    title: "Get Directions",
                    systemImage: "arrow.triangle.turn.up.right.diamond"
                ) {
                    openPantryInMaps(pantry: pantry)
                }
            }
        }
    }

    // Friendly distance like "1.2 miles away"
    private func distanceText(for pantry: MKMapItem) -> String? {
        guard let pantryLocation = pantry.placemark.location,
              let userLocation = location.lastKnownLocation else { return nil }
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let distance = pantryLocation.distance(from: userCLLocation)
        let distanceInMiles = distance * 0.000621371
        return String(format: "%.1f miles away", distanceInMiles)
    }

    // Open the app's page in the Settings app so the user can allow location
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    // Open Apple Maps with the pantry location
    func openPantryInMaps(pantry: MKMapItem) {
        // If placemark.location is nil, create a new placemark with just coordinate
        if pantry.placemark.location == nil {
            let coordinate = pantry.placemark.coordinate
            let newPlacemark = MKPlacemark(coordinate: coordinate)
            let newMapItem = MKMapItem(placemark: newPlacemark)
            newMapItem.name = pantry.name
            newMapItem.openInMaps(launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ])
        } else {
            // Use the pantry MKMapItem directly - it already has all the data configured
            pantry.openInMaps(launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ])
        }
    }
}

#Preview {
    ScrollView {
        LocalPantryView()
            .padding()
    }
    .background(PL.background)
}
