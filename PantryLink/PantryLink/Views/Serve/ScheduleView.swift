//
//  ScheduleView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 1/25/26.
//

import SwiftUI
import MapKit

struct ScheduleView: View {
    @ObservedObject private var userManager = UserManager.shared
    @State private var pantries: [Pantry] = []
    @State private var userWeekSchedule: [UserWeekScheduleItem] = []
    @State private var isLoading = false
    @State private var loadErrorMessage: String?
    @State private var selectedPantryId: String?
    @State private var showPantrySchedule = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PL.spacingL) {
                // Your Week at a Glance Section (only show if user has schedules)
                if !userWeekSchedule.isEmpty {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        PLSectionHeader(
                            title: "Your Week at a Glance",
                            subtitle: "Shifts you're signed up for over the next 7 days"
                        )

                        ForEach(userWeekSchedule) { item in
                            WeekScheduleCard(item: item, onTap: {
                                if let pantry = pantries.first(where: { $0._id == item.pantry_id }) {
                                    selectedPantryId = pantry._id
                                    showPantrySchedule = true
                                }
                            })
                        }
                    }

                    Divider()
                }

                // All Pantries Section
                VStack(alignment: .leading, spacing: PL.spacingM) {
                    PLSectionHeader(
                        title: "Places to Volunteer",
                        subtitle: "Tap a pantry to see its schedule and sign up for a shift"
                    )

                    if isLoading {
                        PLLoadingView(message: "Finding pantries near you...")
                    } else if let loadErrorMessage {
                        PLEmptyState(
                            icon: "wifi.exclamationmark",
                            title: "We couldn't load the pantries",
                            message: loadErrorMessage,
                            actionTitle: "Try Again",
                            action: { fetchPantries() }
                        )
                    } else if pantries.isEmpty {
                        PLEmptyState(
                            icon: "building.2",
                            title: "No pantries yet",
                            message: "There are no food pantries listed right now. Please check back soon.",
                            actionTitle: "Refresh",
                            action: { fetchPantries() }
                        )
                    } else {
                        ForEach(pantries) { pantry in
                            PantryCard(pantry: pantry) {
                                selectedPantryId = pantry._id
                                showPantrySchedule = true
                            }
                        }
                    }
                }
            }
            .padding(PL.spacingM)
            .padding(.bottom, PL.spacingXL)
        }
        .background(PL.background.ignoresSafeArea())
        .navigationTitle("Volunteer Schedule")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            fetchPantries()
        }
        .refreshable {
            await refreshData()
        }
        .sheet(isPresented: $showPantrySchedule) {
            if let pantryId = selectedPantryId,
               let pantry = pantries.first(where: { $0._id == pantryId }) {
                PantryScheduleDetailView(pantry: pantry)
            }
        }
    }

    private func refreshData() async {
        fetchPantries()
    }

    private func fetchPantries() {
        isLoading = true
        loadErrorMessage = nil

        guard let url = URL(string: "\(API.baseURL)/pantry/") else {
            isLoading = false
            loadErrorMessage = "Something went wrong on our end. Please try again."
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { DispatchQueue.main.async { isLoading = false } }

            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.loadErrorMessage = "Please check your internet connection, then tap Try Again."
                }
                return
            }

            do {
                struct PantryResponse: Codable {
                    let pantries: [Pantry]
                    let message: String
                }

                let result = try JSONDecoder().decode(PantryResponse.self, from: data)
                DispatchQueue.main.async {
                    self.pantries = result.pantries
                    // After loading pantries, fetch user's week schedule
                    self.fetchUserWeekSchedule()
                }
            } catch {
                DispatchQueue.main.async {
                    self.loadErrorMessage = "We had trouble reading the pantry list. Please try again."
                }
            }
        }.resume()
    }

    private func fetchUserWeekSchedule() {
        guard let username = userManager.currentUser?.username else { return }

        guard let url = URL(string: "\(API.baseURL)/pantry/user-schedule/\(username)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let result = try JSONDecoder().decode(UserWeekScheduleResponse.self, from: data)
                DispatchQueue.main.async {
                    // Sort by date
                    self.userWeekSchedule = result.schedules.sorted { $0.date < $1.date }
                }
            } catch {
                DispatchQueue.main.async {
                    self.userWeekSchedule = []
                }
            }
        }.resume()
    }
}

struct PantryCard: View {
    let pantry: Pantry
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            PLCard {
                HStack(spacing: PL.spacingM) {
                    VStack(alignment: .leading, spacing: PL.spacingS) {
                        Text(pantry.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)

                        if let address = pantry.address {
                            Text(address)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                        }

                        // Show if scheduling is available
                        if let settings = pantry.schedule_settings {
                            if settings.isSchedulingEnabled {
                                Label("Accepting volunteers", systemImage: "checkmark.circle.fill")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(PL.good)
                            } else {
                                Label("Not accepting volunteers right now", systemImage: "pause.circle")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    Spacer(minLength: 0)

                    Image(systemName: "chevron.right")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
            }
        }
        .buttonStyle(.plain)
        .frame(minHeight: PL.tapTarget)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens this pantry's volunteer schedule")
    }
}

struct WeekScheduleCard: View {
    let item: UserWeekScheduleItem
    let onTap: () -> Void

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: item.date) else { return item.date }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "EEEE, MMMM d"
        let fullDate = displayFormatter.string(from: date)

        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today - \(fullDate)"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow - \(fullDate)"
        } else {
            return fullDate
        }
    }

    var body: some View {
        Button(action: onTap) {
            PLCard {
                HStack(spacing: PL.spacingM) {
                    VStack(alignment: .leading, spacing: PL.spacingS) {
                        Label("You're signed up", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(PL.good)

                        Text(item.pantry_name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)

                        Text(formattedDate)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary)

                        Text(item.shift)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        if !item.time.isEmpty && item.time != "Flexible" {
                            Text(item.time)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer(minLength: 0)

                    Image(systemName: "chevron.right")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
            }
        }
        .buttonStyle(.plain)
        .frame(minHeight: PL.tapTarget)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens this pantry's volunteer schedule")
    }
}

#Preview {
    NavigationStack {
        ScheduleView()
    }
}
