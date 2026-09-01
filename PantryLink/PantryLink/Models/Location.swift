//
//  Location.swift
//  PantryLink
//
//  Created by Michael Youtz on 10/1/25.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI
import Contacts

/// Identifiable wrapper so MKMapItem can drive .sheet(item:) presentations
/// (presenting from optional state with .sheet(isPresented:) shows an empty
/// sheet the first time because the content closure captures stale state).
struct IdentifiableMapItem: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    // Singleton instance
    static let shared = LocationManager()
    
    //controls user location
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var locationReady: Bool = false
    
    //controls authentication
    var manager = CLLocationManager()
    
    @Published var allPantries: [MKMapItem] = [] // Combined list including all known pantries
    @Published var isLoadingPantries: Bool = false
    @Published var pantries: [MKMapItem] = []
    @Published var knownNJPantries: [MKMapItem] = [] // Will be loaded from Google Sheets
    
    // Google Sheets CSV URL
    private let googleSheetsCSVURL = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRG9rKjJzcA5N97PkiFC0klgovVbvurx1zZLKqOY3LIP37hc-Pd0_2KOS3RUjmL6hJk0AFueQNKpc81/pub?output=csv"
    
    private func createPantry(name: String, address: String, city: String, state: String, zip: String, phone: String?, website: String?, lat: Double, lon: Double) -> MKMapItem {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        // Create a proper placemark with address info
        var addressDict: [String: Any] = [:]
        addressDict[CNPostalAddressStreetKey] = address
        addressDict[CNPostalAddressCityKey] = city
        addressDict[CNPostalAddressStateKey] = state
        addressDict[CNPostalAddressPostalCodeKey] = zip
        
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.phoneNumber = phone
        if let website = website {
            mapItem.url = URL(string: website)
        }
        
        // Debug: Verify placemark has location
        if mapItem.placemark.location == nil {
            print("⚠️ WARNING: Placemark for \(name) has no location!")
        }
        
        return mapItem
    }
    
    // Load pantries from Google Sheets
    func loadPantriesFromGoogleSheets() {
        print("🔄 Loading pantries from Google Sheets...")
        
        guard let url = URL(string: googleSheetsCSVURL) else {
            print("⚠️ Invalid Google Sheets URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Error loading Google Sheets: \(error.localizedDescription)")
                return
            }
            
            guard let data = data,
                  let csvString = String(data: data, encoding: .utf8) else {
                print("❌ Failed to convert data to string")
                return
            }
            
            let pantries = self.parseCSV(csvString)
            
            DispatchQueue.main.async {
                self.knownNJPantries = pantries
                print("✅ Loaded \(pantries.count) pantries from Google Sheets")
            }
        }.resume()
    }
    
    // Parse CSV data into MKMapItem array
    private func parseCSV(_ csvString: String) -> [MKMapItem] {
        var pantries: [MKMapItem] = []
        let rows = csvString.components(separatedBy: .newlines)
        
        // Skip header row and empty rows
        for (index, row) in rows.enumerated() {
            if index == 0 || row.trimmingCharacters(in: .whitespaces).isEmpty {
                continue
            }
            
            let columns = parseCSVRow(row)
            
            // Expecting: Name, Address, City, State, ZIP, Phone, Website, Latitude, Longitude
            guard columns.count >= 9 else {
                print("⚠️ Skipping row with insufficient columns: \(row)")
                continue
            }
            
            let name = columns[0].trimmingCharacters(in: .whitespaces)
            let address = columns[1].trimmingCharacters(in: .whitespaces)
            let city = columns[2].trimmingCharacters(in: .whitespaces)
            let state = columns[3].trimmingCharacters(in: .whitespaces)
            let zip = columns[4].trimmingCharacters(in: .whitespaces)
            let phone = columns[5].trimmingCharacters(in: .whitespaces)
            let website = columns[6].trimmingCharacters(in: .whitespaces)
            let latString = columns[7].trimmingCharacters(in: .whitespaces)
            let lonString = columns[8].trimmingCharacters(in: .whitespaces)
            
            // Skip if name is empty
            guard !name.isEmpty else { continue }
            
            // Parse coordinates
            guard let lat = Double(latString), let lon = Double(lonString) else {
                print("⚠️ Invalid coordinates for \(name): lat=\(latString), lon=\(lonString)")
                continue
            }
            
            let phoneValue = phone.isEmpty ? nil : phone
            let websiteValue = website.isEmpty ? nil : website
            
            let pantry = createPantry(
                name: name,
                address: address,
                city: city,
                state: state,
                zip: zip,
                phone: phoneValue,
                website: websiteValue,
                lat: lat,
                lon: lon
            )
            
            pantries.append(pantry)
        }
        
        return pantries
    }
    
    // Parse a single CSV row, handling quoted fields that may contain commas
    private func parseCSVRow(_ row: String) -> [String] {
        var fields: [String] = []
        var currentField = ""
        var insideQuotes = false
        
        for char in row {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                fields.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
        }
        
        // Add the last field
        fields.append(currentField)
        
        return fields
    }
    
    private override init() {
        super.init()
        print("🔵 LocationManager singleton initialized - will request location permission")
        manager.delegate = self
        // Request permission immediately when LocationManager is created
        checkLocationAuthorization()
        // Load pantries from Google Sheets
        loadPantriesFromGoogleSheets()
    }
    
    func checkLocationAuthorization(){
        print("🔵 Checking location authorization status: \(manager.authorizationStatus.rawValue)")
        
        switch manager.authorizationStatus{
        case .notDetermined:
            print("📍 Location not determined - requesting permission NOW")
            locationReady = false
            manager.requestWhenInUseAuthorization()
            print("📍 Permission request sent - waiting for user response...")
            
        case .restricted:
            print("⛔️ Location restricted")
            locationReady = false
            
        case .denied:
            print("⛔️ Location denied by user")
            locationReady = false
            
        case .authorizedAlways, .authorizedWhenInUse:
            print("✅ Location authorized - starting location updates")
            locationReady = false // Will be set to true when we get first location
            manager.startUpdatingLocation()
            
        @unknown default:
            print("⚠️ Location service disabled")
            locationReady = false
        }
    }
    
    //when location authorization changes, this function runs to check and save the new location authorization state
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        print("🔄 Location authorization changed to: \(manager.authorizationStatus.rawValue)")
        checkLocationAuthorization()
    }
    
    //updates location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        lastKnownLocation = location.coordinate
        
        if !locationReady {
            print("📍 First location received: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            locationReady = true
        }
    }
    
    func findPantries(){
        guard locationReady, let userLocation = lastKnownLocation else {
            print("Location not ready yet, cannot fetch pantries")
            return
        }
        
        isLoadingPantries = true
        
        //defining map and query
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "food bank, food pantry"
        request.region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        //search
        let search = MKLocalSearch(request: request)
        search.start{ (response, error) in
            guard let response = response else {
                print("Search Failed"+String(error?.localizedDescription ?? "Unknown Error"))
                self.isLoadingPantries = false
                return
            }
            let mapItems = response.mapItems
            
            //trying to remove convenience stores and other food related places
            let filteredPantries = mapItems.filter { item in
                if let category = item.pointOfInterestCategory {
                    if category == .restaurant || category == .foodMarket {
                        return false
                    }
                }
                return true
            }

            self.pantries = filteredPantries
            
            // Combine MapKit results with all known NJ pantries
            var combinedPantries = filteredPantries
            combinedPantries.append(contentsOf: self.knownNJPantries)
            
            // Sort all pantries by distance (closest first)
            let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            combinedPantries.sort(by: {
                let distance1 = $0.placemark.location?.distance(from: userCLLocation) ?? Double.greatestFiniteMagnitude
                let distance2 = $1.placemark.location?.distance(from: userCLLocation) ?? Double.greatestFiniteMagnitude
                return distance1 < distance2
            })
            
            // Limit to 20 pantries
            self.allPantries = Array(combinedPantries.prefix(20))
            
            // Debug output
            print("Found \(self.allPantries.count) pantries (including \(self.knownNJPantries.count) known NJ pantries + MapKit results)")
            for (index, pantry) in self.allPantries.enumerated() {
                let distance = pantry.placemark.location?.distance(from: userCLLocation) ?? 0
                let distanceInMiles = distance * 0.000621371
                print("\(index + 1). \(pantry.name ?? "Unknown") - \(String(format: "%.1f", distanceInMiles)) miles")
            }
            
            self.isLoadingPantries = false
        }
    }
    
    func generateSnapshot(for coordinate: CLLocationCoordinate2D, size: CGSize = CGSize(width: 200, height: 200), completion: @escaping (UIImage?) -> Void) {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        options.size = size
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Snapshot error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            //code to get pin on the snapshot
            let image = snapshot.image
            let point = snapshot.point(for: coordinate)

            let format = UIGraphicsImageRendererFormat.default()
            format.scale = image.scale

            let renderer = UIGraphicsImageRenderer(size: image.size, format: format)

            let finalImage = renderer.image { context in
                image.draw(at: .zero)
                let marker = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: nil)
                marker.markerTintColor = .red
                marker.glyphImage = UIImage()
                marker.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
                let markerRenderer = UIGraphicsImageRenderer(size: marker.bounds.size)
                let markerImage = markerRenderer.image { _ in
                    marker.drawHierarchy(in: marker.bounds, afterScreenUpdates: true)
                }
                
                markerImage.draw(at: point)
            }

            completion(finalImage)
        }
    }
}
