//
//  SignInView.swift
//  PantryLink
//
//  Created by Naisha Singh on 10/6/25.
//

import SwiftUI

struct SignInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

    @Binding var path: NavigationPath
    @Binding var isLoggedIn: Bool
    @Binding var isGuest: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PL.spacingL) {
                // Welcoming header
                VStack(alignment: .leading, spacing: PL.spacingS) {
                    Text("PantryLink")
                        .font(.largeTitle.bold())
                        .foregroundStyle(PL.accent)
                    Text("Find food pantries near you and see what they have today.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isHeader)

                // Sign-in fields
                PLCard {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        PLSectionHeader(
                            title: "Sign in",
                            subtitle: "Welcome back. Enter your details below."
                        )

                        PLTextField(
                            label: "Username",
                            text: $username,
                            placeholder: "Your username",
                            contentType: .username
                        )

                        PLTextField(
                            label: "Password",
                            text: $password,
                            placeholder: "Your password",
                            isSecure: true,
                            contentType: .password
                        )

                        if let errorMessage {
                            Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                                .font(.subheadline)
                                .foregroundStyle(PL.critical)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        PLPrimaryButton(
                            title: "Sign In",
                            systemImage: "arrow.right.circle.fill",
                            isLoading: isLoading
                        ) {
                            signIn()
                        }
                        .accessibilityHint("Signs in with the username and password you entered")

                        if isLoading {
                            Text("Signing you in...")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }

                // New account
                PLCard {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        Text("New to PantryLink?")
                            .font(.headline)
                        PLSecondaryButton(
                            title: "Create an account",
                            systemImage: "person.badge.plus"
                        ) {
                            path.append("SignUp")
                        }
                        .disabled(isLoading)
                    }
                }

                // Guest option
                PLCard {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        Text("Just browsing? You can look up pantries and their food without an account.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        PLSecondaryButton(
                            title: "Continue without an account",
                            systemImage: "person.fill.questionmark"
                        ) {
                            isLoggedIn = true
                            isGuest = true
                        }
                        .disabled(isLoading)
                    }
                }
            }
            .padding(PL.spacingM)
            .frame(maxWidth: .infinity)
        }
        .background(PL.background)
        .animation(reduceMotion ? nil : .default, value: errorMessage)
    }

    private func signIn() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both your username and your password."
            return
        }

        errorMessage = nil
        isLoading = true

        Task {
            let authData = AuthData(username: username, password: password)
            let result = await login_user(authData: authData)
            isLoading = false

            switch result {
            case .success:
                isLoggedIn = true
            case .failure:
                errorMessage = "We couldn't sign you in. Check your username and password and try again."
            }
        }
    }
}

#Preview {
    SignInView(
        path: .constant(NavigationPath()),
        isLoggedIn: .constant(false),
        isGuest: .constant(false)
    )
}
