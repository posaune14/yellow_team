//
//  Stream.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/28/25.
//

import SwiftUI

// Helper struct to hold alert with pantry name for sorting
struct StreamAlertWithPantry: Identifiable {
    let id: String
    let pantryName: String
    let alert: StreamAlert
    let sortDate: Date

    init(pantryName: String, alert: StreamAlert) {
        self.pantryName = pantryName
        self.alert = alert
        // Create unique ID from pantry name + message + date
        self.id = "\(pantryName)-\(alert.message)-\(alert.date)"

        // Parse date for sorting - try multiple formats
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        // Try different date formats
        let dateFormats = [
            "MM/dd/yyyy hh:mm a",  // e.g., "10/25/2023 10:30 AM"
            "MM/dd/yyyy",           // e.g., "10/25/2023"
            "MM/dd/yy",             // e.g., "10/25/23"
            "dd MMMM",              // e.g., "23 March"
            "MMMM dd, yyyy"         // e.g., "March 23, 2023"
        ]

        var parsedDate: Date?
        for format in dateFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: alert.date) {
                parsedDate = date
                break
            }
        }

        // Fallback to a distant past date if parsing fails
        self.sortDate = parsedDate ?? Date.distantPast
    }

    /// Friendly date shown to the user, e.g. "2 days ago".
    /// Falls back to the raw date string when we couldn't parse it.
    var displayDate: String {
        guard sortDate != Date.distantPast else { return alert.date }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: sortDate, relativeTo: Date())
    }
}

struct StreamView: View {
    @StateObject var streamViewViewModel = StreamViewViewModel()
    @State var pantries: [Pantry]?
    @State var isLoading = true

    // Computed property to get sorted alerts from all pantries
    var sortedAlerts: [StreamAlertWithPantry] {
        guard let pantries = pantries else { return [] }

        // Collect all alerts from all pantries
        var allAlerts: [StreamAlertWithPantry] = []
        for pantry in pantries {
            if let stream = pantry.stream {
                for alert in stream {
                    allAlerts.append(StreamAlertWithPantry(pantryName: pantry.name, alert: alert))
                }
            }
        }

        // Sort in reverse chronological order (newest first)
        return allAlerts.sorted { $0.sortDate > $1.sortDate }
    }

    var body: some View {
        VStack(spacing: PL.spacingM) {
            if isLoading {
                PLLoadingView(message: "Loading announcements...")
            } else if pantries == nil {
                PLEmptyState(
                    icon: "wifi.slash",
                    title: "We couldn't load announcements",
                    message: "Please check your internet connection and try again.",
                    actionTitle: "Try Again",
                    action: { Task { await loadAnnouncements() } }
                )
            } else if sortedAlerts.isEmpty {
                PLEmptyState(
                    icon: "bell",
                    title: "No announcements yet",
                    message: "No announcements yet — check back soon."
                )
            } else {
                ForEach(sortedAlerts) { alertWithPantry in
                    PantryAlertView(
                        pantryName: alertWithPantry.pantryName,
                        message: alertWithPantry.alert.message,
                        date: alertWithPantry.displayDate
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .task {
            await loadAnnouncements()
        }
    }

    func loadAnnouncements() async {
        isLoading = true
        // If request succeeds we get pantries otherwise we get nil and error is ignored
        pantries = try? await streamViewViewModel.getStreams().pantries
        isLoading = false
    }
}

#Preview {
    ScrollView {
        StreamView(streamViewViewModel: StreamViewViewModel(), pantries: [
            Pantry(_id: "68ed1581783104e82a2790e9", name: "Princeton Mobile", stock: [], address: "1234 main street", stream: [
                StreamAlert(date: "10/25/2023", message: "Hi world")
            ], email: "contact@princeton.org", phone_number: "(555) 123-4567", website: nil, schedule_settings: nil),
            Pantry(_id: "id", name: "Hillsborough CAN", stock: [], address: "273 Kelvin street", stream: [StreamAlert(date: "10/24/23", message: "food information")], email: nil, phone_number: nil, website: nil, schedule_settings: nil)
        ])
        .padding()
    }
    .background(PL.background)
}
