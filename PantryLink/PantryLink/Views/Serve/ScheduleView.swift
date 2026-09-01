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
    @State private var selectedPantryId: String?
    @State private var showPantrySchedule = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Your Week at a Glance Section (only show if user has schedules)
                if !userWeekSchedule.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Week at a Glance")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Colors.flexibleBlack)
                            .padding(.horizontal)
                        
                        Text("Your upcoming volunteer shifts for the next 7 days")
                            .font(.subheadline)
                            .foregroundColor(Colors.flexibleDarkGray)
                            .padding(.horizontal)
                        
                        ForEach(userWeekSchedule) { item in
                            WeekScheduleCard(item: item, onTap: {
                                if let pantry = pantries.first(where: { $0._id == item.pantry_id }) {
                                    selectedPantryId = pantry._id
                                    showPantrySchedule = true
                                }
                            })
                        }
                    }
                    .padding(.top)
                    
                    Divider()
                        .padding(.vertical)
                }
                
                // All Pantries Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Available Opportunities")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Colors.flexibleBlack)
                        .padding(.horizontal)
                    
                    Text("Tap a pantry to view their schedule and sign up")
                        .font(.subheadline)
                        .foregroundColor(Colors.flexibleDarkGray)
                        .padding(.horizontal)
                    
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if pantries.isEmpty {
                        Text("No food pantries available")
                            .foregroundColor(Colors.flexibleDarkGray)
                            .frame(maxWidth: .infinity, minHeight: 200)
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
            .padding(.bottom, 100)
        }
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
        
        guard let url = URL(string: "\(API.baseURL)/pantry/") else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { DispatchQueue.main.async { isLoading = false } }
            
            guard let data = data, error == nil else {
                print("Error fetching pantries: \(error?.localizedDescription ?? "Unknown")")
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
                print("Error decoding pantries: \(error)")
            }
        }.resume()
    }
    
    private func fetchUserWeekSchedule() {
        guard let username = userManager.currentUser?.username else { return }
        
        guard let url = URL(string: "\(API.baseURL)/pantry/user-schedule/\(username)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching user schedule: \(error?.localizedDescription ?? "Unknown")")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(UserWeekScheduleResponse.self, from: data)
                DispatchQueue.main.async {
                    // Sort by date
                    self.userWeekSchedule = result.schedules.sorted { $0.date < $1.date }
                }
            } catch {
                print("Error decoding user schedule: \(error)")
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
            VStack(alignment: .leading, spacing: 8) {
                Text(pantry.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Colors.flexibleBlack)
                
                if let address = pantry.address {
                    Text(address)
                        .font(.subheadline)
                        .foregroundColor(Colors.flexibleDarkGray)
                }
                
                // Show if scheduling is available
                if let settings = pantry.schedule_settings {
                    if settings.isSchedulingEnabled {
                        Text("Accepting volunteers")
                            .font(.caption)
                            .foregroundColor(Colors.flexibleGreen)
                    } else {
                        Text("Not accepting volunteers")
                            .font(.caption)
                            .foregroundColor(Colors.flexibleDarkGray)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Colors.flexibleLightGray.opacity(0.3))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Colors.flexibleLightGray, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

struct WeekScheduleCard: View {
    let item: UserWeekScheduleItem
    let onTap: () -> Void
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: item.date) else { return item.date }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "EEE, MMM d"
            return displayFormatter.string(from: date)
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.pantry_name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Colors.flexibleBlack)
                        
                        HStack(spacing: 4) {
                            Text(formattedDate)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Colors.flexibleOrange)
                            Text("•")
                                .foregroundColor(Colors.flexibleDarkGray)
                            Text(item.shift)
                                .font(.subheadline)
                                .foregroundColor(Colors.flexibleBlack)
                        }
                        
                        if !item.time.isEmpty && item.time != "Flexible" {
                            Text(item.time)
                                .font(.caption)
                                .foregroundColor(Colors.flexibleDarkGray)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(Colors.flexibleDarkGray)
                }
            }
            .padding()
            .background(Colors.flexibleOrange.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Colors.flexibleOrange, lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}
