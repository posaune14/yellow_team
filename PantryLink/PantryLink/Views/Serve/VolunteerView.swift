//
//  VolunteerView.swift
//  PantryLink
//
//  Volunteer signup form.
//

import SwiftUI

// Volunteer signup view, pushed from the Serve page.
struct VolunteerView: View {
    @ObservedObject private var userManager = UserManager.shared
    @Binding var path: NavigationPath

    // About you
    @State var username: String = ""
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var date_of_birth: String = ""

    // Contact
    @State var email: String = ""
    @State var phone_number: String = ""
    @State var zipcode: String = ""

    // Availability
    @State var roles: String = ""
    @State var availability: String = ""

    // Emergency contact
    @State var emergency_name: String = ""
    @State var emergency_number: String = ""

    // Alert state (also used by the legacy extension in VolunteerViewModel).
    @State var alert_message = ""
    @State var show_alert = false

    var body: some View {
        VolunteerContentView(
            userManager: userManager,
            username: $username,
            first_name: $first_name,
            last_name: $last_name,
            date_of_birth: $date_of_birth,
            email: $email,
            phone_number: $phone_number,
            zipcode: $zipcode,
            roles: $roles,
            availability: $availability,
            emergency_name: $emergency_name,
            emergency_number: $emergency_number,
            alert_message: $alert_message,
            show_alert: $show_alert,
            path: $path
        )
    }
}

// Shared content view for volunteer functionality.
// Note: check_volunteer_exists and register_volunteer live in an extension
// in ViewModels/VolunteerViewModel.swift and rely on alert_message/show_alert.
struct VolunteerContentView: View {
    @ObservedObject var userManager: UserManager
    @Binding var username: String
    @Binding var first_name: String
    @Binding var last_name: String
    @Binding var date_of_birth: String
    @Binding var email: String
    @Binding var phone_number: String
    @Binding var zipcode: String
    @Binding var roles: String
    @Binding var availability: String
    @Binding var emergency_name: String
    @Binding var emergency_number: String
    @Binding var alert_message: String
    @Binding var show_alert: Bool
    @Binding var path: NavigationPath

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var show_success = false
    @State private var isAutoFilled = false
    @State private var isSubmitting = false
    @State private var show_already_registered_alert = false

    // Date of birth is entered with a DatePicker; the string binding keeps
    // the MM/DD/YYYY format the server expects.
    @State private var dobDate: Date = Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
    @State private var hasChosenDOB = false

    // Set after a submit attempt so error messages only appear once the
    // person has tried to send the form.
    @State private var attemptedSubmit = false

    private var dobFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }

    // MARK: - Validation

    private var usernameError: String? {
        username.isEmpty ? "Please enter a username" : nil
    }
    private var firstNameError: String? {
        first_name.isEmpty ? "Please enter your first name" : nil
    }
    private var lastNameError: String? {
        last_name.isEmpty ? "Please enter your last name" : nil
    }
    private var dobError: String? {
        hasChosenDOB ? nil : "Please choose your date of birth"
    }
    private var emailError: String? {
        if email.isEmpty { return "Please enter your email address" }
        if !email.contains("@") || !email.contains(".") { return "Please enter a valid email address, like name@example.com" }
        return nil
    }
    private var phoneError: String? {
        phone_number.isEmpty ? "Please enter your phone number" : nil
    }
    private var zipcodeError: String? {
        zipcode.isEmpty ? "Please enter your ZIP code" : nil
    }
    private var rolesError: String? {
        roles.isEmpty ? "Please tell us which roles you'd like, like \"Sorting\" or \"Delivery\"" : nil
    }
    private var availabilityError: String? {
        availability.isEmpty ? "Please tell us when you're available, like \"Weekday mornings\"" : nil
    }
    private var emergencyNameError: String? {
        emergency_name.isEmpty ? "Please enter your emergency contact's name" : nil
    }
    private var emergencyNumberError: String? {
        emergency_number.isEmpty ? "Please enter your emergency contact's phone number" : nil
    }

    private var isFormValid: Bool {
        [usernameError, firstNameError, lastNameError, dobError,
         emailError, phoneError, zipcodeError,
         rolesError, availabilityError,
         emergencyNameError, emergencyNumberError].allSatisfy { $0 == nil }
    }

    var body: some View {
        ScrollView {
            if show_success {
                successContent
            } else {
                formContent
            }
        }
        .background(PL.background.ignoresSafeArea())
        .navigationTitle("Volunteer Sign Up")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Something Went Wrong", isPresented: $show_alert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alert_message)
        }
        .alert("You're Already Signed Up", isPresented: $show_already_registered_alert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Good news - you already have a volunteer account. Visit the volunteer schedule page to see available shifts.")
        }
        .animation(reduceMotion ? nil : .default, value: show_success)
        .onChange(of: show_alert) { isShowing in
            if isShowing { isSubmitting = false }
        }
        .onChange(of: show_success) { succeeded in
            if succeeded { isSubmitting = false }
        }
        .onAppear {
            autofillFromAccount()
        }
    }

    // MARK: - Success screen

    private var successContent: some View {
        VStack(spacing: PL.spacingL) {
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(PL.good)
                .accessibilityHidden(true)

            Text("Thank You, \(first_name)!")
                .font(.title.bold())
                .multilineTextAlignment(.center)

            Text("Your volunteer application was submitted and you're now in our system. We'll be in touch soon. Next, you can visit the volunteer schedule to pick a shift.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            PLPrimaryButton(title: "Done", systemImage: "checkmark") {
                if path.count > 0 {
                    path.removeLast()
                }
            }
        }
        .padding(PL.spacingL)
        .padding(.top, PL.spacingXL)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isStaticText)
    }

    // MARK: - Form

    private var formContent: some View {
        VStack(alignment: .leading, spacing: PL.spacingL) {
            // Intro
            VStack(spacing: PL.spacingS) {
                Image(systemName: "heart.fill")
                    .font(.largeTitle)
                    .foregroundStyle(PL.accent)
                    .accessibilityHidden(true)

                Text("Become a Volunteer")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text("Food pantries rely on volunteers for sorting, packing, deliveries, and more. Fill out this short form so pantries know who you are and how to reach you. All fields are required.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .accessibilityElement(children: .combine)

            // About you
            VStack(alignment: .leading, spacing: PL.spacingM) {
                PLSectionHeader(
                    title: "About You",
                    subtitle: "So pantries know who's coming to help"
                )

                PLCard {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        if isAutoFilled {
                            Label("Some fields were filled in from your account", systemImage: "lock.fill")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        fieldWithError(error: usernameError) {
                            PLTextField(
                                label: "Username (required)",
                                text: $username,
                                placeholder: "Your PantryLink username",
                                contentType: .username
                            )
                            .disabled(isAutoFilled)
                            .opacity(isAutoFilled ? 0.6 : 1)
                        }

                        fieldWithError(error: firstNameError) {
                            PLTextField(
                                label: "First Name (required)",
                                text: $first_name,
                                placeholder: "For example: Mary",
                                contentType: .givenName,
                                autocapitalization: .words
                            )
                            .disabled(isAutoFilled)
                            .opacity(isAutoFilled ? 0.6 : 1)
                        }

                        fieldWithError(error: lastNameError) {
                            PLTextField(
                                label: "Last Name (required)",
                                text: $last_name,
                                placeholder: "For example: Johnson",
                                contentType: .familyName,
                                autocapitalization: .words
                            )
                            .disabled(isAutoFilled)
                            .opacity(isAutoFilled ? 0.6 : 1)
                        }

                        fieldWithError(error: dobError) {
                            VStack(alignment: .leading, spacing: PL.spacingXS) {
                                Text("Date of Birth (required)")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(.secondary)
                                DatePicker(
                                    "Date of Birth",
                                    selection: $dobDate,
                                    in: ...Date(),
                                    displayedComponents: .date
                                )
                                .labelsHidden()
                                .datePickerStyle(.compact)
                                .frame(minHeight: PL.tapTarget, alignment: .leading)
                                .onChange(of: dobDate) { newDate in
                                    hasChosenDOB = true
                                    date_of_birth = dobFormatter.string(from: newDate)
                                }
                                Text("Pantries need this to follow their volunteer age rules.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }

            // Contact
            VStack(alignment: .leading, spacing: PL.spacingM) {
                PLSectionHeader(
                    title: "How to Reach You",
                    subtitle: "Pantries use this to confirm your shifts"
                )

                PLCard {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        fieldWithError(error: emailError) {
                            PLTextField(
                                label: "Email (required)",
                                text: $email,
                                placeholder: "name@example.com",
                                keyboard: .emailAddress,
                                contentType: .emailAddress
                            )
                            .disabled(isAutoFilled)
                            .opacity(isAutoFilled ? 0.6 : 1)
                        }

                        fieldWithError(error: phoneError) {
                            PLTextField(
                                label: "Phone Number (required)",
                                text: $phone_number,
                                placeholder: "(555) 123-4567",
                                keyboard: .phonePad,
                                contentType: .telephoneNumber
                            )
                            .disabled(isAutoFilled)
                            .opacity(isAutoFilled ? 0.6 : 1)
                        }

                        fieldWithError(error: zipcodeError) {
                            PLTextField(
                                label: "ZIP Code (required)",
                                text: $zipcode,
                                placeholder: "12345",
                                keyboard: .numberPad,
                                contentType: .postalCode
                            )
                        }
                    }
                }
            }

            // Availability
            VStack(alignment: .leading, spacing: PL.spacingM) {
                PLSectionHeader(
                    title: "How You'd Like to Help",
                    subtitle: "This helps match you with the right pantry tasks"
                )

                PLCard {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        Text("Common roles: Food Distribution, Sorting and Packing, Delivery, Admin Support, Fundraising, Cleaning - or anything else you enjoy.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        fieldWithError(error: rolesError) {
                            PLTextField(
                                label: "Preferred Roles (required)",
                                text: $roles,
                                placeholder: "For example: Delivery, Sorting",
                                autocapitalization: .sentences
                            )
                        }

                        fieldWithError(error: availabilityError) {
                            PLTextField(
                                label: "Availability (required)",
                                text: $availability,
                                placeholder: "For example: Weekdays 9 AM to 5 PM",
                                autocapitalization: .sentences
                            )
                        }
                    }
                }
            }

            // Emergency contact
            VStack(alignment: .leading, spacing: PL.spacingM) {
                PLSectionHeader(
                    title: "Emergency Contact",
                    subtitle: "Someone we can call if anything happens while you volunteer"
                )

                PLCard {
                    VStack(alignment: .leading, spacing: PL.spacingM) {
                        fieldWithError(error: emergencyNameError) {
                            PLTextField(
                                label: "Contact Name (required)",
                                text: $emergency_name,
                                placeholder: "Full name",
                                contentType: .name,
                                autocapitalization: .words
                            )
                        }

                        fieldWithError(error: emergencyNumberError) {
                            PLTextField(
                                label: "Contact Phone (required)",
                                text: $emergency_number,
                                placeholder: "(555) 123-4567",
                                keyboard: .phonePad,
                                contentType: .telephoneNumber
                            )
                        }
                    }
                }
            }

            // Submit
            VStack(alignment: .leading, spacing: PL.spacingS) {
                if attemptedSubmit && !isFormValid {
                    Label("Some fields still need attention. Please check the messages above.", systemImage: "exclamationmark.circle.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(PL.critical)
                }

                PLPrimaryButton(
                    title: isSubmitting ? "Sending Your Application..." : "Submit My Application",
                    systemImage: isSubmitting ? nil : "paperplane.fill",
                    isLoading: isSubmitting,
                    action: { submit() }
                )
            }
            .padding(.top, PL.spacingS)
        }
        .padding(PL.spacingM)
        .padding(.bottom, PL.spacingXL)
    }

    // MARK: - Field + inline error helper

    @ViewBuilder
    private func fieldWithError<Field: View>(error: String?, @ViewBuilder field: () -> Field) -> some View {
        VStack(alignment: .leading, spacing: PL.spacingXS) {
            field()
            if attemptedSubmit, let error {
                Label(error, systemImage: "exclamationmark.circle.fill")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(PL.critical)
            }
        }
    }

    // MARK: - Actions

    private func autofillFromAccount() {
        // Autofill form fields from logged-in user data
        if let user = userManager.currentUser {
            if username.isEmpty { username = user.username }
            if first_name.isEmpty { first_name = user.first_name }
            if last_name.isEmpty { last_name = user.last_name }
            if email.isEmpty { email = user.email }
            if phone_number.isEmpty { phone_number = user.phone_number }
            // Mark fields as autofilled and locked
            isAutoFilled = true
        }

        // If a date of birth was already entered, keep it.
        if !date_of_birth.isEmpty, let parsed = dobFormatter.date(from: date_of_birth) {
            dobDate = parsed
            hasChosenDOB = true
        }
    }

    private func submit() {
        attemptedSubmit = true

        guard isFormValid else { return }

        date_of_birth = dobFormatter.string(from: dobDate)
        isSubmitting = true

        Task {
            let exists = await check_volunteer_exists(username: username)

            await MainActor.run {
                if exists {
                    isSubmitting = false
                    show_already_registered_alert = true
                    return
                }

                let new_volunteer = Volunteer(
                    username: username,
                    first_name: first_name,
                    last_name: last_name,
                    date_of_birth: date_of_birth,
                    email: email,
                    phone_number: phone_number,
                    zipcode: zipcode,
                    roles: roles,
                    availability: availability,
                    emergency_name: emergency_name,
                    emergency_number: emergency_number,
                    alert_message: alert_message,
                    show_alert: show_alert
                )

                register_volunteer(volunteer: new_volunteer, show_success: $show_success)
            }
        }
    }
}

#Preview {
    NavigationStack {
        VolunteerView(path: .constant(NavigationPath()))
    }
}
