//
//  Location.swift
//  PantryLink
//
//  Created by Michael Youtz on 10/1/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    //controls user location
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    
    //controls authentication
    var manager = CLLocationManager()
    
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
}
