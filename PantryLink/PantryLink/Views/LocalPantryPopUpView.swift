//
//  LocalPantryPopUpView.swift
//  PantryLink
//
//  Created by Michael Youtz on 10/21/25.
//
import SwiftUI
import MapKit

struct LocalPantryPopUpView: View {
    var pantryAddress: String = "None"
    var pantryNumber: String = "none"
    var pantryURL: URL?
    
    var body: some View {
        VStack(spacing: 8) {
            
            Text(pantryAddress)
                .foregroundColor(.blue)
                .underline()
                .onTapGesture {
                    openInMaps(address: pantryAddress)
                }
            

            Text(pantryNumber)
            
       
            if let pantryURL {
                Link("Website Link", destination: pantryURL)
            } else {
                Text("No link available")
            }
        }
        .padding()
    }
    
    func openInMaps(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let location = placemarks?.first?.location else { return }
            
            let regionDistance: CLLocationDistance = 500
            let coordinates = location.coordinate
            
            let regionSpan = MKCoordinateRegion(center: coordinates,
                                                latitudinalMeters: regionDistance,
                                                longitudinalMeters: regionDistance)
            
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
            mapItem.name = address
            
            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ])
        }
    }
}
