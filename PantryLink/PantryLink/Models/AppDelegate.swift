//
//  AppDelegate.swift
//  PantryLink
//
//  Created by Michael Youtz on 9/30/25.
//

import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    //lets us access contentview methods here
    var app: ContentView?
    
    // Store the device token for later use (e.g., associating with user after login)
    @Published var deviceToken: String?
    
    // Base URL for the API
    private let baseURL = API.baseURL
    
    //testing only, no back end connection
    func testNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Flemington Area Food Pantry Alert"
        content.body = "Items have been restocked"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // register device to receive push notifications
        application.registerForRemoteNotifications()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){permission, error in
            if permission {
                print("Notification permission granted.")
            } else {}
        }
        // setting the notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Clear badge on launch
        application.applicationIconBadgeNumber = 0
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Clear the badge when user opens the app
        application.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication,
                       didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert device token to string
        let stringifiedToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device token:", stringifiedToken)
        
        // Store token for later use
        DispatchQueue.main.async {
            self.deviceToken = stringifiedToken
        }
        
        // Register the device token with our server
        registerDeviceTokenWithServer(token: stringifiedToken)
    }
    
    func application(_ application: UIApplication,
                       didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // MARK: - Server Communication
    
    /// Register the device token with the server for push notifications
    private func registerDeviceTokenWithServer(token: String) {
        guard let url = URL(string: "\(baseURL)/device/register") else {
            print("Invalid URL for device registration")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Include username if user is logged in
        var body: [String: Any] = ["device_token": token]
        if let currentUser = UserManager.shared.currentUser {
            body["username"] = currentUser.username
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error encoding device token request: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error registering device token: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                    print("Device token registered successfully with server")
                } else {
                    print("Failed to register device token. Status: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    /// Update the device token association with a user (call after login)
    func associateDeviceWithUser(username: String) {
        guard let token = deviceToken else {
            print("No device token available to associate with user")
            return
        }
        
        guard let url = URL(string: "\(baseURL)/device/update-user") else {
            print("Invalid URL for device user update")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "device_token": token,
            "username": username
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error encoding device user update request: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating device user: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    print("Device associated with user \(username) successfully")
                } else {
                    print("Failed to associate device with user. Status: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    /// Unregister the device from push notifications (call on logout if desired)
    func unregisterDevice() {
        guard let token = deviceToken else {
            print("No device token to unregister")
            return
        }
        
        guard let url = URL(string: "\(baseURL)/device/unregister") else {
            print("Invalid URL for device unregistration")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["device_token": token]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error encoding device unregister request: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error unregistering device: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Device unregistered successfully")
                } else {
                    print("Failed to unregister device. Status: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // lets app do something when a notification is clicked
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
            print("Got notification title: ", response.notification.request.content.title)
    }
    
    //allow us to see notifications when app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // options that will be used when displaying a notification with the app in the foreground
        return [.badge, .banner, .list, .sound]
    }
}
