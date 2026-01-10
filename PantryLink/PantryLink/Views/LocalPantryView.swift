//
//  LocalPantryView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 8/6/25.
//

import SwiftUI
import MapKit

struct LocalPantryView: View {
    @StateObject var location = LocationManager()
    let options: MKMapSnapshotter.Options = .init()
    @State var popUp1 = false
    @State var popUp2 = false
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isIPad: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Colors.flexibleWhite)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 25)
                .fill(.stockDarkTan)
                .frame(width: isIPad ? 600 : 350, height: isIPad ? 600 : 470)
                .shadow(radius: 10)
            VStack{
                Text("Local Pantries")
                    .bold()
                    .foregroundColor(.white)
                    .font(.title)
               //     .padding(.bottom, 0)
                
                TabView{
                    
                    //partner food banks we know
                    VStack(spacing: 20){
                        Button(action: {
                            openMontgomeryInMaps()
                        }) {
                            HStack(spacing: 4) {
                                Text("Directions")
                                    .font(.caption)
                                Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                    .font(.caption)
                            }
                            .padding(6)
                            .background(Colors.flexibleWhite)
                            .cornerRadius(6)
                            .foregroundColor(Colors.flexibleBlack)
                        }
                        .padding(.bottom, 10)
                        
                        SnapshotImageView(coordinate: location.montgomery.placemark.coordinate, location: location)
                            .frame(width: isIPad ? 550 : 300, height: isIPad ? 350 : 200)
                            .cornerRadius(10)
                        
                        Button(action: {
                            popUp1 = true
                        })
                        {
                            Text("Montgomery Food Pantry").frame(maxWidth: isIPad ? 550 : 300)
                                .foregroundStyle(.white)
                                .underline()
                        }
                        .padding(.bottom, 40)
                        .frame(maxWidth: isIPad ? 550 : 300)
                    }
                    .sheet(isPresented: $popUp1){
                        LocalPantryPopUpView(pantryAddress: "356 Skillman Road Skillman, NJ 08558", pantryNumber: "609-446-1054", pantryURL: URL(string: "https://www.montgomerynj.gov/600/Food-Resources")).presentationDetents([.fraction(1/4)])
                    }
                    
                    ForEach(location.pantries, id: \.self) { pantry in
                        VStack(spacing: 20){
                            Button(action: {
                                openPantryInMaps(pantry: pantry)
                            }) {
                                HStack(spacing: 4) {
                                    Text("Directions")
                                        .font(.caption)
                                    Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                        .font(.caption)
                                }
                                .padding(6)
                                .background(Colors.flexibleWhite)
                                .cornerRadius(6)
                                .foregroundColor(Colors.flexibleBlack)
                            }
                            .padding(.bottom, 10)
                            SnapshotImageView(coordinate: pantry.placemark.coordinate, location: location)
                                .frame(width: isIPad ? 550 : 300, height: isIPad ? 350 : 200)
                                .cornerRadius(10)
                            
                            Button(action: {
                                popUp2 = true
                                })
                            {
                                Text(pantry.name ?? "none").frame(maxWidth: isIPad ? 550 : 300)
                                    .foregroundStyle(.flexibleWhite)
                                    .underline()
                            }.padding(.bottom, 40)
                             .frame(maxWidth: isIPad ? 550 : 300)
                        }.sheet(isPresented: $popUp2){
                            LocalPantryPopUpView(pantryAddress: ("\(pantry.placemark.subThoroughfare ?? "") \(pantry.placemark.thoroughfare ?? "") \(pantry.placemark.locality ?? "") \(pantry.placemark.administrativeArea ?? "") \(pantry.placemark.postalCode ?? "")"), pantryNumber: pantry.phoneNumber ?? "none", pantryURL: pantry.url).presentationDetents([.fraction(1/4)])
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: isIPad ? 485 : 355)
             //   .padding()
            }
        }.onAppear{
            location.checkLocationAuthorization()
            location.findPantries()
        }
    }
    
    // Open Apple Maps with the pantry location
    func openPantryInMaps(pantry: MKMapItem) {
        let regionDistance: CLLocationDistance = 500
        guard let coordinates = pantry.placemark.location?.coordinate else { return }
        
        let regionSpan = MKCoordinateRegion(center: coordinates,
                                            latitudinalMeters: regionDistance,
                                            longitudinalMeters: regionDistance)
        
        let mapItem = MKMapItem(placemark: MKPlacemark(placemark: pantry.placemark))
        mapItem.name = pantry.name
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ])
    }
    
    // Open Apple Maps with Montgomery Food Pantry location
    func openMontgomeryInMaps() {
        let regionDistance: CLLocationDistance = 500
        let coordinates = location.montgomery.placemark.coordinate
        
        let regionSpan = MKCoordinateRegion(center: coordinates,
                                            latitudinalMeters: regionDistance,
                                            longitudinalMeters: regionDistance)
        
        let mapItem = MKMapItem(placemark: MKPlacemark(placemark: location.montgomery.placemark))
        mapItem.name = "Montgomery Food Pantry"
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ])
    }
}

#Preview {
    LocalPantryView()
}
