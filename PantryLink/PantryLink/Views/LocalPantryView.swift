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
    @State var popUp = false
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Colors.flexibleWhite)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 25)
                .fill(.stockDarkTan)
                .frame(width:350, height:450)
                .shadow(radius: 10)
            VStack{
                Text("Local Pantries")
                    .bold()
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.bottom, 0)
                
                TabView{
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
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                            
                            Button(action: {
                                popUp = true
                                })
                            {
                                Text(pantry.name ?? "none").frame(maxWidth: 300)
                            }
                            .frame(maxWidth: 300)
                            
                            
                            
                        }.sheet(isPresented: $popUp){
                            LocalPantryPopUpView(pantryAddress: ("\(pantry.placemark.subThoroughfare ?? "") \(pantry.placemark.thoroughfare ?? "") \(pantry.placemark.locality ?? "") \(pantry.placemark.administrativeArea ?? "") \(pantry.placemark.postalCode ?? "")"), pantryNumber: pantry.phoneNumber ?? "none", pantryURL: pantry.url).presentationDetents([.fraction(1/4)])
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 325)
                .padding()
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
}

#Preview {
    LocalPantryView()
}
