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

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    //controls user location
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    
    //controls authentication
    var manager = CLLocationManager()
    
    @Published var pantries: [MKMapItem] = []
    
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
        request.naturalLanguageQuery = "food bank"
        request.region = MKCoordinateRegion(center: lastKnownLocation ?? CLLocationCoordinate2D(latitude: 40.4578517, longitude: -74.6598009), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        //search
        let search = MKLocalSearch(request: request)
        search.start{ (response, error) in
            guard let response = response else {
                print("Search Failed"+String(error?.localizedDescription ?? "Unknown Error"))
                return
        }
            let mapItems = response.mapItems
            self.pantries = mapItems
            print(self.pantries)
            print(self.lastKnownLocation ?? CLLocationCoordinate2D(latitude: 40, longitude: -74))
            
            //display name, image, and hours
            /*self.pantries.sort(by: {
                $0.placemark.location?.distance(from: CLLocation(latitude: self.lastKnownLocation?.latitude ?? 40.4578517, longitude: self.lastKnownLocation?.longitude ?? -74.6598009)) ?? 1000
                < $1.placemark.location?.distance(from: CLLocation(latitude: self.lastKnownLocation?.latitude ?? 40.4578517, longitude: self.lastKnownLocation?.longitude ?? -74.6598009)) ?? 1000
            })*/
            /*var distancePantries = pantries.map{pantryLocation -> (pantryLocation: pantry, distance: CLLocationDistance) in
                let pantryLocation = CLLocation(latitude: pantry.latitude, longitude: pantry.longitude)
                let distance = lastKnownLocation.distance(from: pantryLocation)
                return (pantryLocation, distance)
            }*/
            
        }
    }
    
    func generateSnapshot(for coordinate: CLLocationCoordinate2D, size: CGSize = CGSize(width: 300, height: 200), completion: @escaping (UIImage?) -> Void) {
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
            completion(snapshot.image)
        }
    }
}
