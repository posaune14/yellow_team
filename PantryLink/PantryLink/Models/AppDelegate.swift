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
    
    //testing only, no back end connection
    func testNotification() {
        let content = UNMutableNotificationContent()
        content.title = "New Alert from Flemington Area Food Pantry"
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
        
        return true
    }
    
    func application(_ application: UIApplication,
                       didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Once the device is registered for push notifications Apple will send the token to our app and it will be available here.
        // This is also where we will forward the token to our push server
        // If you want to see a string version of your token, you can use the following code to print it out
        let stringifiedToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("stringifiedToken:", stringifiedToken)
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
