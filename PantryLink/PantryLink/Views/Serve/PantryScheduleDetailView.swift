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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Date Selector
                CustomDateSelector(
                    selectedDate: $selectedDate,
                    availableDates: availableDates,
                    onDateChange: { fetchSchedule() }
                )
                
                Divider()
                
                // Content
                ScrollView {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 300)
                    } else {
                        VStack(spacing: 16) {
                            // Shifts
                            if scheduleData.shifts.isEmpty {
                                VStack(spacing: 16) {
                                    Text("No shifts available for this day")
                                        .font(.headline)
                                        .foregroundColor(Colors.flexibleDarkGray)
                                        .padding(.top, 40)
                                    
                                    Text("The pantry hasn't set up shifts yet")
                                        .font(.subheadline)
                                        .foregroundColor(Colors.flexibleDarkGray)
                                }
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
                        .padding()
                    }
                }
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
            let dayOfWeek = (calendar.component(.weekday, from: date) + 5) % 7 // Convert to JS format (0=Sun)
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
        let dateKey = dateFormatter.string(from: selectedDate)
        
        guard let url = URL(string: "\(API.baseURL)/pantry/\(pantry._id)/schedule?date=\(dateKey)") else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { DispatchQueue.main.async { isLoading = false } }
            
            guard let data = data, error == nil else {
                print("Error fetching schedule: \(error?.localizedDescription ?? "Unknown")")
                return
            }
            
            do {
                let scheduleResponse = try JSONDecoder().decode(ScheduleResponse.self, from: data)
                DispatchQueue.main.async {
                    self.scheduleData = scheduleResponse.schedule
                }
            } catch {
                print("Error decoding schedule: \(error)")
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
                        self.alertMessage = "Failed to update schedule: \(error.localizedDescription)"
                        self.showAlert = true
                    } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        self.alertMessage = "Schedule updated!"
                        self.showAlert = true
                        self.fetchSchedule()
                    } else {
                        self.alertMessage = "Failed to update schedule"
                        self.showAlert = true
                    }
                }
            }.resume()
        } catch {
            alertMessage = "Failed to encode schedule"
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
    
    var displayText: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE d"
            return formatter.string(from: date)
        }
    }
}

// MARK: - Custom Date Selector
struct CustomDateSelector: View {
    @Binding var selectedDate: Date
    let availableDates: [DateOption]
    let onDateChange: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
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
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Colors.flexibleLightGray.opacity(0.2))
    }
}

struct DateButton: View {
    let option: DateOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(option.displayText)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
                
                let formatter = DateFormatter()
                let _ = formatter.dateFormat = "MMM"
                Text(formatter.string(from: option.date))
                    .font(.caption2)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isSelected ? Colors.flexibleOrange :
                option.isAvailable ? Colors.flexibleWhite : Colors.flexibleLightGray
            )
            .foregroundColor(
                isSelected ? Colors.flexibleWhite :
                option.isAvailable ? Colors.flexibleBlack : Colors.flexibleDarkGray
            )
            .cornerRadius(8)
            .opacity(option.isAvailable ? 1.0 : 0.5)
        }
        .disabled(!option.isAvailable)
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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(shift.shift)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Colors.flexibleBlack)
                    
                    Text(shift.time)
                        .font(.subheadline)
                        .foregroundColor(Colors.flexibleDarkGray)
                }
                
                Spacer()
                
                // Add/Remove button
                if isUserInShift {
                    Button(action: onRemoveSelf) {
                        HStack(spacing: 4) {
                            Image(systemName: "minus.circle.fill")
                            Text("Leave")
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(16)
                    }
                } else {
                    Button(action: onAddSelf) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                            Text("Join")
                        }
                        .font(.caption)
                        .foregroundColor(Colors.flexibleOrange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Colors.flexibleOrange.opacity(0.1))
                        .cornerRadius(16)
                    }
                }
            }
            
            if !shift.volunteers.isEmpty {
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Volunteers (\(shift.volunteers.count))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Colors.flexibleDarkGray)
                    
                    ForEach(shift.volunteers) { volunteer in
                        HStack {
                            Circle()
                                .fill(volunteer.username?.lowercased() == currentUsername.lowercased() ?
                                      Colors.flexibleOrange : Colors.flexibleLightGray)
                                .frame(width: 6, height: 6)
                            
                            Text(volunteer.name)
                                .font(.subheadline)
                                .foregroundColor(Colors.flexibleBlack)
                            
                            if volunteer.username?.lowercased() == currentUsername.lowercased() {
                                Text("(You)")
                                    .font(.caption)
                                    .foregroundColor(Colors.flexibleOrange)
                            }
                        }
                    }
                }
            } else {
                Text("No volunteers yet - be the first!")
                    .font(.caption)
                    .foregroundColor(Colors.flexibleDarkGray)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(isUserInShift ? Colors.flexibleOrange.opacity(0.1) : Colors.flexibleLightGray.opacity(0.2))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isUserInShift ? Colors.flexibleOrange : Colors.flexibleLightGray, lineWidth: isUserInShift ? 1.5 : 1)
        )
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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("General Volunteers")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Colors.flexibleBlack)
                    
                    Text("Available throughout the day")
                        .font(.subheadline)
                        .foregroundColor(Colors.flexibleDarkGray)
                }
                
                Spacer()
                
                // Add/Remove button
                if isUserInGeneral {
                    Button(action: onRemoveSelf) {
                        HStack(spacing: 4) {
                            Image(systemName: "minus.circle.fill")
                            Text("Leave")
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(16)
                    }
                } else {
                    Button(action: onAddSelf) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                            Text("Join")
                        }
                        .font(.caption)
                        .foregroundColor(Colors.flexibleGreen)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Colors.flexibleGreen.opacity(0.1))
                        .cornerRadius(16)
                    }
                }
            }
            
            if !volunteers.isEmpty {
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(volunteers) { volunteer in
                        HStack {
                            Circle()
                                .fill(volunteer.username?.lowercased() == currentUsername.lowercased() ?
                                      Colors.flexibleGreen : Colors.flexibleLightGray)
                                .frame(width: 6, height: 6)
                            
                            Text(volunteer.name)
                                .font(.subheadline)
                                .foregroundColor(Colors.flexibleBlack)
                            
                            if volunteer.username?.lowercased() == currentUsername.lowercased() {
                                Text("(You)")
                                    .font(.caption)
                                    .foregroundColor(Colors.flexibleGreen)
                            }
                        }
                    }
                }
            } else {
                Text("No general volunteers yet")
                    .font(.caption)
                    .foregroundColor(Colors.flexibleDarkGray)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(isUserInGeneral ? Colors.flexibleGreen.opacity(0.1) : Color(UIColor.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isUserInGeneral ? Colors.flexibleGreen : Colors.flexibleLightGray, lineWidth: isUserInGeneral ? 1.5 : 1)
        )
    }
}
