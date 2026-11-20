//
//  ServeView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 1/25/26.
//
import SwiftUI

struct ServePageView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isGuest") private var isGuest = false
    @ObservedObject private var userManager = UserManager.shared
    @Binding var path: NavigationPath

    @State private var isCheckingSignup = false
    @State private var isCheckingSchedule = false
    @State private var showNotVolunteerAlert = false
    @State private var showAlreadyVolunteerAlert = false

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: PL.spacingL) {
                    header

                    if isGuest {
                        guestSection
                    } else {
                        volunteerSection
                        donateSection
                    }
                }
                .padding(PL.spacingM)
                .padding(.bottom, PL.spacingXL)
            }
            .background(PL.background.ignoresSafeArea())
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "Volunteer":
                    VolunteerView(path: $path)
                case "Schedule":
                    ScheduleView()
                case "Donation":
                    DonationView()
                default:
                    EmptyView()
                }
            }
            .alert("You're Already Signed Up", isPresented: $showAlreadyVolunteerAlert) {
                Button("View My Schedule") {
                    path.append("Schedule")
                }
                Button("OK", role: .cancel) { }
            } message: {
                Text("Good news - you already have a volunteer account. Use \"My Volunteer Schedule\" to see available shifts and sign up.")
            }
            .alert("Become a Volunteer First", isPresented: $showNotVolunteerAlert) {
                Button("Sign Up Now") {
                    path.append("Volunteer")
                }
                Button("Not Now", role: .cancel) { }
            } message: {
                Text("To see and manage shifts, you first need to sign up as a volunteer. It only takes a few minutes. Would you like to sign up now?")
            }
        }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: PL.spacingS) {
            Image(systemName: "heart.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(PL.accent)
                .accessibilityHidden(true)

            Text("Serve Your Community")
                .font(.largeTitle.bold())
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            Text("This is where you can help your local food pantries - by volunteering your time or giving a donation. Every bit of help matters.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, PL.spacingM)
        .accessibilityElement(children: .combine)
    }

    private var guestSection: some View {
        PLCard {
            PLEmptyState(
                icon: "person.crop.circle.badge.plus",
                title: "We're glad you want to help!",
                message: "To volunteer or donate, you first need a free PantryLink account. It only takes a minute to create one.",
                actionTitle: "Create an Account",
                action: {
                    isLoggedIn = false
                    isGuest = false
                }
            )
        }
    }

    private var volunteerSection: some View {
        VStack(alignment: .leading, spacing: PL.spacingM) {
            PLSectionHeader(
                title: "Volunteer",
                subtitle: "Give your time at a nearby food pantry. New here? Start by signing up."
            )

            PLPrimaryButton(
                title: "Sign Up to Volunteer",
                systemImage: "person.badge.plus",
                isLoading: isCheckingSignup,
                action: { checkAndNavigateToVolunteerSignup() }
            )
            .disabled(isCheckingSchedule)

            PLSecondaryButton(
                title: "My Volunteer Schedule",
                systemImage: "calendar",
                action: { checkAndNavigateToSchedule() }
            )
            .disabled(isCheckingSignup || isCheckingSchedule)

            if isCheckingSchedule {
                PLLoadingView(message: "Checking your volunteer account...")
            }
        }
    }

    private var donateSection: some View {
        VStack(alignment: .leading, spacing: PL.spacingM) {
            PLSectionHeader(
                title: "Donate",
                subtitle: "Support pantries with food or funds - no signup needed."
            )

            PLSecondaryButton(
                title: "Make a Donation",
                systemImage: "heart.fill",
                action: { path.append("Donation") }
            )
        }
    }

    // MARK: - Networking

    private func checkVolunteerExists() async -> Bool {
        guard let username = userManager.currentUser?.username else {
            return false
        }

        // URL encode the username to handle special characters
        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(API.baseURL)/volunteer/check/\(encodedUsername)") else {
            return false
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return false
            }

            struct VolunteerCheckResponse: Codable {
                let exists: Bool
                let message: String
            }

            if let result = try? JSONDecoder().decode(VolunteerCheckResponse.self, from: data) {
                return result.exists
            }

            return false
        } catch {
            return false
        }
    }

    private func checkAndNavigateToVolunteerSignup() {
        Task {
            isCheckingSignup = true
            let exists = await checkVolunteerExists()

            await MainActor.run {
                isCheckingSignup = false
                if exists {
                    showAlreadyVolunteerAlert = true
                } else {
                    path.append("Volunteer")
                }
            }
        }
    }

    private func checkAndNavigateToSchedule() {
        Task {
            isCheckingSchedule = true
            let exists = await checkVolunteerExists()

            await MainActor.run {
                isCheckingSchedule = false
                if exists {
                    path.append("Schedule")
                } else {
                    showNotVolunteerAlert = true
                }
            }
        }
    }
}

#Preview {
    ServePageView(path: .constant(NavigationPath()))
}
