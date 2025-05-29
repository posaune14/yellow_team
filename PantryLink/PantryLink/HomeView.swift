
//  HomeView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//
import SwiftUI
import UIKit

struct HomeView: View {
    @State private var searchText = ""
    var body: some View {
        ScrollView{
            NavView()
            StreamView()
            
        }
    }
}
