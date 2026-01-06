//
//  Stream.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/28/25.
//

import SwiftUI

// Helper struct to hold alert with pantry name for sorting
struct StreamAlertWithPantry: Identifiable {
    let id: String
    let pantryName: String
    let alert: StreamAlert
    let sortDate: Date
    
    init(pantryName: String, alert: StreamAlert) {
        self.pantryName = pantryName
        self.alert = alert
        // Create unique ID from pantry name + message + date
        self.id = "\(pantryName)-\(alert.message)-\(alert.date)"
        
        // Parse date for sorting - try multiple formats
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Try different date formats
        let dateFormats = [
            "MM/dd/yyyy hh:mm a",  // e.g., "10/25/2023 10:30 AM"
            "MM/dd/yyyy",           // e.g., "10/25/2023"
            "MM/dd/yy",             // e.g., "10/25/23"
            "dd MMMM",              // e.g., "23 March"
            "MMMM dd, yyyy"         // e.g., "March 23, 2023"
        ]
        
        var parsedDate: Date?
        for format in dateFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: alert.date) {
                parsedDate = date
                break
            }
        }
        
        // Fallback to current date if parsing fails
        self.sortDate = parsedDate ?? Date.distantPast
    }
}

struct StreamView: View {
//    private let pantries : [Pantry] = [
//        Pantry(_id:"68ed1581783104e82a2790e9",name: "Princeton Mobile", stock: [], address:"1234 main street", stream:[StreamAlert(date:"23 March", message:"New Food available!"), StreamAlert(date:"23 March", message:"New Food available!")]),
//        Pantry(_id:"68ed1581783104e82a2790e9",name: "Princeton Mobile", stock: [], address:"1234 main street", stream:[]),
//    ]
    
    @StateObject var streamViewViewModel = StreamViewViewModel()
    @State var pantries: [Pantry]?
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    // Computed property to get sorted alerts from all pantries
    var sortedAlerts: [StreamAlertWithPantry] {
        guard let pantries = pantries else { return [] }
        
        // Collect all alerts from all pantries
        var allAlerts: [StreamAlertWithPantry] = []
        for pantry in pantries {
            if let stream = pantry.stream {
                for alert in stream {
                    allAlerts.append(StreamAlertWithPantry(pantryName: pantry.name, alert: alert))
                }
            }
        }
        
        // Sort in reverse chronological order (newest first)
        return allAlerts.sorted { $0.sortDate > $1.sortDate }
    }
    
    var body: some View {
        ZStack {
            //new colors I created for stock are in dark mode branch, so make sure I (or you) add them
            RoundedRectangle(cornerRadius: 25)
                .fill(.stockDarkTan)
                .frame(width: isIPad ? 600 : 350, height: isIPad ? 800 : 700)
                .shadow(radius: 10)
            ScrollView{
                VStack(spacing: 10){
                    Text("Stream")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title)
                    
                    if pantries != nil {
                        if sortedAlerts.isEmpty {
                            Text("No alerts at the moment. Please come back at a later time!")
                                .foregroundColor(.white)
                        } else {
                            ForEach(sortedAlerts) { alertWithPantry in
                                PantryAlertView(
                                    pantryName: alertWithPantry.pantryName,
                                    message: alertWithPantry.alert.message,
                                    date: alertWithPantry.alert.date
                                )
                            }
                        }
                    } else {
                        Text("No alerts at the moment. Please come back at a later time!")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(width: isIPad ? 575 : 325)
            }
            .frame(width: isIPad ? 575 : 325, height: isIPad ? 775 : 675)
        }.task{
            // If request succeeds we get pantries otherwise we get nil and error is ignored
            pantries = try? await streamViewViewModel.getStreams().pantries
        }
    }
    
}

#Preview {
    StreamView(streamViewViewModel: StreamViewViewModel(), pantries: [
        Pantry(_id:"68ed1581783104e82a2790e9",name: "Princeton Mobile", stock: [], address:"1234 main street", stream:[
            StreamAlert(date: "10/25/2023", message: "Hi world")
        ]), Pantry(_id: "id", name: "Hillsborough CAN", stock: [], address: "273 Kelvin street", stream:[StreamAlert(date: "10/24/23", message: "food information")])
    ])
}

