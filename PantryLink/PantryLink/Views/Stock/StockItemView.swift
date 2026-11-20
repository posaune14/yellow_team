//
//  StockItemView.swift
//  PantryLink
//
//  Created by Jared Sinai Hernandez Adame on 10/14/25.
//
import SwiftUI
import MapKit

/// Card summarizing a pantry: name, address, and a clear
/// "tap to see more" affordance. (topItems is kept for API compatibility
/// and to show the "no food listed" note when empty.)
struct StockItemView: View {
    let pantryName: String
    let topItems: [PantryItem]
    let pantryAddress: String?

    var body: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingS) {
                HStack(alignment: .top, spacing: PL.spacingS) {
                    VStack(alignment: .leading, spacing: PL.spacingXS) {
                        Text(pantryName)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)

                        if let address = pantryAddress, !address.isEmpty {
                            Text(address)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                    }

                    Spacer(minLength: PL.spacingS)

                    if pantryAddress != nil {
                        Button {
                            if let address = pantryAddress {
                                openInMaps(address: address)
                            }
                        } label: {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                .font(.title3)
                                .foregroundStyle(PL.accent)
                                .frame(minWidth: PL.tapTarget, minHeight: PL.tapTarget)
                        }
                        .buttonStyle(.bordered)
                        .tint(PL.accent)
                        .accessibilityLabel("Get directions to \(pantryName)")
                    }
                }

                if topItems.isEmpty {
                    Text("This pantry hasn't listed its food yet.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, PL.spacingXS)
                }

                HStack(spacing: PL.spacingXS) {
                    Spacer()
                    Text("See all items")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(PL.accent)
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .foregroundStyle(PL.accent)
                        .accessibilityHidden(true)
                }
                .padding(.top, PL.spacingXS)
            }
        }
        .accessibilityElement(children: .combine)
    }

    // Open Apple Maps with the pantry address
    func openInMaps(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, _ in
            guard let location = placemarks?.first?.location else { return }

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
    ScrollView {
        StockItemView(
            pantryName: "Flemmington Pantry",
            topItems: [
                PantryItem(name: "Canned Beans", current: 3, full: 10, type: "Cans", ratio: 0.3),
                PantryItem(name: "Tomato Soup", current: 5, full: 10, type: "Cans", ratio: 0.5),
                PantryItem(name: "Pasta", current: 8, full: 10, type: "Dry Goods", ratio: 0.8)
            ],
            pantryAddress: "373 Burnt Hill Road, Skillman, NJ 08558"
        )
        .padding()
    }
    .background(PL.background)
}
