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

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    //controls user location
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    
    //controls authentication
    var manager = CLLocationManager()
    
    @Published var pantries: [MKMapItem] = []
    @Published var montgomery = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.42146272431577, longitude: -74.70969731904897)))
    
    func checkLocationAuthorization(){
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus{
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("Location restricted")
            
        case .denied:
            print("Location denied")
            
        case .authorizedAlways:
            print("Location authorizedAlways")
            
        case .authorizedWhenInUse:
            print("Location authorized when in use")
            lastKnownLocation = manager.location?.coordinate
            
        @unknown default:
            print("Location service disabled")
        }
    }
    
    //when location authorization changes, this function runs to check and save the new location authorization state
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        checkLocationAuthorization()
    }
    
    //updates location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
    //make this asynchronous?
    func findPantries(){
        //defining map and query
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "food bank, food pantry"
        request.region = MKCoordinateRegion(center: lastKnownLocation ?? CLLocationCoordinate2D(latitude: 40.4578517, longitude: -74.6598009), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        //search
        let search = MKLocalSearch(request: request)
        search.start{ (response, error) in
            guard let response = response else {
                print("Search Failed"+String(error?.localizedDescription ?? "Unknown Error"))
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
            
            print(self.pantries)
            print(self.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 40, longitude: -74))
            
            //display name, image, and hours
            self.pantries.sort(by: {
                $0.placemark.location?.distance(from: CLLocation(latitude: self.lastKnownLocation?.latitude ?? 40.4578517, longitude: self.lastKnownLocation?.longitude ?? -74.6598009)) ?? 1000
                < $1.placemark.location?.distance(from: CLLocation(latitude: self.lastKnownLocation?.latitude ?? 40.4578517, longitude: self.lastKnownLocation?.longitude ?? -74.6598009)) ?? 1000
            })
            
            /*var distancePantries = pantries.map{pantryLocation -> (pantryLocation: pantry, distance: CLLocationDistance) in
                let pantryLocation = CLLocation(latitude: pantry.latitude, longitude: pantry.longitude)
                let distance = lastKnownLocation.distance(from: pantryLocation)
                return (pantryLocation, distance)
            }*/
            
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
