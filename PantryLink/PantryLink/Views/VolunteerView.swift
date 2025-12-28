//
//  ContentView.swift
//  PantryLink
//
//  Created by Michael Youtz on 5/27/25.
//

import SwiftUI

// VolunteerPageView - Full page version for TabView
struct VolunteerPageView: View {
    @ObservedObject private var userManager = UserManager.shared
    @Binding var path: NavigationPath
    
    //form 1 data fields
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var date_of_birth: String = ""
    @State var email: String = ""
    @State var phone_number: String = ""
    @State var zipcode: String = ""
    
    //form 2 data fields
    @State var roles: String = ""
    @State var availability: String = ""
    @State var emergency_name: String = ""
    @State var emergency_number: String = ""
    
    //pop up variable
    @State var isClicked = false
    
    //alert
    @State var alert_message = ""
    @State var show_alert = false
    
    //unfinished
    @State var empty_field = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VolunteerContentView(
                userManager: userManager,
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
                isClicked: $isClicked,
                alert_message: $alert_message,
                show_alert: $show_alert,
                empty_field: $empty_field,
                path: $path
            )
            .navigationDestination(for: String.self) { value in
                if value == "SignUp" {
                    SignUpView(path: $path)
                }
            }
        }
    }
}

// Legacy VolunteerView for navigation-based access (keeping for compatibility)
struct VolunteerView: View {
    @ObservedObject private var userManager = UserManager.shared
    @Binding var path: NavigationPath
    
    //form 1 data fields
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var date_of_birth: String = ""
    @State var email: String = ""
    @State var phone_number: String = ""
    @State var zipcode: String = ""
    
    //form 2 data fields
    @State var roles: String = ""
    @State var availability: String = ""
    @State var emergency_name: String = ""
    @State var emergency_number: String = ""
    
    //pop up variable
    @State var isClicked = false
    
    //alert
    @State var alert_message = ""
    @State var show_alert = false
    
    //unfinished
    @State var empty_field = false
    
    var body: some View {
        VolunteerContentView(
            userManager: userManager,
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
            isClicked: $isClicked,
            alert_message: $alert_message,
            show_alert: $show_alert,
            empty_field: $empty_field,
            path: $path
        )
    }
}

// Shared content view for volunteer functionality
struct VolunteerContentView: View {
    @ObservedObject var userManager: UserManager
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
    @Binding var isClicked: Bool
    @Binding var alert_message: String
    @Binding var show_alert: Bool
    @Binding var empty_field: Bool
    @Binding var path: NavigationPath
    
    @State private var show_success_alert = false
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Colors.flexibleOrange.opacity(0.1),
                    Colors.flexibleWhite,
                    Colors.flexibleGreen.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Exciting Header Section
                    VStack(spacing: 16) {
                        // Celebration icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Colors.flexibleOrange.opacity(0.3),
                                            Colors.flexibleGreen.opacity(0.3)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "heart.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Colors.flexibleOrange,
                                            Colors.flexibleGreen
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .padding(.top, 10)
                        
                        VStack(spacing: 8) {
                            Text("Volunteer today!")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Colors.flexibleOrange,
                                            Colors.flexibleGreen
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("Join us in making a difference")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Colors.flexibleBlack)
                            
                            Text("Complete the following form to create a PantryLink volunteer profile")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Colors.flexibleDarkGray)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                    
                    // Opportunities Section with Excitement
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(Colors.flexibleOrange)
                                .font(.system(size: 20))
                            Text("Volunteer Opportunities")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Colors.flexibleBlack)
                            Image(systemName: "sparkles")
                                .foregroundColor(Colors.flexibleOrange)
                                .font(.system(size: 20))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 14) {
                            let opportunities = [
                                ("Food Distribution", "tray.fill"),
                                ("Sorting/Packing", "shippingbox.fill"),
                                ("Delivery", "car.fill"),
                                ("Admin Support", "doc.text.fill"),
                                ("Fundraising Support", "dollarsign.circle.fill"),
                                ("Cleaning/Sanitation", "sparkles.rectangle.stack.fill")
                            ]
                            
                            ForEach(Array(opportunities.enumerated()), id: \.element.0) { index, opportunity in
                                OpportunityCard(title: opportunity.0, icon: opportunity.1, index: index)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
            
                    // Registration Form Section with Excitement
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(spacing: 8) {
                            if !isClicked {
                                HStack(spacing: 8) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Colors.flexibleOrange)
                                    Text("Let's Get Started!")
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundColor(Colors.flexibleBlack)
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Colors.flexibleOrange)
                                }
                                
                                Text("Fill out the form below to begin your volunteer journey")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Colors.flexibleDarkGray)
                                    .multilineTextAlignment(.center)
                            } else {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Colors.flexibleGreen)
                                    Text("Almost There! ✨")
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundColor(Colors.flexibleBlack)
                                }
                                
                                Text("Just a few more details to complete your application")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Colors.flexibleDarkGray)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        
                        if !isClicked {
                            // First Form - Basic Information
                            VStack(spacing: 20) {
                                // Add some visual flair
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Colors.flexibleLightGray.opacity(0.5))
                                    .frame(height: 1)
                                    .padding(.horizontal, 20)
                                
                            VStack(spacing: 16) {
                                FormTextField(
                                    label: "First Name",
                                    text: $first_name,
                                    placeholder: "Enter your first name",
                                    isEmpty: empty_field && first_name.isEmpty
                                )
                                
                                FormTextField(
                                    label: "Last Name",
                                    text: $last_name,
                                    placeholder: "Enter your last name",
                                    isEmpty: empty_field && last_name.isEmpty
                                )
                                
                                FormTextField(
                                    label: "Date of Birth",
                                    text: $date_of_birth,
                                    placeholder: "MM/DD/YYYY",
                                    isEmpty: empty_field && date_of_birth.isEmpty
                                )
                                
                                FormTextField(
                                    label: "Email",
                                    text: $email,
                                    placeholder: "your.email@example.com",
                                    isEmpty: empty_field && email.isEmpty,
                                    keyboardType: .emailAddress
                                )
                                
                                FormTextField(
                                    label: "Phone Number",
                                    text: $phone_number,
                                    placeholder: "(555) 123-4567",
                                    isEmpty: empty_field && phone_number.isEmpty
                                )
                                
                                FormTextField(
                                    label: "Zipcode",
                                    text: $zipcode,
                                    placeholder: "12345",
                                    isEmpty: empty_field && zipcode.isEmpty
                                )
                                
                                Button(action: {
                                    guard !first_name.isEmpty, !last_name.isEmpty, !date_of_birth.isEmpty, !email.isEmpty, !phone_number.isEmpty, !zipcode.isEmpty else {
                                        empty_field = true
                                        return
                                    }
                                    empty_field = false
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        isClicked = true
                                    }
                                }) {
                                    HStack(spacing: 10) {
                                        Text("Continue")
                                            .font(.system(size: 18, weight: .bold))
                                        Image(systemName: "arrow.right.circle.fill")
                                            .font(.system(size: 20))
                                    }
                                    .foregroundColor(Colors.flexibleWhite)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Colors.flexibleOrange,
                                                Colors.flexibleGreen
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(16)
                                    .shadow(color: Colors.flexibleGreen.opacity(0.4), radius: 8, y: 4)
                                }
                                .padding(.top, 12)
                            }
                            .padding(.horizontal, 20)
                            }
                            
                        } else {
                            // Second Form - Additional Information
                            VStack(spacing: 20) {
                                // Add some visual flair
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Colors.flexibleLightGray.opacity(0.5))
                                    .frame(height: 1)
                                    .padding(.horizontal, 20)
                            
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "heart.circle.fill")
                                            .foregroundColor(Colors.flexibleOrange)
                                        Text("We're thrilled you're joining us!")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(Colors.flexibleBlack)
                                    }
                                    
                                    Text("Just a few more details to help us match you with the perfect opportunity!")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(Colors.flexibleDarkGray)
                                }
                                .padding(.bottom, 8)
                                
                                FormTextField(
                                    label: "Preferred Roles",
                                    text: $roles,
                                    placeholder: "e.g., Delivery, Admin Support",
                                    isEmpty: empty_field && roles.isEmpty
                                )
                                
                                FormTextField(
                                    label: "Availability",
                                    text: $availability,
                                    placeholder: "e.g., M-F 9AM to 5PM",
                                    isEmpty: empty_field && availability.isEmpty
                                )
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Emergency Contact")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Colors.flexibleBlack)
                                    
                                    FormTextField(
                                        label: "Contact Name",
                                        text: $emergency_name,
                                        placeholder: "Full Name",
                                        isEmpty: empty_field && emergency_name.isEmpty,
                                        showLabel: false
                                    )
                                    
                                    FormTextField(
                                        label: "Contact Phone",
                                        text: $emergency_number,
                                        placeholder: "(555) 123-4567",
                                        isEmpty: empty_field && emergency_number.isEmpty,
                                        showLabel: false
                                    )
                                }
                                
                                Button(action: {
                                    guard !availability.isEmpty, !roles.isEmpty, !emergency_name.isEmpty, !emergency_number.isEmpty else {
                                        empty_field = true
                                        return
                                    }
                                    
                                    let new_volunteer = Volunteer(
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
                                    
                                    register_volunteer(volunteer: new_volunteer, show_success: $show_success_alert)
                                }) {
                                    HStack(spacing: 10) {
                                        Text("Submit Application")
                                            .font(.system(size: 18, weight: .bold))
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 20))
                                    }
                                    .foregroundColor(Colors.flexibleWhite)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Colors.flexibleGreen,
                                                Colors.flexibleOrange
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(16)
                                    .shadow(color: Colors.flexibleGreen.opacity(0.4), radius: 8, y: 4)
                                }
                                .padding(.top, 12)
                            }
                            .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
                .padding(.vertical, 20)
            }
        }
        .alert("Error", isPresented: $show_alert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alert_message)
        }
        .alert("Application Submitted!", isPresented: $show_success_alert) {
            Button("OK") {
                // Navigate back after user dismisses the success alert
                if path.count > 0 {
                    path.removeLast()
                }
            }
        } message: {
            Text("Thank you for your interest! Your volunteer application has been successfully submitted and you are now in our system. We'll be in touch soon!")
        }
        .onAppear {
            // Autofill form fields from logged-in user data
            if let user = userManager.currentUser {
                if first_name.isEmpty {
                    first_name = user.first_name
                }
                if last_name.isEmpty {
                    last_name = user.last_name
                }
                if email.isEmpty {
                    email = user.email
                }
                if phone_number.isEmpty {
                    phone_number = user.phone_number
                }
            }
        }
    }
}

// Helper view for opportunity cards - Enhanced with excitement!
struct OpportunityCard: View {
    let title: String
    let icon: String
    let index: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with gradient background
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Colors.flexibleOrange.opacity(0.2),
                                Colors.flexibleGreen.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Colors.flexibleOrange,
                                Colors.flexibleGreen
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Colors.flexibleBlack)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Colors.flexibleDarkGray)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Colors.flexibleWhite)
                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Colors.flexibleOrange.opacity(0.3),
                            Colors.flexibleGreen.opacity(0.3)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

// Helper view for form text fields
struct FormTextField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    var isEmpty: Bool = false
    var keyboardType: UIKeyboardType = .default
    var showLabel: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showLabel {
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isEmpty ? Colors.flexibleRed : Colors.flexibleBlack)
            }
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Colors.flexibleBlack)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Colors.flexibleWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isEmpty ? Colors.flexibleRed : Colors.flexibleLightGray, lineWidth: isEmpty ? 2 : 1)
                        )
                )
                .keyboardType(keyboardType)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
    }
}

/* #Preview {
    VolunteerView(path: path)
    
}
*/
