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
                TabView{
                    ForEach(location.pantries, id: \.self) { pantry in
                        VStack{
                            SnapshotImageView(coordinate: pantry.placemark.coordinate, location: location)
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                            Button(action: {
                                popUp = true
                                print(pantry.address)
                                   })
                            {
                                Text(pantry.name ?? "none")
                            }
                        }.sheet(isPresented: $popUp){
                            LocalPantryPopUpView(pantryAddress: pantry.address, pantryNumber: pantry.phoneNumber ?? "none", pantryURL: pantry.url)
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

struct SnapshotImageView: View {
    let coordinate: CLLocationCoordinate2D
    @State private var snapshot: UIImage?
    @StateObject var location: LocationManager

    var body: some View {
        Group {
            if let image = snapshot {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if snapshot == nil {
                location.generateSnapshot(for: coordinate) { image in
                    self.snapshot = image
                }
            }
        }
    }
}

#Preview {
    LocalPantryView()
}
