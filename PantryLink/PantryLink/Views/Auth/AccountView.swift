//
//  AccountView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 1/2/26.
//

import SwiftUI

struct AccountView: View {
    @Binding var path: NavigationPath
    @State private var showDeleteConfirmation = false
    @State private var showDeleteResult = false
    @State private var deleteSucceeded = false
    @State private var isDeleting = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isGuest") private var isGuest = false
    @ObservedObject private var userManager = UserManager.shared
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PL.spacingL) {
                if isGuest {
                    guestSection
                } else {
                    profileSection
                    signOutSection
                    deleteSection
                }
                creditsSection
            }
            .padding(PL.spacingM)
            .frame(maxWidth: .infinity)
        }
        .background(PL.background)
        .navigationTitle("Account")
        .animation(reduceMotion ? nil : .default, value: isDeleting)
        .confirmationDialog(
            "Are you sure?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete My Account", role: .destructive) {
                Task {
                    isDeleting = true
                    deleteSucceeded = await deleteAccount()
                    isDeleting = false
                    showDeleteResult = true
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Deleting your account is permanent. Your saved information will be removed and can't be brought back.")
        }
        .alert(
            deleteSucceeded ? "Account Deleted" : "Something Went Wrong",
            isPresented: $showDeleteResult
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(deleteSucceeded
                 ? "Your account has been deleted."
                 : "We couldn't delete your account right now. Please try again in a few minutes.")
        }
    }

    // MARK: - Guest

    private var guestSection: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingM) {
                PLSectionHeader(
                    title: "You're browsing as a guest",
                    subtitle: "Sign in or create an account to save your information."
                )
                PLPrimaryButton(
                    title: "Sign In",
                    systemImage: "person.crop.circle"
                ) {
                    isLoggedIn = false
                    isGuest = false
                }
            }
        }
    }

    // MARK: - Profile

    private var profileSection: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingM) {
                PLSectionHeader(title: "Your information")
                infoRow(label: "Username", value: userManager.currentUser?.username)
                infoRow(label: "First name", value: userManager.currentUser?.first_name)
                infoRow(label: "Last name", value: userManager.currentUser?.last_name)
                infoRow(label: "Email", value: userManager.currentUser?.email)
                infoRow(label: "Phone number", value: userManager.currentUser?.phone_number)
            }
        }
    }

    private func infoRow(label: String, value: String?) -> some View {
        VStack(alignment: .leading, spacing: PL.spacingXS) {
            Text(label)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
            Text((value?.isEmpty == false ? value! : "Not provided"))
                .font(.body)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Sign out

    private var signOutSection: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingM) {
                Text("Signing out keeps your account safe on shared phones. You can sign back in any time.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                PLSecondaryButton(
                    title: "Sign Out",
                    systemImage: "rectangle.portrait.and.arrow.right"
                ) {
                    isLoggedIn = false
                }
            }
        }
    }

    // MARK: - Delete account

    private var deleteSection: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingM) {
                Text("Delete account")
                    .font(.headline)
                    .foregroundStyle(PL.critical)
                Text("This permanently removes your account and information. This can't be undone.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if isDeleting {
                    PLLoadingView(message: "Deleting your account...")
                } else {
                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        HStack(spacing: PL.spacingS) {
                            Image(systemName: "trash.fill")
                                .accessibilityHidden(true)
                            Text("Delete My Account")
                                .font(.body.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity, minHeight: PL.tapTarget)
                    }
                    .buttonStyle(.bordered)
                    .tint(PL.critical)
                }
            }
        }
    }

    // MARK: - Credits

    private var creditsSection: some View {
        PLCard {
            VStack(alignment: .leading, spacing: PL.spacingS) {
                PLSectionHeader(title: "Credits", subtitle: "Made with ❤️ by the Yellow Team")
                Link(destination: URL(string: "https://joshuasambol.com")!) {
                    Text("Joshua Sambol")
                        .font(.body)
                        .underline()
                        .frame(minHeight: PL.tapTarget, alignment: .leading)
                }
                .tint(PL.accent)
                Text("Michael Youtz")
                Text("Nippur Bhavsar")
                Text("Naisha Singh")
                Text("Sina Hernandez")
                (
                    Text("PantryLink was recognized as a winner of the 2025 ") +
                    Text("[Congressional App Challenge](https://congressionalappchallenge.us)")
                        .foregroundColor(PL.accent)
                        .underline()
                )
                .font(.subheadline)
                .padding(.top, PL.spacingS)
            }
            .font(.body)
        }
    }
}

extension AccountView {
    /// Deletes the account on the server. Returns true on success.
    func deleteAccount() async -> Bool {
        guard let username = userManager.currentUser?.username,
              let url = URL(string: "\(API.baseURL)/user/delete") else {
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(["username": username])
            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                await MainActor.run {
                    userManager.clearUser()
                    isLoggedIn = false
                }
                return true
            }
            return false
        } catch {
            return false
        }
    }
}

#Preview {
    AccountView(path: .constant(NavigationPath()))
}
