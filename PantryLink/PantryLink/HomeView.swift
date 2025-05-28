//
//  HomeView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//
import SwiftUI


struct HomeView: View {
    @State private var searchText = ""
    var body: some View {
        let items = ["Trenton Area Soup Kitchen",     "Montgomery Township Food Pantry",
                     "Feeding Hands Food Pantry",
                     "Franklin Food Bank",
                     "Hillsborough C.A.N. (Community Assistance Network)",
                     "Raritan Food Pantry",
                     "Arm In Arm – Princeton",
                     "Princeton Mobile Food Bank"]
        
        var filteredItems: [String] {
            if searchText.isEmpty {
                return items
            } else {
                return items.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
            NavigationView {
                VStack {
                    // Search Bar
                    TextField("Search...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    // Filtered List
                    List(filteredItems, id: \.self) { item in
                        Text(item)
                    }
                }
                .navigationTitle("Food Banks")
            }
        }
    }

    
