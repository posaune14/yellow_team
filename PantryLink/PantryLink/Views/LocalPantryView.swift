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
                .fill(.stockLightTan)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 25)
                .fill(.stockDarkTan)
                .frame(width:350, height:350)
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
                            SnapshotImageView(coordinate: pantry.placemark.coordinate, location: location)
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                            Button(action: {
                                popUp = true
                                })
                            {
                                Text(pantry.name ?? "none").frame(maxWidth: 300)
                            }.padding(.bottom, 40)
                             .frame(maxWidth: 300)
                        }.sheet(isPresented: $popUp){
                            LocalPantryPopUpView(pantryAddress: ("\(pantry.placemark.subThoroughfare ?? "") \(pantry.placemark.thoroughfare ?? "") \(pantry.placemark.locality ?? "") \(pantry.placemark.administrativeArea ?? "") \(pantry.placemark.postalCode ?? "")"), pantryNumber: pantry.phoneNumber ?? "none", pantryURL: pantry.url).presentationDetents([.fraction(1/4)])
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 285)
            }
        }.onAppear{
            location.checkLocationAuthorization()
            location.findPantries()
        }
    }
}

#Preview {
    LocalPantryView()
}
