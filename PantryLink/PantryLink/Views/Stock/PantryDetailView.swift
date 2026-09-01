//
//  PantryDetailView.swift
//  PantryLink
//
//  Detailed view showing a pantry's contact info and full inventory,
//  grouped by food type, with a simple item search.
//

import SwiftUI
import MapKit

struct PantryDetailView: View {
    let pantry: Pantry
    @State private var searchText = ""

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // Items that match the search text
    var filteredItems: [PantryItem] {
        guard let stock = pantry.stock else { return [] }
        if searchText.isEmpty { return stock }
        return stock.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    // Inventory grouped by food type, types sorted alphabetically,
    // items sorted by name within each type.
    var groupedItems: [(type: String, items: [PantryItem])] {
        let groups = Dictionary(grouping: filteredItems) { item in
            item.type.trimmingCharacters(in: .whitespaces).isEmpty ? "Other" : item.type
        }
        return groups
            .map { (type: $0.key, items: $0.value.sorted { $0.name < $1.name }) }
            .sorted { $0.type < $1.type }
    }

    // This pantry's announcements, newest first
    var announcements: [StreamAlertWithPantry] {
        (pantry.stream ?? [])
            .map { StreamAlertWithPantry(pantryName: pantry.name, alert: $0) }
            .sorted { $0.sortDate > $1.sortDate }
    }

    var body: some View {
        ZStack {
            PL.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: PL.spacingM) {
                    // Contact and location info
                    pantryInfoCard

                    if let address = pantry.address, !address.isEmpty {
                        PLPrimaryButton(
                            title: "Get Directions",
                            systemImage: "arrow.triangle.turn.up.right.diamond"
                        ) {
                            openInMaps(address: address)
                        }
                    }

                    // Announcements from this pantry
                    if !announcements.isEmpty {
                        PLSectionHeader(title: "Announcements")
                            .padding(.top, PL.spacingS)

                        ForEach(announcements) { announcement in
                            PLCard {
                                VStack(alignment: .leading, spacing: PL.spacingXS) {
                                    Text(announcement.alert.message)
                                        .font(.body)
                                        .foregroundStyle(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text(announcement.displayDate)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .accessibilityElement(children: .combine)
                        }
                    }

                    // Inventory
                    if let stock = pantry.stock, !stock.isEmpty {
                        PLSectionHeader(
                            title: "What's in stock",
                            subtitle: "\(stock.count) item\(stock.count == 1 ? "" : "s") listed"
                        )
                        .padding(.top, PL.spacingS)

                        searchBar

                        if filteredItems.isEmpty {
                            PLEmptyState(
                                icon: "magnifyingglass",
                                title: "No items match",
                                message: "Please check the spelling, or try a shorter word.",
                                actionTitle: "Clear Search",
                                action: { searchText = "" }
                            )
                        } else {
                            ForEach(groupedItems, id: \.type) { group in
                                PLSectionHeader(title: group.type)
                                    .padding(.top, PL.spacingXS)

                                ForEach(group.items) { item in
                                    PLCard {
                                        VStack(alignment: .leading, spacing: PL.spacingXS) {
                                            HStack(alignment: .firstTextBaseline) {
                                                Text(item.name)
                                                    .font(.headline)
                                                    .foregroundStyle(.primary)
                                                Spacer()
                                                Text("\(item.current) of \(item.full)")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }
                                            PLStockLevel(current: item.current, full: item.full)
                                        }
                                    }
                                    .accessibilityElement(children: .combine)
                                }
                            }
                        }
                    } else {
                        PLEmptyState(
                            icon: "tray",
                            title: "No food list yet",
                            message: "This pantry hasn't listed its food yet. You can call ahead or stop by to see what they have."
                        )
                    }
                }
                .padding(PL.spacingM)
                .padding(.bottom, PL.spacingXL)
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
                .animation(reduceMotion ? nil : .default, value: searchText)
            }
        }
        .navigationTitle(pantry.name)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Pantry info

    private var pantryInfoCard: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingM) {
                // Address
                infoRow(icon: "location.fill", label: "Address") {
                    if let address = pantry.address, !address.isEmpty {
                        Text(address)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text("Not provided")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }

                // Phone (tappable)
                infoRow(icon: "phone.fill", label: "Phone") {
                    if let phone = pantry.phone_number, !phone.isEmpty {
                        if let phoneURL = telURL(for: phone) {
                            Link(destination: phoneURL) {
                                HStack(spacing: PL.spacingXS) {
                                    Text(phone)
                                        .font(.body)
                                        .underline()
                                    Image(systemName: "phone.circle.fill")
                                        .accessibilityHidden(true)
                                }
                                .foregroundStyle(PL.accent)
                                .frame(minHeight: PL.tapTarget)
                            }
                            .accessibilityLabel("Call \(pantry.name) at \(phone)")
                        } else {
                            Text(phone)
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                    } else {
                        Text("Not provided")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }

                // Email (tappable, omitted when missing)
                if let email = pantry.email, !email.isEmpty {
                    infoRow(icon: "envelope.fill", label: "Email") {
                        if let emailURL = URL(string: "mailto:\(email)") {
                            Link(destination: emailURL) {
                                Text(email)
                                    .font(.body)
                                    .underline()
                                    .foregroundStyle(PL.accent)
                                    .frame(minHeight: PL.tapTarget)
                            }
                            .accessibilityLabel("Email \(pantry.name)")
                        } else {
                            Text(email)
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                    }
                }

                // Website (tappable, omitted when missing)
                if let website = pantry.website, !website.isEmpty {
                    infoRow(icon: "globe", label: "Website") {
                        if let url = URL(string: website) {
                            Link(destination: url) {
                                Text(website)
                                    .font(.body)
                                    .underline()
                                    .lineLimit(2)
                                    .foregroundStyle(PL.accent)
                                    .frame(minHeight: PL.tapTarget)
                            }
                            .accessibilityLabel("Open website for \(pantry.name)")
                        } else {
                            Text(website)
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
        }
    }

    private func infoRow<Content: View>(
        icon: String,
        label: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: PL.spacingXS) {
            Label(label, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Search bar

    private var searchBar: some View {
        HStack(spacing: PL.spacingS) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            TextField("Search for a food item", text: $searchText)
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
    }

    // MARK: - Helpers

    // Build a tel: URL from a formatted phone number
    private func telURL(for phone: String) -> URL? {
        let digits = phone.filter { $0.isNumber || $0 == "+" }
        guard !digits.isEmpty else { return nil }
        return URL(string: "tel://\(digits)")
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
            mapItem.name = pantry.name

            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span),
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ])
        }
    }
}

#Preview {
    NavigationStack {
        PantryDetailView(
            pantry: Pantry(
                _id: "1",
                name: "Montgomery Food Pantry",
                stock: [
                    PantryItem(name: "Canned Beans", current: 3, full: 10, type: "Cans", ratio: 0.3),
                    PantryItem(name: "Tomato Soup", current: 5, full: 10, type: "Cans", ratio: 0.5),
                    PantryItem(name: "Pasta", current: 8, full: 10, type: "Dry Goods", ratio: 0.8),
                    PantryItem(name: "Rice", current: 9, full: 10, type: "Dry Goods", ratio: 0.9),
                    PantryItem(name: "Fresh Carrots", current: 2, full: 10, type: "Fresh", ratio: 0.2),
                    PantryItem(name: "Frozen Chicken", current: 6, full: 10, type: "Frozen", ratio: 0.6)
                ],
                address: "356 Skillman Rd, Skillman, NJ 08558",
                stream: nil,
                email: "contact@montgomerypantry.org",
                phone_number: "(908) 555-1234",
                website: "https://montgomerypantry.org",
                schedule_settings: nil
            )
        )
    }
}
