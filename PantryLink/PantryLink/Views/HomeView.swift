
//  HomeView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//
import SwiftUI

// HomePageView - Full page version for TabView
struct HomePageView: View {
    @State private var searchText = ""
    @Binding var path: NavigationPath
    @StateObject var delegate = AppDelegate()
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        NavigationStack(path: $path) {
           
            ZStack{
                Rectangle()
                    .fill(Colors.flexibleWhite)
                    .ignoresSafeArea()
                ScrollView{
                    VStack{
                        HStack{
                            Spacer()
                            Spacer()
                            Text("PantryLink")
                                .font(.title)
                                .bold()
                            Spacer()
                            NavigationLink{AccountView(path: $path)} label:{Image(systemName: "person.crop.circle")}
                                .padding()
                                .scaleEffect(2)
                                .foregroundStyle(.black)
                    }
                        
                        LocalPantryView()
                            .padding()
                        StreamView()
                            .padding()
                        //for notification testing
//                        Button(action: {
//                            // Request permission and schedule the notification
//                            delegate.testNotification()
//                            print("test")
//                        }) {
//                            Text("Send Test Notification")
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
                    }
                    .frame(maxWidth: isIPad ? 800 : .infinity)
                    .padding(.bottom, 20) // Add bottom padding for tab bar
                }
                .padding(1.0)
            }
            .navigationDestination(for: String.self) { value in
                if value == "SignUp" {
                    SignUpView(path: $path)
                }
            }
            .toolbar(.hidden)
        }
    }
}

// Legacy HomeView for navigation-based access (keeping for compatibility)
struct HomeView: View {
    @State private var searchText = ""
    @Binding var path: NavigationPath
    @StateObject var delegate = AppDelegate()
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Colors.flexibleWhite)
                .ignoresSafeArea()
            ScrollView{
                VStack{
                   // NavView(path: $path)
                    LocalPantryView()
                        .padding()
                    StreamView()
                        .padding()
                    //for notification testing
                    Button(action: {
                        // Request permission and schedule the notification
                        delegate.testNotification()
                        print("test")
                    }) {
                        Text("Send Test Notification")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(1.0)
            
        }.toolbar(.hidden)
    }
}

#Preview {
    HomeView(path: .constant(NavigationPath()))
}

