//
//  AccountView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 1/2/26.
//

import SwiftUI

struct AccountView: View {
    @Binding var path: NavigationPath
    @State private var showAlert = false
    @State private var showAlert1 = false
    @State private var showLoader = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("isGuest") private var isGuest = false
    @ObservedObject private var userManager = UserManager.shared
    var body: some View {
        NavigationStack(path: $path){
            ScrollView(){
                
                if isGuest == true{
                    VStack(){
                        Text("You are logged in as a guest.")
                            .font(.title2)
                        Button{
                            print("Log Out")
                            isLoggedIn = false
                            isGuest = false
                        }label:{
                            RoundedRectangle(cornerRadius: 20)
                                .fill()
                                .stroke(Color.flexibleDarkGray, lineWidth: 5)
                                .frame(width: 300, height: 50)
                                .foregroundStyle(Color.flexibleLightGray)
                                .padding(.top, 50)
                                .overlay(Text("Sign In")
                                    .padding(.top, 50)
                                    .font(.title3)
                                    .bold(true)
                                    .foregroundColor(.black)
                                )
                        }
                    }
                }else{
                    VStack(){
                        Text("Account Information")
                            .font(.title)
                            .padding(.bottom, 20)
                        Text("Username")
                        RoundedRectangle(cornerRadius: 20)
                            .fill()
                            .stroke(Color.flexibleDarkGray, lineWidth: 5)
                            .frame(width: 300, height: 50)
                            .foregroundStyle(.flexibleLightGray)
                            .overlay(
                                Text(userManager.currentUser?.username ?? "N/A")
                            )
                        
                        Text("First Name")
                        RoundedRectangle(cornerRadius: 20)
                            .fill()
                            .stroke(Color.flexibleDarkGray, lineWidth: 5)
                            .frame(width: 300, height: 50)
                            .foregroundStyle(.flexibleLightGray)
                            .overlay(
                                Text(userManager.currentUser?.first_name ?? "N/A")
                            )
                        Text("Last Name")
                        RoundedRectangle(cornerRadius: 20)
                            .fill()
                            .stroke(Color.flexibleDarkGray, lineWidth: 5)
                            .frame(width: 300, height: 50)
                            .foregroundStyle(.flexibleLightGray)
                            .overlay(
                                Text(userManager.currentUser?.last_name ?? "N/A")
                            )
                        
                        Text("Email")
                        RoundedRectangle(cornerRadius: 20)
                            .fill()
                            .stroke(Color.flexibleDarkGray, lineWidth: 5)
                            .frame(width: 300, height: 50)
                            .foregroundStyle(.flexibleLightGray)
                            .overlay(
                                Text(userManager.currentUser?.email ?? "N/A")
                            )
                        
                        Text("Phone Number")
                        RoundedRectangle(cornerRadius: 20)
                            .fill()
                            .stroke(Color.flexibleDarkGray, lineWidth: 5)
                            .frame(width: 300, height: 50)
                            .foregroundStyle(.flexibleLightGray)
                            .overlay(
                                Text(userManager.currentUser?.phone_number ?? "N/A")
                            )
                        
                        
                        Button{
                            print("Log Out")
                            isLoggedIn = false
                        }label:{
                            RoundedRectangle(cornerRadius: 20)
                                .fill()
                                .stroke(Color.flexibleDarkGray, lineWidth: 5)
                                .frame(width: 300, height: 50)
                                .foregroundStyle(Color.flexibleLightGray)
                                .padding(.top, 50)
                                .overlay(Text("Log Out")
                                    .padding(.top, 50)
                                    .font(.title3)
                                    .bold(true)
                                    .foregroundColor(.black)
                                )
                        }
                        Button{
                            showAlert = true
                        }
                        label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill()
                                .stroke(Color(red: 216/255, green: 82/255, blue: 82/255), lineWidth: 5)
                                .frame(width: 300, height: 50)
                                .foregroundStyle(Color(red: 255/255, green: 103/255, blue: 103/255))
                                .padding(.top, 10)
                                .overlay(Text("Delete Account")
                                    .padding(.top, 10)
                                    .font(.title3)
                                    .bold(true)
                                    .foregroundColor(.black)
                                )
                        }
                        .alert("Delete Account", isPresented: $showAlert) {
                            Button("Delete", role: .destructive){
                                Task {
                                    showLoader = true
                                    await deleteAccount()
                                    isLoggedIn = false
                                    showLoader = false
                                    showAlert1 = true
                                }
                                
                            }
                            Button("Cancel", role: .cancel){}
                        } message: {
                            Text("Are you sure you want to delete your account? This action is permanent.")
                        }
                        .alert("Account Deleted", isPresented: $showAlert1) {
                            Button("Dismiss", role: .cancel){}
                        }
                        
                        
                        if showLoader {
                            ZStack {
                                Color.black.opacity(0.4)
                                    .ignoresSafeArea()
                                
                                VStack(spacing: 20) {
                                    ProgressView()
                                        .scaleEffect(1.5)
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    
                                    Text("Deleting...")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                }
                                .padding(30)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.black.opacity(0.8))
                                )
                            }
                        }
                        
                        
                        
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

extension AccountView {
    func deleteAccount() async {
        guard let username = userManager.currentUser?.username else {
            print("Error: No username found")
            return
        }
        
        print("Attempting to delete account with username: '\(username)'")
        
        guard let url = URL(string: "https://yellow-team.onrender.com/user/delete") else {
            print("Error: Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(["username": username])
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    await MainActor.run {
                        userManager.clearUser()
                        isLoggedIn = false
                    }
                } else {
                    // Log error response
                    if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("Delete account error response: \(errorData)")
                    } else if let errorString = String(data: data, encoding: .utf8) {
                        print("Delete account error response (string): \(errorString)")
                    }
                    print("Delete account failed with status code: \(httpResponse.statusCode)")
                    print("Username sent: '\(username)'")
                }
            }
        } catch {
            print("Error deleting account: \(error)")
        }
    }
}

#Preview {
    AccountView(path: .constant(NavigationPath()))
}
