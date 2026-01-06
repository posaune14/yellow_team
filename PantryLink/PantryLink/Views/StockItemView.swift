//
//  StockItemView.swift
//  PantryLink
//
//  Created by Jared Sinai Hernandez Adame on 10/14/25.
//
import SwiftUI
import MapKit

struct StockItemView: View {
    let pantryName: String
    let topItems: [PantryItem]
    let pantryAddress: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Colors.flexibleWhite)
                .shadow(radius: 10)
            
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Text(pantryName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Colors.flexibleBlack)
                    
                    Spacer()
                    
                    Button(action: {
                        if let address = pantryAddress {
                            openInMaps(address: address)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text("Directions")
                                .font(.caption)
                            Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                .font(.caption)
                        }
                        .padding(6)
                        .background(Colors.flexibleDarkGray.opacity(0.15))
                        .cornerRadius(6)
                        .foregroundColor(Colors.flexibleBlack)
                    }
                }
                
                Text("Top Items:")
                    .font(.subheadline)
                    .foregroundColor(Colors.flexibleBlack)
                    .padding(.top, 4)
                
                HStack(spacing: 8) {
                    ForEach(topItems) { item in
                        makeItemCard(item: item)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity) // stretch to screen width
        .padding(.horizontal)       // keep nice side spacing
        .padding(.vertical, 6)
    }
    
    // Create a rounded rectangle card for each top item
    func makeItemCard(item: PantryItem) -> some View {
        VStack(spacing: 4) {
            Text(item.name)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(Colors.flexibleBlack)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            Text("\(item.current)/\(item.full)")
                .font(.caption2)
                .foregroundColor(item.ratio < 0.5 ? Colors.flexibleRed : Colors.flexibleGreen)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Colors.flexibleDarkGray.opacity(1))
        )
    }
    
    // Open Apple Maps with the pantry address
    func openInMaps(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let location = placemarks?.first?.location else {
                print("Failed to geocode address: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let regionDistance: CLLocationDistance = 500
            let coordinates = location.coordinate
            
            let regionSpan = MKCoordinateRegion(center: coordinates,
                                                latitudinalMeters: regionDistance,
                                                longitudinalMeters: regionDistance)
            
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
            mapItem.name = pantryName
            
            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ])
        }
    }
}

#Preview {
    StockItemView(
        pantryName: "Flemmington Pantry",
        topItems: [
            PantryItem(name: "Canned Beans", current: 3, full: 10, type: "Cans", ratio: 0.3),
            PantryItem(name: "Tomato Soup", current: 5, full: 10, type: "Cans", ratio: 0.5),
            PantryItem(name: "Pasta", current: 8, full: 10, type: "Dry Goods", ratio: 0.8)
        ],
        pantryAddress: "373 Burnt Hill Road, Skillman, NJ 08558"
    )
}
//VStack{
//    RoundedRectangle(cornerRadius: 15)
//        .fill(Color.white)
//        .frame(width:325, height:110)
//        .overlay(
//            VStack{
//                Text(pantry.name)
//                    .bold()
//                    .font(.title2)
//                Text("\(pantry.stock)% Capacity")
//                  /*  if pantry.stock < 50 {
//                        .foregroundColor(.red)
//                } else {
//                    .foregroundColor(.green)
//                    }*/
//                    .foregroundColor(pantry.stock < 50 ? .red : .green) //shorthand if kinda like js
//                    .font(.caption)
//                
//                HStack{
//                    ForEach(pantry.items, id: \.self){ item in
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(red: 214/255, green: 214/255, blue: 214/255))
//                            .frame(width: 75, height: 30)
//                            .overlay(
//                                Text(item)
//                                        .scaledToFit()
//                                
//                            )
//                    }
//                }
//            }
//        )
//}
