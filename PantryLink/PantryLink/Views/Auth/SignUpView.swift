//
//  SignUpView.swift
//  PantryLink
//
//  Created by Naisha Singh on 10/4/25.
//

import SwiftUI

struct SignUpView: View {
    @Binding var path: NavigationPath

    // User details
    @State private var first_name: String = ""
    @State private var last_name: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var phone_number: String = ""

    // Validation and submission state
    @State private var fieldErrors: [Field: String] = [:]
    @State private var submitError: String?
    @State private var isLoading = false

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private enum Field: Hashable {
        case username, password, firstName, lastName, email
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: PL.spacingL) {
                PLSectionHeader(
                    title: "Create your account",
                    subtitle: "It only takes a minute. We'll use this to save your favorite pantries."
                )

                // Login details
                PLCard {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        Text("Login details")
                            .font(.headline)

                        PLTextField(
                            label: "Username (required)",
                            text: $username,
                            placeholder: "Pick a username",
                            contentType: .username
                        )
                        fieldErrorView(for: .username)

                        PLTextField(
                            label: "Password (required)",
                            text: $password,
                            placeholder: "Pick a password",
                            isSecure: true,
                            contentType: .newPassword
                        )
                        fieldErrorView(for: .password)
                    }
                }

                // About you
                PLCard {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        Text("About you")
                            .font(.headline)

                        PLTextField(
                            label: "First name (required)",
                            text: $first_name,
                            placeholder: "Your first name",
                            contentType: .givenName,
                            autocapitalization: .words
                        )
                        fieldErrorView(for: .firstName)

                        PLTextField(
                            label: "Last name (required)",
                            text: $last_name,
                            placeholder: "Your last name",
                            contentType: .familyName,
                            autocapitalization: .words
                        )
                        fieldErrorView(for: .lastName)

                        PLTextField(
                            label: "Email (required)",
                            text: $email,
                            placeholder: "name@example.com",
                            keyboard: .emailAddress,
                            contentType: .emailAddress
                        )
                        fieldErrorView(for: .email)

                        PLTextField(
                            label: "Phone number (optional)",
                            text: phoneBinding,
                            placeholder: "(555)555-5555",
                            keyboard: .numberPad,
                            contentType: .telephoneNumber
                        )
                    }
                }

                // Submit
                VStack(alignment: .leading, spacing: PL.spacingM) {
                    if let submitError {
                        Label(submitError, systemImage: "exclamationmark.triangle.fill")
                            .font(.subheadline)
                            .foregroundStyle(PL.critical)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    PLPrimaryButton(
                        title: "Create Account",
                        systemImage: "checkmark.circle.fill",
                        isLoading: isLoading
                    ) {
                        submit()
                    }

                    if isLoading {
                        Text("Setting up your account...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    PLSecondaryButton(
                        title: "I already have an account",
                        systemImage: "person.crop.circle"
                    ) {
                        path.removeLast()
                    }
                    .disabled(isLoading)
                }
            }
            .padding(PL.spacingM)
            .frame(maxWidth: .infinity)
        }
        .background(PL.background)
        .animation(reduceMotion ? nil : .default, value: submitError)
        .animation(reduceMotion ? nil : .default, value: fieldErrors)
    }

    // Formats typed digits as (555)555-5555, digits only, max 10.
    private var phoneBinding: Binding<String> {
        Binding(
            get: { phone_number },
            set: { newValue in
                let digits = newValue.filter { $0.isWholeNumber }
                let limited = digits.prefix(10)
                var formatted = ""
                if limited.count > 0 {
                    formatted += "("
                    formatted += limited.prefix(3)
                }
                if limited.count > 3 {
                    formatted += ")"
                    formatted += limited.dropFirst(3).prefix(3)
                }
                if limited.count > 6 {
                    formatted += "-"
                    formatted += limited.dropFirst(6)
                }
                phone_number = formatted
            }
        )
    }

    @ViewBuilder
    private func fieldErrorView(for field: Field) -> some View {
        if let message = fieldErrors[field] {
            Label(message, systemImage: "exclamationmark.circle.fill")
                .font(.subheadline)
                .foregroundStyle(PL.critical)
        }
    }

    private func validate() -> Bool {
        var errors: [Field: String] = [:]
        if username.trimmingCharacters(in: .whitespaces).isEmpty {
            errors[.username] = "Please choose a username."
        }
        if password.isEmpty {
            errors[.password] = "Please choose a password."
        }
        if first_name.trimmingCharacters(in: .whitespaces).isEmpty {
            errors[.firstName] = "Please enter your first name."
        }
        if last_name.trimmingCharacters(in: .whitespaces).isEmpty {
            errors[.lastName] = "Please enter your last name."
        }
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        if trimmedEmail.isEmpty {
            errors[.email] = "Please enter your email address."
        } else if !trimmedEmail.contains("@") || !trimmedEmail.contains(".") {
            errors[.email] = "That email doesn't look right. It should look like name@example.com."
        }
        fieldErrors = errors
        return errors.isEmpty
    }

    private func submit() {
        submitError = nil
        guard validate() else {
            submitError = "Please fix the highlighted fields above, then try again."
            return
        }

        isLoading = true
        Task {
            let userData = User(
                username: username,
                password: password,
                first_name: first_name,
                last_name: last_name,
                email: email,
                phone_number: phone_number
            )

            let result = await signUp(user: userData)
            isLoading = false

            if result.success {
                // Store user data (without password)
                let userToStore = User(
                    username: userData.username,
                    password: "",
                    first_name: userData.first_name,
                    last_name: userData.last_name,
                    email: userData.email,
                    phone_number: userData.phone_number
                )
                UserManager.shared.setUser(userToStore)
                isLoggedIn = true
            } else {
                submitError = result.message ?? "We couldn't create your account. Please try again."
            }
        }
    }
}

#Preview {
    SignUpView(path: .constant(NavigationPath()))
}
