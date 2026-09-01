//
//  PantryScheduleDetailView.swift
//  PantryLink
//
//  Created for volunteer scheduling system
//

import SwiftUI

struct PantryScheduleDetailView: View {
    let pantry: Pantry
    @ObservedObject private var userManager = UserManager.shared
    @Environment(\.dismiss) private var dismiss

    @State private var selectedDate = Date()
    @State private var scheduleData: ScheduleData = ScheduleData()
    @State private var isLoading = false
    @State private var loadErrorMessage: String?
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Available dates for the custom picker
    @State private var availableDates: [DateOption] = []

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    var settings: ScheduleSettings {
        pantry.schedule_settings ?? ScheduleSettings(
            schedulingEnabled: true,
            openDays: [1, 2, 3, 4, 5],
            excludedDates: [],
            useDefaultSchedule: false,
            defaultSchedule: nil
        )
    }

    private var selectedDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Date Selector
                CustomDateSelector(
                    selectedDate: $selectedDate,
                    availableDates: availableDates,
                    onDateChange: { fetchSchedule() }
                )

                Divider()

                // Content
                ScrollView {
                    if isLoading {
                        PLLoadingView(message: "Loading the schedule...")
                            .padding(.top, PL.spacingXL)
                    } else if let loadErrorMessage {
                        PLEmptyState(
                            icon: "wifi.exclamationmark",
                            title: "We couldn't load the schedule",
                            message: loadErrorMessage,
                            actionTitle: "Try Again",
                            action: { fetchSchedule() }
                        )
                        .padding(PL.spacingM)
                    } else {
                        VStack(alignment: .leading, spacing: PL.spacingM) {
                            Text(selectedDateText)
                                .font(.title3.bold())
                                .foregroundStyle(.primary)
                                .accessibilityAddTraits(.isHeader)

                            // Shifts
                            if scheduleData.shifts.isEmpty {
                                PLEmptyState(
                                    icon: "calendar.badge.exclamationmark",
                                    title: "No shifts on this day yet",
                                    message: "This pantry hasn't set up shifts for this day. You can still sign up as a general volunteer below, or try another day."
                                )
                            } else {
                                ForEach(scheduleData.shifts) { shift in
                                    ShiftCard(
                                        shift: shift,
                                        currentUsername: userManager.currentUser?.username ?? "",
                                        onAddSelf: { addSelfToShift(shiftId: shift.id) },
                                        onRemoveSelf: { removeSelfFromShift(shiftId: shift.id) }
                                    )
                                }
                            }

                            // General Volunteers Section
                            GeneralVolunteersCard(
                                volunteers: scheduleData.general_volunteers,
                                currentUsername: userManager.currentUser?.username ?? "",
                                onAddSelf: { addSelfToGeneral() },
                                onRemoveSelf: { removeSelfFromGeneral() }
                            )
                        }
                        .padding(PL.spacingM)
                        .padding(.bottom, PL.spacingXL)
                    }
                }
                .background(PL.background)
            }
            .navigationTitle(pantry.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                setupAvailableDates()
                fetchSchedule()
            }
            .alert("Schedule Update", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func setupAvailableDates() {
        var dates: [DateOption] = []
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        for i in 0..<14 {
            guard let date = calendar.date(byAdding: .day, value: i, to: today) else { continue }
            let dateKey = dateFormatter.string(from: date)

            // Determine if date is available
            let jsWeekday = calendar.component(.weekday, from: date) - 1 // 0=Sun

            let isOpenDay = settings.effectiveOpenDays.contains(jsWeekday)
            let isExcluded = settings.effectiveExcludedDates.contains(dateKey)
            let isAvailable = settings.isSchedulingEnabled && isOpenDay && !isExcluded

            dates.append(DateOption(date: date, dateKey: dateKey, isAvailable: isAvailable))
        }

        availableDates = dates

        // Select first available date
        if let firstAvailable = dates.first(where: { $0.isAvailable }) {
            selectedDate = firstAvailable.date
        }
    }

    private func fetchSchedule() {
        isLoading = true
        loadErrorMessage = nil
        let dateKey = dateFormatter.string(from: selectedDate)

        guard let url = URL(string: "\(API.baseURL)/pantry/\(pantry._id)/schedule?date=\(dateKey)") else {
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
                let scheduleResponse = try JSONDecoder().decode(ScheduleResponse.self, from: data)
                DispatchQueue.main.async {
                    self.scheduleData = scheduleResponse.schedule
                }
            } catch {
                DispatchQueue.main.async {
                    self.scheduleData = ScheduleData()
                }
            }
        }.resume()
    }

    // Check if user is already scheduled elsewhere
    private func checkConflict(completion: @escaping (UserConflictResponse?) -> Void) {
        guard let username = userManager.currentUser?.username else {
            completion(nil)
            return
        }

        let dateKey = dateFormatter.string(from: selectedDate)
        let urlString = "\(API.baseURL)/pantry/check-user-conflict?username=\(username)&date=\(dateKey)&exclude_pantry_id=\(pantry._id)"

        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(UserConflictResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }

    private func addSelfToShift(shiftId: Int) {
        guard let username = userManager.currentUser?.username,
              let firstName = userManager.currentUser?.first_name,
              let lastName = userManager.currentUser?.last_name,
              let email = userManager.currentUser?.email else {
            alertMessage = "User information not available"
            showAlert = true
            return
        }

        // Check if already in this shift
        if let shift = scheduleData.shifts.first(where: { $0.id == shiftId }),
           shift.volunteers.contains(where: { $0.username?.lowercased() == username.lowercased() }) {
            alertMessage = "You're already signed up for this shift"
            showAlert = true
            return
        }

        // Check for conflicts at other pantries
        checkConflict { conflict in
            if let conflict = conflict, conflict.scheduled, let pantryName = conflict.pantry_name {
                self.alertMessage = "You're already scheduled at \(pantryName) on this day. You can only volunteer at one pantry per day."
                self.showAlert = true
                return
            }

            // Also check if already in another shift or general at THIS pantry
            let isInOtherShift = self.scheduleData.shifts.contains { shift in
                shift.id != shiftId && shift.volunteers.contains { $0.username?.lowercased() == username.lowercased() }
            }
            let isInGeneral = self.scheduleData.general_volunteers.contains { $0.username?.lowercased() == username.lowercased() }

            if isInOtherShift || isInGeneral {
                self.alertMessage = "You're already signed up for this day. Remove yourself first before switching."
                self.showAlert = true
                return
            }

            let volunteerName = "\(firstName) \(lastName)"
            let newVolunteer = ShiftVolunteer(name: volunteerName, email: email, username: username)

            var updatedSchedule = self.scheduleData
            if let index = updatedSchedule.shifts.firstIndex(where: { $0.id == shiftId }) {
                var volunteers = updatedSchedule.shifts[index].volunteers
                volunteers.append(newVolunteer)
                let updatedShift = Shift(
                    id: updatedSchedule.shifts[index].id,
                    time: updatedSchedule.shifts[index].time,
                    shift: updatedSchedule.shifts[index].shift,
                    volunteers: volunteers
                )
                var shifts = updatedSchedule.shifts
                shifts[index] = updatedShift
                updatedSchedule = ScheduleData(shifts: shifts, general_volunteers: updatedSchedule.general_volunteers)
            }

            self.saveSchedule(updatedSchedule: updatedSchedule)
        }
    }

    private func removeSelfFromShift(shiftId: Int) {
        guard let username = userManager.currentUser?.username else { return }

        var updatedSchedule = scheduleData
        if let index = updatedSchedule.shifts.firstIndex(where: { $0.id == shiftId }) {
            let volunteers = updatedSchedule.shifts[index].volunteers.filter {
                $0.username?.lowercased() != username.lowercased()
            }
            let updatedShift = Shift(
                id: updatedSchedule.shifts[index].id,
                time: updatedSchedule.shifts[index].time,
                shift: updatedSchedule.shifts[index].shift,
                volunteers: volunteers
            )
            var shifts = updatedSchedule.shifts
            shifts[index] = updatedShift
            updatedSchedule = ScheduleData(shifts: shifts, general_volunteers: updatedSchedule.general_volunteers)
        }

        saveSchedule(updatedSchedule: updatedSchedule)
    }

    private func addSelfToGeneral() {
        guard let username = userManager.currentUser?.username,
              let firstName = userManager.currentUser?.first_name,
              let lastName = userManager.currentUser?.last_name,
              let email = userManager.currentUser?.email else {
            alertMessage = "User information not available"
            showAlert = true
            return
        }

        // Check if already in general
        if scheduleData.general_volunteers.contains(where: { $0.username?.lowercased() == username.lowercased() }) {
            alertMessage = "You're already signed up as a general volunteer"
            showAlert = true
            return
        }

        // Check for conflicts
        checkConflict { conflict in
            if let conflict = conflict, conflict.scheduled, let pantryName = conflict.pantry_name {
                self.alertMessage = "You're already scheduled at \(pantryName) on this day. You can only volunteer at one pantry per day."
                self.showAlert = true
                return
            }

            // Check if already in a shift at THIS pantry
            let isInShift = self.scheduleData.shifts.contains { shift in
                shift.volunteers.contains { $0.username?.lowercased() == username.lowercased() }
            }

            if isInShift {
                self.alertMessage = "You're already signed up for a shift. Remove yourself first before switching to general."
                self.showAlert = true
                return
            }

            let volunteerName = "\(firstName) \(lastName)"
            let newVolunteer = ShiftVolunteer(name: volunteerName, email: email, username: username)

            var generalVolunteers = self.scheduleData.general_volunteers
            generalVolunteers.append(newVolunteer)
            let updatedSchedule = ScheduleData(shifts: self.scheduleData.shifts, general_volunteers: generalVolunteers)

            self.saveSchedule(updatedSchedule: updatedSchedule)
        }
    }

    private func removeSelfFromGeneral() {
        guard let username = userManager.currentUser?.username else { return }

        let generalVolunteers = scheduleData.general_volunteers.filter {
            $0.username?.lowercased() != username.lowercased()
        }
        let updatedSchedule = ScheduleData(shifts: scheduleData.shifts, general_volunteers: generalVolunteers)

        saveSchedule(updatedSchedule: updatedSchedule)
    }

    private func saveSchedule(updatedSchedule: ScheduleData) {
        let dateKey = dateFormatter.string(from: selectedDate)
        guard let url = URL(string: "\(API.baseURL)/pantry/\(pantry._id)/schedule/\(dateKey)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            // Create payload in new format
            let payload: [String: Any] = [
                "schedule": [
                    "shifts": updatedSchedule.shifts.map { shift in
                        [
                            "id": shift.id,
                            "time": shift.time,
                            "shift": shift.shift,
                            "volunteers": shift.volunteers.map { vol in
                                ["name": vol.name, "email": vol.email ?? "", "username": vol.username ?? ""]
                            }
                        ]
                    },
                    "general_volunteers": updatedSchedule.general_volunteers.map { vol in
                        ["name": vol.name, "email": vol.email ?? "", "username": vol.username ?? ""]
                    }
                ]
            ]

            request.httpBody = try JSONSerialization.data(withJSONObject: payload)

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.alertMessage = "We couldn't save your change: \(error.localizedDescription). Please try again."
                        self.showAlert = true
                    } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        self.alertMessage = "All set! Your schedule has been updated."
                        self.showAlert = true
                        self.fetchSchedule()
                    } else {
                        self.alertMessage = "We couldn't save your change. Please check your connection and try again."
                        self.showAlert = true
                    }
                }
            }.resume()
        } catch {
            alertMessage = "We couldn't save your change. Please try again."
            showAlert = true
        }
    }
}

// MARK: - Date Option Model
struct DateOption: Identifiable {
    let date: Date
    let dateKey: String
    let isAvailable: Bool

    var id: String { dateKey }

    /// Short label for the picker, e.g. "Today" or "Tuesday".
    var dayText: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
    }

    /// Short date, e.g. "Mar 4".
    var shortDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    /// Full date read aloud by VoiceOver, e.g. "Tuesday, March 4".
    var fullDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Custom Date Selector
struct CustomDateSelector: View {
    @Binding var selectedDate: Date
    let availableDates: [DateOption]
    let onDateChange: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: PL.spacingXS) {
            Text("Pick a day")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .padding(.horizontal, PL.spacingM)
                .padding(.top, PL.spacingS)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: PL.spacingS) {
                    ForEach(availableDates) { option in
                        DateButton(
                            option: option,
                            isSelected: Calendar.current.isDate(selectedDate, inSameDayAs: option.date),
                            onTap: {
                                if option.isAvailable {
                                    selectedDate = option.date
                                    onDateChange()
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, PL.spacingM)
                .padding(.vertical, PL.spacingS)
            }
        }
        .background(PL.background)
    }
}

struct DateButton: View {
    let option: DateOption
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: PL.spacingXS) {
                Text(option.dayText)
                    .font(.subheadline.weight(isSelected ? .bold : .medium))

                Text(option.shortDateText)
                    .font(.caption)
            }
            .padding(.horizontal, PL.spacingM)
            .padding(.vertical, PL.spacingS)
            .frame(minWidth: PL.tapTarget, minHeight: PL.tapTarget)
            .background(isSelected ? PL.accent : PL.cardBackground)
            .foregroundStyle(isSelected ? Color.white : (option.isAvailable ? Color.primary : Color.secondary))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? PL.accent : Color(.separator), lineWidth: 1)
            )
            .opacity(option.isAvailable ? 1.0 : 0.5)
        }
        .disabled(!option.isAvailable)
        .accessibilityLabel(option.fullDateText)
        .accessibilityHint(option.isAvailable ? "Shows this day's schedule" : "The pantry is closed this day")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Shift Card
struct ShiftCard: View {
    let shift: Shift
    let currentUsername: String
    let onAddSelf: () -> Void
    let onRemoveSelf: () -> Void

    var isUserInShift: Bool {
        shift.volunteers.contains(where: { $0.username?.lowercased() == currentUsername.lowercased() })
    }

    var body: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingM) {
                VStack(alignment: .leading, spacing: PL.spacingXS) {
                    Text(shift.shift)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(shift.time)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if isUserInShift {
                        Label("You're signed up", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(PL.good)
                    }
                }
                .accessibilityElement(children: .combine)

                // Join / Leave button
                if isUserInShift {
                    Button(action: onRemoveSelf) {
                        Label("Leave This Shift", systemImage: "minus.circle.fill")
                            .font(.body.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: PL.tapTarget)
                    }
                    .buttonStyle(.bordered)
                    .tint(PL.critical)
                } else {
                    Button(action: onAddSelf) {
                        Label("Join This Shift", systemImage: "plus.circle.fill")
                            .font(.body.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: PL.tapTarget)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(PL.accent)
                }

                if !shift.volunteers.isEmpty {
                    Divider()

                    VStack(alignment: .leading, spacing: PL.spacingS) {
                        Text("Volunteers (\(shift.volunteers.count))")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)

                        ForEach(shift.volunteers) { volunteer in
                            VolunteerRow(
                                volunteer: volunteer,
                                isCurrentUser: volunteer.username?.lowercased() == currentUsername.lowercased()
                            )
                        }
                    }
                    .accessibilityElement(children: .combine)
                } else {
                    Text("No volunteers yet - be the first!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Volunteer Row
struct VolunteerRow: View {
    let volunteer: ShiftVolunteer
    let isCurrentUser: Bool

    var body: some View {
        HStack(spacing: PL.spacingS) {
            Image(systemName: isCurrentUser ? "person.fill.checkmark" : "person.fill")
                .font(.caption)
                .foregroundStyle(isCurrentUser ? PL.good : Color.secondary)
                .accessibilityHidden(true)

            Text(volunteer.name)
                .font(.subheadline)
                .foregroundStyle(.primary)

            if isCurrentUser {
                Text("(You)")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(PL.good)
            }
        }
    }
}

// MARK: - General Volunteers Card
struct GeneralVolunteersCard: View {
    let volunteers: [ShiftVolunteer]
    let currentUsername: String
    let onAddSelf: () -> Void
    let onRemoveSelf: () -> Void

    var isUserInGeneral: Bool {
        volunteers.contains(where: { $0.username?.lowercased() == currentUsername.lowercased() })
    }

    var body: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingM) {
                VStack(alignment: .leading, spacing: PL.spacingXS) {
                    Text("General Volunteers")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("Help out anytime during the day - no set shift")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if isUserInGeneral {
                        Label("You're signed up", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(PL.good)
                    }
                }
                .accessibilityElement(children: .combine)

                // Join / Leave button
                if isUserInGeneral {
                    Button(action: onRemoveSelf) {
                        Label("Leave General Volunteering", systemImage: "minus.circle.fill")
                            .font(.body.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: PL.tapTarget)
                    }
                    .buttonStyle(.bordered)
                    .tint(PL.critical)
                } else {
                    Button(action: onAddSelf) {
                        Label("Join as General Volunteer", systemImage: "plus.circle.fill")
                            .font(.body.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: PL.tapTarget)
                    }
                    .buttonStyle(.bordered)
                    .tint(PL.accent)
                }

                if !volunteers.isEmpty {
                    Divider()

                    VStack(alignment: .leading, spacing: PL.spacingS) {
                        ForEach(volunteers) { volunteer in
                            VolunteerRow(
                                volunteer: volunteer,
                                isCurrentUser: volunteer.username?.lowercased() == currentUsername.lowercased()
                            )
                        }
                    }
                    .accessibilityElement(children: .combine)
                } else {
                    Text("No general volunteers yet")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
